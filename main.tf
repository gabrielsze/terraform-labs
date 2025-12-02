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

module "demo" {
  source = "./modules/demo"

  prefix = var.prefix
  region = var.region
  resource_groups = var.resource_groups
  virtual_networks = var.virtual_networks
  tags = var.tags
}