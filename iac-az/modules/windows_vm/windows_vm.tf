resource "azurerm_storage_account" "azure_storage_account" {
  name                     = format("stvm%sprod${var.instance_suffix}", substr(replace(var.customer_name, "-", ""), 0, 22))
  resource_group_name      = var.resource_group_name
  location                 = var.region_location
  account_tier             = var.storage_account_account_tier
  account_replication_type = var.storage_account_replication_type
}

resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_name  = azurerm_storage_account.azure_storage_account.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "blob" {
  name                   = "register-agent.ps1"
  storage_account_name   = azurerm_storage_account.azure_storage_account.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source_content         = local.register_agent_script
}


resource "azurerm_storage_blob" "sql_auth" {
  name                   = "enable-sql-mode.ps1"
  storage_account_name   = azurerm_storage_account.azure_storage_account.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source_content         = local.sql_authentication
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  location            = var.region_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_vm
  }
}

resource "azurerm_network_security_group" "nsg_group" {
  name                = "nsg-${var.prefix}-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  location            = var.region_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg_group.id
}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each                = var.nsg_rules
  name                    = each.value.name
  description             = each.value.description
  priority                = each.value.priority
  direction               = each.value.direction
  access                  = each.value.access
  protocol                = each.value.protocol
  source_port_range       = each.value.source_port_range
  destination_port_range  = each.value.destination_port_range
  source_address_prefixes = each.value.source_address_prefixes
  # source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_group.name
}

resource "azurerm_windows_virtual_machine" "windows" {
  name                = "vm-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  computer_name       = upper(format("%s%s", substr(var.customer_name, 0, 13), var.instance_suffix))
  resource_group_name = var.resource_group_name
  location            = var.region_location
  size                = "Standard_A2_v2"
  admin_username      = "vmtestuser"
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.vm_configurations.disk_size_gb
  }

  source_image_reference {
    publisher = var.vm_configurations.publisher
    offer     = var.vm_configurations.offer
    sku       = var.vm_configurations.sku
    version   = var.vm_configurations.version
  }

  secret {
    key_vault_id = var.keyvault_settings.keyvault_id
    certificate {
      store = "My" # this is the location where the certificates stores and IIS can pick from here Cert:\LocalMachine\My
      url   = var.keyvault_settings.secret_url
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_virtual_machine_extension" "install-features" {
  count                = var.vm_configurations.install_iis == "yes" ? 1 : 0
  name                 = "vm-features"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  timeouts {
    create = "60m"
    delete = "2h"
  }

  depends_on = [
    azurerm_storage_blob.blob
  ]

  settings = <<SETTINGS
      {
        "fileUris": ["https://${azurerm_storage_container.scripts.storage_account_name}.blob.core.windows.net/${azurerm_storage_container.scripts.name}/${azurerm_storage_blob.blob.name}"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted ./${azurerm_storage_blob.blob.name}"
      }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "enable_sql_authentication" {
  count                = var.vm_configurations.enable_sql_auth == "yes" ? 1 : 0
  name                 = "enable-sql-auth-mode"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  timeouts {
    create = "60m"
    delete = "2h"
  }

  depends_on = [
    azurerm_storage_blob.sql_auth
  ]

  settings = <<SETTINGS
      {
        "fileUris": ["https://${azurerm_storage_container.scripts.storage_account_name}.blob.core.windows.net/${azurerm_storage_container.scripts.name}/${azurerm_storage_blob.sql_auth.name}"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted ./${azurerm_storage_blob.sql_auth.name}"
      }
SETTINGS
}

# Azure VM backup
resource "azurerm_backup_protected_vm" "vm_backup" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vm_recovery_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.windows.id
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup_policy.id
}

resource "azurerm_recovery_services_vault" "vm_recovery_vault" {
  name                = "vm-vault-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  location            = var.region_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

resource "azurerm_backup_policy_vm" "vm_backup_policy" {
  name                = "vm-backup-policy-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vm_recovery_vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    # hour_interval = var.vm_backup_SLA
    time = "23:00"
  }
  retention_daily {
    count = 7
  }
}
