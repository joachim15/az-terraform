# --- Key Vault section

data "azurerm_client_config" "current" {}

#Create Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.customer_name}-prod"
  location                    = var.region_location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  tags                        = var.tags
  sku_name                    = "standard"
  enabled_for_deployment      = true
  # purge_protection_enabled   = true

  lifecycle {
    # prevent_destroy = true
  }
}

##
# Assign get certificate permissions to the executing account so it can access it
resource "azurerm_key_vault_access_policy" "kvPermissionss" {
  for_each     = toset(var.certificateConfig.access_policy)
  key_vault_id = azurerm_key_vault.kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = each.key
  # object_id = data.azurerm_client_config.current.object_id

  certificate_permissions = [
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    #"purge",
    "SetIssuers",
    "Update",
    #"write"
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]
}

# Upload certificate to Key vault
resource "azurerm_key_vault_certificate" "kvCertificate" {
  name         = "Testmescertificate"
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64("./modules/keyvault/certificates/${var.certificateConfig.certificateName}")
    password = var.certificateConfig.certificatePasword
  }

  #certificate {
  # contents = var.certificateConfig.certificateName
  # password = var.certificateConfig.certificatePasword
  # }

  certificate_policy {
    issuer_parameters {
      name = var.certificateConfig.certificateIssuer
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}

