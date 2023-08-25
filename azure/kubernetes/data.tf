data "azurerm_client_config" "current" {}

data "azurerm_public_ip" "pip_controller" {
  count = var.create_public_ip ? var.publicIpInstanceCount.controller : 0

  name                = azurerm_public_ip.pip_controller[count.index].name
  resource_group_name = local.resource_group.name

  depends_on = [module.linux_controller]
}

data "azurerm_public_ip" "pip_worker" {
  count = var.create_public_ip ? var.publicIpInstanceCount.worker : 0

  name                = azurerm_public_ip.pip_worker[count.index].name
  resource_group_name = local.resource_group.name

  depends_on = [module.linux_worker]
}
