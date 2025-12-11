# 1. Create the Private Link Scope
resource "azurerm_monitor_private_link_scope" "ampls" {
  name                = "ai-ampls"
  resource_group_name = azurerm_resource_group.dep.name
  tags                = {}
}

# 2. Link App Insights to the Scope
resource "azurerm_monitor_private_link_scoped_service" "app_insights_link" {
  name                = "ai-ampls-link-appinsights"
  resource_group_name = azurerm_resource_group.dep.name
  scope_name          = azurerm_monitor_private_link_scope.ampls.name
  linked_resource_id  = module.app-insights.resource_id
}

module "pe_vault" {
  source = "Azure/avm-res-network-privateendpoint/azurerm"

  enable_telemetry               = var.enable_telemetry # see variables.tf
  name                           = local.private_endpoint_name
  location                       = local.location
  resource_group_name            = azurerm_resource_group.dep.name
  network_interface_name         = local.network_interface_name
  private_connection_resource_id = module.vault.resource_id
  subnet_resource_id             = module.vnet.subnets["pe-subnet"].resource_id
  subresource_names              = ["vault"]
}


# Private Endpoint for Storage Account (Blob)
module "pe_storage_blob" {
  source = "Azure/avm-res-network-privateendpoint/azurerm"

  enable_telemetry               = var.enable_telemetry
  name                           = "ai-pe-storage-blob"
  location                       = local.location
  resource_group_name            = azurerm_resource_group.dep.name
  network_interface_name         = "ai-nic-storage-blob"
  private_connection_resource_id = module.storage.resource_id
  subnet_resource_id             = module.vnet.subnets["pe-subnet"].resource_id
  subresource_names              = ["blob"]
}

# Private Endpoint for Azure Monitor (AMPLS)
module "pe_app_insights" {
  source = "Azure/avm-res-network-privateendpoint/azurerm"

  enable_telemetry       = var.enable_telemetry
  name                   = "ai-pe-ampls" # Renaming suggested for clarity
  location               = local.location
  resource_group_name    = azurerm_resource_group.dep.name
  network_interface_name = "ai-nic-ampls"

  # CHANGE THIS: Point to the AMPLS resource created above
  private_connection_resource_id = azurerm_monitor_private_link_scope.ampls.id 

  subnet_resource_id = module.vnet.subnets["pe-subnet"].resource_id
  subresource_names  = ["azuremonitor"]
}

module "private_dns_keyvault_vault" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "~> 0.2"

  parent_id   = azurerm_resource_group.dep.id
  domain_name = "privatelink.vaultcore.azure.net"
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.notebooks.azureml.ms"
      vnetid       = module.vnet.resource.id
    }
  }
  tags             = {}
  enable_telemetry = var.enable_telemetry
}

module "private_dns_storageaccount_blob" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "~> 0.2"

  parent_id   = azurerm_resource_group.dep.id
  domain_name = "privatelink.blob.core.windows.net"
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.blob.core.windows.net"
      vnetid       = module.vnet.resource.id
    }
  }
  tags             = {}
  enable_telemetry = var.enable_telemetry
}

module "private_dns_storageaccount_file" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "~> 0.2"

  parent_id   = azurerm_resource_group.dep.id
  domain_name = "privatelink.file.core.windows.net"
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.file.core.windows.net"
      vnetid       = module.vnet.resource.id
    }
  }
  tags             = {}
  enable_telemetry = var.enable_telemetry
}

module "private_dns_aml_notebooks" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "~> 0.2"

  parent_id   = azurerm_resource_group.dep.id
  domain_name = "privatelink.notebooks.azure.net"
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.notebooks.azureml.ms"
      vnetid       = module.vnet.resource.id
    }
  }
  tags             = {}
  enable_telemetry = var.enable_telemetry
}

module "private_dns_aml_api" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "~> 0.2"

  parent_id   = azurerm_resource_group.dep.id
  domain_name = "privatelink.api.azureml.ms"
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.api.azureml.ms"
      vnetid       = module.vnet.resource.id
    }
  }
  tags             = {}
  enable_telemetry = var.enable_telemetry
}