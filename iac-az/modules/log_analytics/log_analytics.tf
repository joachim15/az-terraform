# -
# - Log Analytics Workspace
# -  Log Analytics is a tool in the Azure portal to edit and run log queries from data collected by Azure Monitor Logs and interactively analyze their results
# -
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "workspce-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  location            = var.region_location
  resource_group_name = var.resource_group_name
  sku               = "PerGB2018"
  retention_in_days = 180 #(Optional) The workspace data retention in days. Possible values range between 30 and 730.
  tags              = var.tags
}

# Application Insights for Windows
resource "azurerm_application_insights" "appi" {
  name                = "appi-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  location            = var.region_location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.workspace.id
  application_type    = "web"
  tags                = var.tags
}
