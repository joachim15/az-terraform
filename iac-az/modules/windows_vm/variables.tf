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

variable "vm_configurations" {
  type = map(string)
}

variable "vm_backup_SLA" {
  type = number
}

variable "subnet_id" {
  type = string
}

variable "public_ip_vm" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "nsg_rules" {
  type = any
}

variable "prefix" {
  type = string
}

variable "azure_devops_organization" {
  default = "paperless-ise"
}

variable "azure_devops_teamproject" {
  default = "Test"
}

variable "azure_devops_deploymentgroup" {
  default = ""
  type    = string
}

variable "storage_account_account_tier" {
  type = string
}

variable "storage_account_replication_type" {
  type = string
}

variable "keyvault_settings" {
  type = any

}
