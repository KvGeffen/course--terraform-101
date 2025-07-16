resource "azurerm_resource_group" "kvg_main" {
  name     = "kvg-rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}
