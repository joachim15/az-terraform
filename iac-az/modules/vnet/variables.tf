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

variable "vnet_address_space" {
  type = string
}

variable "snet_address_prefixes" {
  type = string
}
