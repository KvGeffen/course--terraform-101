data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "kvg-rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

resource "azurerm_public_ip" "vm1" {
  name                = "kvg-pip-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

data "azurerm_subnet" "alpha" {
  name                 = "kvg-snet-alpha-network-${var.environment_name}"
  resource_group_name  = "kvg-rg-network-${var.environment_name}"
  virtual_network_name = "kvg-vnet-network-${var.environment_name}"
}

resource "azurerm_network_interface" "vm1" {
  name                = "kvg-nic-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.alpha.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1.id
  }
}

resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "kvgvm1${var.application_name}${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm1.id
  ]

  patch_assessment_mode = "ImageDefault"

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm1.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }


}

resource "local_file" "private_key" {
  content         = tls_private_key.vm1.private_key_pem
  filename        = pathexpand("~/.ssh/vm1")
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content  = tls_private_key.vm1.public_key_openssh
  filename = pathexpand("~/.ssh/vm1.pub")
}
