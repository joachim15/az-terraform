output "sqlServerName" {
  value = azurerm_mssql_server.azuresqlserver.fully_qualified_domain_name
}
output "" {
  value = azurerm_mssql_database._database.name
}
output "" {
  value = azurerm_mssql_database.database.name
}
output "sqlProviderDatabaseName" {
  value = azurerm_mssql_database.sqlprovider_database.name
}