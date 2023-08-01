# Configure the Azure provider
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}

# resource_group
resource "azurerm_resource_group" "app-rg" {
  name = "slotDemoResourceGroup"
  location = "westus2"
}

# service plan
resource "azurerm_app_service_plan" "app-plan" {
  name                = "service-plan"
  location            = azurerm_resource_group.app-rg.location
  resource_group_name = azurerm_resource_group.app-rg.name
  kind = "Linux"
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# create app service
resource "azurerm_app_service" "app-service" {
  name                = "slotAppService"
  location            = azurerm_resource_group.app-rg.location
  resource_group_name = azurerm_resource_group.app-rg.name
  app_service_plan_id = azurerm_app_service_plan.app-plan.id
}



