data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "kvg-rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}
