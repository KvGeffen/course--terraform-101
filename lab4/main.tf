data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "kvg-rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

resource "random_string" "keyvault_suffic" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "main" {
  name                = "kvg-kv-${var.application_name}-${var.environment_name}-${random_string.keyvault_suffic.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "terraform_user" {
  scope                = azurerm_key_vault.main.id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
}

data "azurerm_log_analytics_workspace" "observability" {
  name                = "kvg-law-obesrvability-${var.environment_name}"
  resource_group_name = "kvg-rg-obesrvability-${var.environment_name}"
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  name               = "${var.application_name}-${var.environment_name}-${random_string.keyvault_suffic.result}"
  target_resource_id = azurerm_key_vault.main.id

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.observability.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
