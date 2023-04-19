resource "azurerm_monitor_action_group" "vm_group" {
  name                = "vm-action-group-${var.customer_name}"
  resource_group_name = var.resource_group_name
  short_name          = "vmgroup"

  dynamic "email_receiver" {
    # Get only vm group emails
    for_each = [
      for g in var.emails : g
      if g.group == "vm_group"
    ]
    content {
      name          = email_receiver.value.name
      email_address = email_receiver.value.email_address
    }
  }
}

# Alerting Action for http 5xx
resource "azurerm_monitor_scheduled_query_rules_alert" "alert_5xx" {
  name                = "alert_rule-5xx-${var.customer_name}"
  location            = var.region_location
  resource_group_name = var.resource_group_name
  description         = "Trigger alerts for all 5xx errors"
  data_source_id      = var.log_analytics_workspace_id
  enabled             = true

  action {
    action_group = [azurerm_monitor_action_group.vm_group.id]
  }
  trigger {
    operator  = "GreaterThan"
    threshold = 2
  }
  # Count all requests with server error result code grouped into 5-minute bins
  query       = <<-QUERY
  requests
    | where tolong(resultCode) >= 500
    | summarize count() by bin(timestamp, 2m)
  QUERY
  severity    = 1
  frequency   = 5
  time_window = 30
}

# Alerting Action for http 4xx
resource "azurerm_monitor_scheduled_query_rules_alert" "alert_4xx" {
  name                = "alert_rule-4xx-${var.customer_name}"
  location            = var.region_location
  resource_group_name = var.resource_group_name
  description         = "Trigger alerts for all 4xx errors"
  data_source_id      = var.log_analytics_workspace_id
  enabled             = true

  action {
    action_group = [azurerm_monitor_action_group.vm_group.id]
  }
  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 15
  }
  # Count all requests with server error result code grouped into 5-minute bins
  query       = <<-QUERY
  requests
    | where tolong(resultCode) == 400
    | summarize count() by bin(timestamp, 10m)
  QUERY
  severity    = 1
  frequency   = 5
  time_window = 30
}
