resource "random_id" "id" {
  byte_length = 2
}

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

locals {
  linux_instance_count_sum = (var.linux_instance_count.centos + var.linux_instance_count.ubuntu)
}

module "vnet" {
  source = "../vnet"

  resource_group_name = local.resource_group.name
  use_for_each = false
  vnet_location = local.resource_group.location
  address_space = ["192.168.0.0/16"]
  vnet_name = "vnet-vm-${random_id.id.hex}"
  subnet_names = ["subnet-${random_id.id.hex}"]
  subnet_prefixes = ["192.168.0.0/24"]
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

resource "azurerm_public_ip" "pip_ubuntu" {
  count = var.create_public_ip ? var.publicIpInstanceCount.ubuntu : 0

  allocation_method   = "Dynamic"
  location            = local.resource_group.location
  name                = "pip-${random_id.id.hex}-ubuntu-${count.index}"
  resource_group_name = local.resource_group.name
}

resource "azurerm_public_ip" "pip_centos" {
  count = var.create_public_ip ? var.publicIpInstanceCount.centos : 0

  allocation_method   = "Dynamic"
  location            = local.resource_group.location
  name                = "pip-${random_id.id.hex}-centos-${count.index}"
  resource_group_name = local.resource_group.name
}

#module "openai" {
#  source = "../openai"
#
#  resource_group_name = local.resource_group.name
#  location = local.resource_group.location
#  public_network_access_enabled = true
#  deployment = {
#    "gpt-35-turbo" = {
#      name          = "gpt-35-turbo"
#      model_format  = "OpenAI"
#      model_name    = "gpt-35-turbo"
#      model_version = "0301"
#      scale_type    = "Standard"
#    }
#  }
#  depends_on = [
#    azurerm_resource_group.rg
#  ]
#}

module "linux_ubuntu" {
  source = "../virtual_machine"

  location = local.resource_group.location
  image_os = "linux"
  linux_instance_count = var.linux_instance_count.ubuntu
  resource_group_name = local.resource_group.name
  allow_extension_operations = false
#  data_disks = [
#    for i in range(1) : {
#      name                 = "linuxdisk${random_id.id.hex}${i}"
#      storage_account_type = "Standard_LRS"
#      create_option        = "Empty"
#      disk_size_gb         = 5
#      attach_setting = {
#        lun     = i
#        caching = "ReadWrite"
#      }
#    }
#  ]
  new_network_interface = {
    ip_forwarding_enabled = false
    network_interface_number = var.linux_instance_count.ubuntu
    ip_configurations = [
      {
#        public_ip_address_id = try([azurerm_public_ip.pip[0].id, azurerm_public_ip.pip[1].id, azurerm_public_ip.pip[2].id], null)
        public_ip_address_id = try([for pip in azurerm_public_ip.pip_ubuntu: pip.id], null)
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
  name = "ubuntu-${random_id.id.hex}"
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  os_simple = "UbuntuServer"
  size = var.size
  subnet_id = module.vnet.vnet_subnets[0]
}

module "linux_centos" {
  source = "../virtual_machine"

  location = local.resource_group.location
  image_os = "linux"
  linux_instance_count = var.linux_instance_count.centos
  resource_group_name = local.resource_group.name
  allow_extension_operations = false
  #  data_disks = [
  #    for i in range(1) : {
  #      name                 = "linuxdisk${random_id.id.hex}${i}"
  #      storage_account_type = "Standard_LRS"
  #      create_option        = "Empty"
  #      disk_size_gb         = 5
  #      attach_setting = {
  #        lun     = i
  #        caching = "ReadWrite"
  #      }
  #    }
  #  ]
  new_network_interface = {
    ip_forwarding_enabled = false
    network_interface_number = var.linux_instance_count.centos
    ip_configurations = [
      {
        #        public_ip_address_id = try([azurerm_public_ip.pip[0].id, azurerm_public_ip.pip[1].id, azurerm_public_ip.pip[2].id], null)
        public_ip_address_id = try([for pip in azurerm_public_ip.pip_centos: pip.id], null)
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
  name = "CentOS-${random_id.id.hex}"
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  os_simple = "CentOS"
  size = var.size
  subnet_id = module.vnet.vnet_subnets[0]
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
    for_each = var.create_public_ip ? ["apache2"] : []

    content {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "apache2"
      priority                   = 201
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "80"
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
      priority                   = 202
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "6017"
      source_port_range          = "*"
      source_address_prefix      = "*"
    }
  }
}



resource "azurerm_network_interface_security_group_association" "linux_ubuntu_nic" {
  count = var.linux_instance_count.ubuntu

  network_interface_id      = module.linux_ubuntu.network_interface_id[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "linux_centos_nic" {
  count = var.linux_instance_count.centos

  network_interface_id      = module.linux_centos.network_interface_id[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# print ssh_private_key
resource "local_file" "ssh_private_key" {
  filename = "${path.module}/key-ansible.pem"
  content  = tls_private_key.ssh.private_key_pem
}

