resource "random_id" "id" {
  byte_length = 2
}

# create resource group
resource "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 1: 0

  location = var.location
  name     = coalesce(var.resource_group_name, "tf-custom-module-${random_id.id.hex}")
}

locals {
  resource_group = {
    name = try(azurerm_resource_group.rg[0].name, var.resource_group_name)
    location = var.location
  }
}

# create vnet
module "vnet" {
  source = "../vnet"

  resource_group_name = local.resource_group.name
  use_for_each = false
  vnet_location = local.resource_group.location
  address_space = ["10.240.0.0/24"]
  vnet_name = "vnet-vm-${random_id.id.hex}"
  subnet_names = ["subnet-${random_id.id.hex}"]
  subnet_prefixes = ["10.240.0.0/24"]
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# create ssh private key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

# create control public ip
resource "azurerm_public_ip" "pip_controller" {
  count = var.create_public_ip ? var.publicIpInstanceCount.controller : 0

  allocation_method   = "Dynamic"
  location            = local.resource_group.location
  name                = "pip-${random_id.id.hex}-controller-${count.index}"
  resource_group_name = local.resource_group.name
}

# create controller vm
module "linux_controller" {
  source = "../virtual_machine"

  location = local.resource_group.location
  image_os = "linux"
  linux_instance_count = var.linux_instance_count.controller
  resource_group_name = local.resource_group.name
  allow_extension_operations = false
  new_network_interface = {
    ip_forwarding_enabled = false
    network_interface_number = var.linux_instance_count.controller
    ip_configurations = [
      {
        public_ip_address_id = try([for pip in azurerm_public_ip.pip_controller: pip.id], null)
        primary              = true
      }
    ]
  }
  admin_username = "azureuser"
  admin_ssh_keys = [
    {
      public_key = tls_private_key.ssh.public_key_openssh
    }
  ]
  name = "controller-${random_id.id.hex}"
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  os_simple = "UbuntuServer"
  size = "Standard_B2s"
  subnet_id = module.vnet.vnet_subnets[0]
  tags = {
    "resource": "kubernetes-the-kubespray-way"
    "types": "controller"
  }
}

# create worker public ip
resource "azurerm_public_ip" "pip_worker" {
  count = var.create_public_ip ? var.publicIpInstanceCount.worker : 0

  allocation_method   = "Dynamic"
  location            = local.resource_group.location
  name                = "pip-${random_id.id.hex}-worker-${count.index}"
  resource_group_name = local.resource_group.name
}

# create worker vm
module "linux_worker" {
  source = "../virtual_machine"

  location = local.resource_group.location
  image_os = "linux"
  linux_instance_count = var.linux_instance_count.worker
  resource_group_name = local.resource_group.name
  allow_extension_operations = false
  new_network_interface = {
    ip_forwarding_enabled = false
    network_interface_number = var.linux_instance_count.worker
    ip_configurations = [
      {
        public_ip_address_id = try([for pip in azurerm_public_ip.pip_worker: pip.id], null)
        primary              = true
      }
    ]
  }
  admin_username = "azureuser"
  admin_ssh_keys = [
    {
      public_key = tls_private_key.ssh.public_key_openssh
    }
  ]
  name = "worker-${random_id.id.hex}"
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  os_simple = "UbuntuServer"
  size = var.size
  subnet_id = module.vnet.vnet_subnets[0]

  tags = {
    "resource": "kubernetes-the-kubespray-way"
    "types": "controller"
  }
}


# create nsg
resource "azurerm_network_security_group" "nsg" {
  location            = local.resource_group.location
  name                = "nsg-${random_id.id.hex}"
  resource_group_name = local.resource_group.name

  dynamic "security_rule" {
    for_each = var.create_public_ip ? ["ssh"] : []

    content {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "ssh"
      priority                   = 200
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "22"
      source_port_range          = "*"
      source_address_prefix      = "*"
    }
  }

  dynamic "security_rule" {
    for_each = var.create_public_ip ? ["http"] : []

    content {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "http"
      priority                   = 201
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "80"
      source_port_range          = "*"
      source_address_prefix      = "*"
    }
  }

  dynamic "security_rule" {
    for_each = var.create_public_ip ? ["apiServer"] : []

    content {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "apiServer"
      priority                   = 202
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "6443"
      source_port_range          = "*"
      source_address_prefix      = "*"
    }
  }

  dynamic "security_rule" {
    for_each = var.create_public_ip ? ["Icmp"] : []

    content {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "Icmp"
      priority                   = 203
      protocol                   = "Icmp"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      source_port_range          = "*"
      source_address_prefix      = "*"
    }
  }

  dynamic "security_rule" {
    for_each = var.create_public_ip ? ["Https"] : []

    content {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "Https"
      priority                   = 204
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      source_port_range          = "*"
      source_address_prefix      = "*"
    }
  }

  dynamic "security_rule" {
    for_each = var.create_public_ip ? ["vpn"] : []

    content {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "vpn"
      priority                   = 205
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "1086"
      source_port_range          = "*"
      source_address_prefix      = "*"
    }
  }
}


# security group binding controller vm
resource "azurerm_network_interface_security_group_association" "linux_controller_nic" {
  count = var.linux_instance_count.controller

  network_interface_id      = module.linux_controller.network_interface_id[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# security group binding worker vm
resource "azurerm_network_interface_security_group_association" "linux_worker_nic" {
  count = var.linux_instance_count.worker

  network_interface_id      = module.linux_worker.network_interface_id[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# print ssh_private_key
resource "local_file" "ssh_private_key" {
  filename = "${path.module}/key-k8s.pem"
  content  = tls_private_key.ssh.private_key_pem
  file_permission = "0400"
}

