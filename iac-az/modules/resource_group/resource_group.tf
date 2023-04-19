# 
# Resource group
# 
resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  location = var.region_location
  tags     = var.tags
}
