variable "region_location" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "customer_name" {
  type = string
}

variable "emails" {
  type = any
}

variable "tags" {
  type = map(string)
}
