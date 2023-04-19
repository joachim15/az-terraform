# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  address_space       = [var.vnet_address_space]
  location            = var.region_location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.snet_address_prefixes]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_public_ip" "public_ip_vm" {
  name                = "pip-vm-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.region_location
  allocation_method   = "Static"
  domain_name_label   = var.customer_name
  sku                 = "Standard"
}

resource "azurerm_public_ip" "public_ip_sql" {
  name                = "pip-sql-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.region_location
  allocation_method   = "Static"
  domain_name_label   = "${var.customer_name}sql"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "public_ip_vmtest" {
  name                = "pip-vmtest-${var.customer_name}-prod-${var.region_location}-${var.instance_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.region_location
  allocation_method   = "Static"
  domain_name_label   = "${var.customer_name}vmtest"
  sku                 = "Standard"
}
