
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.36.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.7.2"
    }
  }

  backend "azurerm" {
    #     resource_group_name  = "kvg-rg-tf101-dev"
    #     storage_account_name = "kvgst8v3zjd4om8001"
    #     container_name       = "tfstate"
    #     key                  = "observability-dev"
  }
}

provider "azurerm" {
  #   subscription_id = "c59cb858-b5c2-4699-8eb2-398034c73ab0"te
  features {}
}
