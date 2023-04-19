resource "azurerm_storage_account" "azure_storage_account" {
  name                     = format("stsql%sprod001", substr(replace(var.customer_name, "-", ""), 0, 22))
  resource_group_name      = var.resource_group_name
  location                 = var.region_location
  account_tier             = var.storage_account_account_tier
  account_replication_type = var.storage_account_replication_type
}

resource "azurerm_mssql_server" "azuresqlserver" {
  name                         = "sql-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  resource_group_name          = var.resource_group_name
  location                     = var.region_location
  version                      = var.sql_server_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  identity {
    type = "SystemAssigned"
  }
  depends_on = [
    azurerm_storage_account.azure_storage_account
  ]
}

resource "azurerm_mssql_virtual_network_rule" "Test_sqlvnetrule" {
  name      = "sql-vnet-rule"
  server_id = azurerm_mssql_server.azuresqlserver.id
  subnet_id = var.subnet_id
}

resource "azurerm_mssql_firewall_rule" "Test_firewall_rule" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.azuresqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "Test_database" {
  name           = format("sqldb-%s-001", var.customer_name)
  server_id      = azurerm_mssql_server.azuresqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = var.database_size
  read_scale     = false
  sku_name       = "Basic"
  zone_redundant = false

  lifecycle {
    ignore_changes = [
      license_type
    ]
  }
}

resource "azurerm_mssql_database_extended_auditing_policy" "Test_extended_auditing_policy" {
  database_id                             = azurerm_mssql_database.Test_database.id
  storage_endpoint                        = azurerm_storage_account.azure_storage_account.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.azure_storage_account.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}

resource "azurerm_mssql_database" "oagis_database" {
  name           = format("sqldb-%s-002", var.customer_name)
  server_id      = azurerm_mssql_server.azuresqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = var.database_size
  read_scale     = false
  sku_name       = "Basic"
  zone_redundant = false

  lifecycle {
    ignore_changes = [
      license_type
    ]
  }
}

resource "azurerm_mssql_database_extended_auditing_policy" "oagis_extended_auditing_policy" {
  database_id                             = azurerm_mssql_database.oagis_database.id
  storage_endpoint                        = azurerm_storage_account.azure_storage_account.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.azure_storage_account.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}

resource "azurerm_mssql_database" "sqlprovider_database" {
  name           = format("sqldb-%s-003", var.customer_name)
  server_id      = azurerm_mssql_server.azuresqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = var.database_size
  read_scale     = false
  sku_name       = "Basic"
  zone_redundant = false

  lifecycle {
    ignore_changes = [
      license_type
    ]
  }
}

resource "azurerm_mssql_database_extended_auditing_policy" "sqlprovider_extended_auditing_policy" {
  database_id                             = azurerm_mssql_database.sqlprovider_database.id
  storage_endpoint                        = azurerm_storage_account.azure_storage_account.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.azure_storage_account.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}
