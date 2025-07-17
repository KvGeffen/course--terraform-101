data "azurerm_client_config" "current" {}

resource "azapi" "rg" {
  type     = "Microsoft.Resources/resourceGroups@2021-04-01"
  name     = "kvg-rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location

  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
}
