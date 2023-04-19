
output "appi_key_apim" {
  value = azurerm_application_insights.appi.connection_string
}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.workspace.id
}