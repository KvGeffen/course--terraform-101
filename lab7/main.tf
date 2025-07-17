data "azapi_client_config" "current" {}

resource "azapi_resource" "rg" {
  type     = "Microsoft.Resources/resourceGroups@2021-04-01"
  name     = "kvg-rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location

  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
}

resource "azapi_resource" "vm_pip" {
  type      = "Microsoft.Network/publicIPAddresses@2024-07-01"
  name      = "kvg-pip-${var.application_name}-${var.environment_name}"
  parent_id = azapi_resource.rg.id
  location  = azapi_resource.rg.location

  body = {
    properties = {
      publicIPAllocationMethod = "Static"
      publicIPAddressVersion   = "IPv4"
    }
    sku = {
      name = "Standard"
    }
  }
}

data "azapi_resource" "network_rg" {
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "kvg-rg-network-${var.environment_name}"
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
}

data "azapi_resource" "vnet" {
  type      = "Microsoft.Network/virtualNetworks@2024-07-01"
  name      = "kvg-vnet-network-${var.environment_name}"
  parent_id = data.azapi_resource.network_rg.id
}

data "azapi_resource" "subnet_beta" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-07-01"
  name      = "kvg-snet-beta-network-${var.environment_name}"
  parent_id = data.azapi_resource.vnet.id

  response_export_values = ["name"]
}

resource "azapi_resource" "vm_nic" {
  type      = "Microsoft.Network/networkInterfaces@2024-07-01"
  name      = "kvg-nic-${var.application_name}-${var.environment_name}"
  parent_id = azapi_resource.rg.id
  location  = azapi_resource.rg.location
  body = {

    properties = {
      ipConfigurations = [
        {
          name = "public"
          properties = {
            subnet = {
              id = data.azapi_resource.subnet_beta.id
            }
            privateIPAllocationMethod = "Dynamic"
            publicIPAddress = {
              id = azapi_resource.vm_pip.id
            }
          }
        }
      ]
    }
  }
}

resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azapi_resource" "devops_rg" {
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "kvg-rg-devops-${var.environment_name}"
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
}

data "azapi_resource" "key_vault" {
  type      = "Microsoft.KeyVault/vaults@2024-11-01"
  name      = "kvg-kv-devops-${var.environment_name}-mt2z9e"
  parent_id = data.azapi_resource.devops_rg.id
}

resource "azapi_resource" "vm1_ssh_private" {
  type      = "Microsoft.KeyVault/vaults/secrets@2024-11-01"
  name      = "vm1-ssh-private"
  parent_id = data.azapi_resource.key_vault.id
  body = {
    properties = {
      value = tls_private_key.vm1.private_key_pem
    }
  }
}

resource "azapi_resource" "vm1_ssh_public" {
  type      = "Microsoft.KeyVault/vaults/secrets@2024-11-01"
  name      = "vm1-ssh-public"
  parent_id = data.azapi_resource.key_vault.id
  body = {
    properties = {
      value = tls_private_key.vm1.public_key_openssh
    }
  }
}

resource "azapi_resource" "vm1" {
  type      = "Microsoft.Compute/virtualMachines@2024-11-01"
  name      = "vm1${var.application_name}${var.environment_name}"
  parent_id = azapi_resource.rg.id
  location  = azapi_resource.rg.location
  body = {
    properties = {

      networkProfile = {
        networkInterfaces = [
          {
            id = azapi_resource.vm_nic.id
          }
        ]
      }

      hardwareProfile = {
        vmSize = "Standard_B2s"
      }
      storageProfile = {

        imageReference = {
          publisher = "Canonical"
          offer     = "0001-com-ubuntu-server-jammy"
          sku       = "22_04-lts-gen2"
          version   = "latest"
        }

        osDisk = {
          caching      = "ReadWrite"
          createOption = "FromImage"
          managedDisk = {
            storageAccountType = "Standard_LRS"
          }
        }

      }

      osProfile = {
        adminUsername = "adminuser"
        computerName  = "kvgvm1${var.application_name}${var.environment_name}"
        linuxConfiguration = {
          ssh = {
            publicKeys = [
              {
                path    = "/home/adminuser/.ssh/authorized_keys"
                keyData = tls_private_key.vm1.public_key_openssh
              }
            ]
          }
        }
      }

    }

  }

  identity {
    type = "SystemAssigned"
  }
}
