data "azurerm_client_config" "current" {}

data "azurerm_public_ip" "pip_ubuntu" {
  count = var.create_public_ip ? var.publicIpInstanceCount.ubuntu : 0

  name                = azurerm_public_ip.pip_ubuntu[count.index].name
  resource_group_name = local.resource_group.name

  depends_on = [module.linux_ubuntu]
}

data "azurerm_public_ip" "pip_centos" {
  count = var.create_public_ip ? var.publicIpInstanceCount.centos : 0

  name                = azurerm_public_ip.pip_centos[count.index].name
  resource_group_name = local.resource_group.name

  depends_on = [module.linux_centos]
}
