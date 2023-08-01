data "azurerm_client_config" "current" {}

data "azurerm_public_ip" "pip" {
  count = var.create_public_ip ? 1 : 0

  name                = azurerm_public_ip.pip[count.index].name
  resource_group_name = local.resource_group.name

  depends_on = [module.linux]
}
