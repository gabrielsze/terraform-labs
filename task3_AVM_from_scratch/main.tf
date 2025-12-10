module "avm-res-resources-resourcegroup" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.1"
  location = var.location
  name     = var.name
}

# Creating a virtual network with a unique name, telemetry settings, and in the specified resource group and location.
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.16.0"

  location         = var.location
  name             = "vnet-task3-001"
  parent_id        = module.avm-res-resources-resourcegroup.resource_id
  address_space    = ["10.0.0.0/16"]
  enable_telemetry = true
}

module "avm-res-network-virtualnetwork_subnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "0.16.0"

  name           = "subnet-task3-001"
  parent_id      = module.vnet.resource_id
  address_prefix = "10.0.0.0/24"
}

resource "random_string" "unique_name" {
  length  = 3
  special = false
  upper   = false
  lower   = true
  numeric = false
}

locals {
  storage_account_name = "stdemo${random_string.unique_name.result}"
}

module "private_dns_zone" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.4.0"

  domain_name = "privatelink.blob.core.windows.net"
  parent_id   = module.avm-res-resources-resourcegroup.resource_id
  virtual_network_links = {
    vnetlink1 = {
      name   = "storage-account"
      vnetid = module.vnet.resource_id
    }
  }
}

module "avm-res-storage-storageaccount" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.6.7"
  location            = var.location
  name                = local.storage_account_name
  resource_group_name = module.avm-res-resources-resourcegroup.name
  
  private_endpoints = {
    blob = {
      name                           = "pe-blob-task3"
      private_dns_zone_resource_ids  = [module.private_dns_zone.resource_id]
      subnet_resource_id             = module.avm-res-network-virtualnetwork_subnet.resource_id
      subresource_name               = "blob"
    }
  }
}
