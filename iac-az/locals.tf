locals {
  # Virtual Machine for application
  vm_configurations = {
    publisher    = "MicrosoftWindowsServer"
    offer        = "WindowsServer"
    sku          = "2019-Datacenter"
    version      = "latest"
    disk_size_gb = 256
    install_iis  = "yes"
    enable_sql_auth = "no"
  }

  # Virtual machine for sql server
  sql_vm_configurations = {
    publisher       = "MicrosoftSQLServer"
    offer           = "SQL2019-ws2019"
    sku             = "Standard"
    version         = "latest"
    disk_size_gb    = 256
    install_iis     = "no"
    enable_sql_auth = "yes"
  }

  nsg_rules_vm = {
    AllowRDP = {
      name                    = "AllowRDPInbound"
      description             = "Allow RDP connections to vm"
      priority                = "100"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      source_address_prefixes = ["ip", "ip", "ip", ]
      # source_address_prefix      = "ip"
      destination_address_prefix = "*"
      destination_port_range     = "3389"
    }
    AllowHTTP = {
      name                    = "AllowHTTPInbound"
      description             = "Allow http connections to vm"
      priority                = "101"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      source_address_prefixes = ["ip", "ip", "ip", ]
      # source_address_prefix      = "ip"
      destination_address_prefix = "*"
      destination_port_range     = "80"
    }
    AllowHTTPS = {
      name                    = "AllowHTTPSInbound"
      description             = "Allow https connections to vm"
      priority                = "102"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      source_address_prefixes = ["ip", "ip", "ip", ]
      # source_address_prefix      = "ip"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    }
  }

  nsg_rules_sql = {
    AllowRDP = {
      name                    = "AllowRDPInbound"
      description             = "Allow RDP connections to vm"
      priority                = "100"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      source_address_prefixes = ["ip", "ip", "ip", ]
      # source_address_prefix      = "ip"
      destination_address_prefix = "*"
      destination_port_range     = "3389"
    }
    AllowSQL = {
      name                    = "AllowSQLInbound"
      description             = "Allow SQL port 1433 connections to vm"
      priority                = "101"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      source_address_prefixes = ["ip", "ip", "ip", ]
      # source_address_prefix      = "ip"
      destination_address_prefix = "*"
      destination_port_range     = "1433"
    }
  }

  # Alert emails
  emails = csvdecode(file("emails_id.csv"))

}

