resource "azurerm_resource_group" "main" {
  name     = "kvg-rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

resource "random_string" "suffix" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_storage_account" "main" {
  name                     = "kvgst${random_string.suffix.result}001"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "main" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
