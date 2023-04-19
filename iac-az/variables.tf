# For Resource group
variable "customer_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Production"
  }
}

variable "vnet_address_space" {
  type    = string
  default = "10.0.0.0/16"
}

variable "snet_address_prefixes" {
  type    = string
  default = "10.0.2.0/24"
}

variable "sql_admin_username" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "storage_account_account_tier" {
  type = string
}

variable "storage_account_replication_type" {
  type = string
}

variable "database_size" {
  type    = number
  default = 256
}

variable "vm_backup_SLA" {
  type = string
}

variable "certificateConfig" {
  type = any
}

variable "sql_loginType" {
  type = string
}

# locals {
#   subscription_id = "/subscriptions/09945b22-1c82-4bc7-8d25-986038cf1f8a"
#   environment     = "dev"
# }

# variable "resource_group_name_prefix" {
#   default = "mv2"
# }
# variable "azure_sql_account_tier" {
#   default = "Standard"
# }
# variable "azure_sql_replication_type" {
#   default = "LRS"
# }
# variable "resource_group_name_suffix" {
#   type        = string
#   description = "Enables a suffix to be append at the end the resource group name for uniqueness."
# }

# variable "storage_account_name" {
#   default = ""
#   type    = string
# }
# variable "container_name" {
#   default = ""
#   type    = string
# }
# variable "key" {
#   default = ""
#   type    = string
# }
