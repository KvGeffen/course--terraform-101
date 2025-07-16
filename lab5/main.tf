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



resource "azurerm_network_security_group" "remote_access" {
  name                = "kvg-nsg-${var.application_name}-${var.environment_name}-remote-access"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22"]
    source_address_prefix      = chomp(jsondecode(data.http.ip.response_body).ip)
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "alpha" {
  subnet_id                 = azurerm_subnet.alpha.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}

resource "azurerm_subnet_network_security_group_association" "beta" {
  subnet_id                 = azurerm_subnet.beta.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}

resource "azurerm_subnet_network_security_group_association" "gamma" {
  subnet_id                 = azurerm_subnet.gamma.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}

resource "azurerm_subnet_network_security_group_association" "delta" {
  subnet_id                 = azurerm_subnet.delta.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}

data "http" "ip" {
  url = "https://api.ipify.org?format=json"
}
