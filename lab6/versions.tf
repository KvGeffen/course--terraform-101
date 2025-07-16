
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
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
  backend "azurerm" {
    #   resource_group_name  = "kvg-rg-tf101-dev"
    #   storage_account_name = "kvgst8v3zjd4om8001"
    #   container_name       = "tfstate"
    #   key                  = "devops-dev"
  }
}

provider "tls" {
  # Configuration options
}

provider "azurerm" {
  #   subscription_id = "c59cb858-b5c2-4699-8eb2-398034c73ab0"te
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted_secrets = true
    }
  }
}
