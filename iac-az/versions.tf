# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.10"
    }
  }

  backend "azurerm" {}

  required_version = ">= 1.2.8"

}