terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "core"
}


resource "azurerm_resource_group" "contoso_rg" {
  name     = "contoso_rg"
  location = "UK South"
}