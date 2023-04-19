variable "resource_group_name" {
  type = string
}

variable "customer_name" {
  type = string
}

variable "region_location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "instance_suffix" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "database_size" {
  type = number
  default = 2
}

variable "administrator_login" {
  type = string
}

variable "administrator_login_password" {
  type = string
  sensitive = true
}

variable "sql_server_version" {
  type = string
  default = "12.0"
}

variable "storage_account_account_tier" {
  type = string
}
variable "storage_account_replication_type" {
  type = string
}
