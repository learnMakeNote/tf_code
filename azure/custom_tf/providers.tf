terraform {
  required_version = ">= 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11, < 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
#  subscription_id = "960443d4-a1d7-4859-b159-777a78efc511"
#  tenant_id = "513294a0-3e20-41b2-a970-6d30bf1546fa"
}
