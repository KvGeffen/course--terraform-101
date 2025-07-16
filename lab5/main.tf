data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "kvg-rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

resource "azurerm_virtual_network" "main" {
  name                = "kvg-vnet-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.base_address_space]
}

locals {
  alpha_address_space = cidrsubnet(var.base_address_space, 2, 0)
  beta_address_space  = cidrsubnet(var.base_address_space, 2, 1)
  gamma_address_space = cidrsubnet(var.base_address_space, 2, 2)
  delta_address_space = cidrsubnet(var.base_address_space, 2, 3)
}

# 10.39.0.0/24
resource "azurerm_subnet" "alpha" {
  name                 = "kvg-snet-alpha-${var.application_name}-${var.environment_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.alpha_address_space]
}

# 10.39.1.0/24
resource "azurerm_subnet" "beta" {
  name                 = "kvg-snet-beta-${var.application_name}-${var.environment_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.beta_address_space]
}

# 10.39.2.0/24
resource "azurerm_subnet" "gamma" {
  name                 = "kvg-snet-gamma-${var.application_name}-${var.environment_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.gamma_address_space]
}

# 10.39.3.0/24
resource "azurerm_subnet" "delta" {
  name                 = "kvg-snet-delta-${var.application_name}-${var.environment_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.delta_address_space]
}
