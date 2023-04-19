variable "certificateConfig" {
  type = any
}

variable "region_location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "resource_group_name" {
  type = string
}

variable "customer_name" {
  type = string
}
