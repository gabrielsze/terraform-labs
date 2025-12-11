module "compute-vm" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"

  enable_telemetry    = var.enable_telemetry
  location            = local.location
  resource_group_name = azurerm_resource_group.dep.name
  os_type             = "Linux"
  name                = local.virtual_machine_name
  # Changed from Standard_B2s (unavailable in zone 1) to Standard_DC1ds_v3
  # Reason: Standard_B2s has capacity restrictions in eastus zone 1
  # Standard_DC1ds_v3 is available in zone 3 with no subscription restrictions
  # See: az vm list-skus output showing Standard_DC1ds_v3 zones: 3 with Restrictions: None
  sku_size            = "Standard_DC1ds_v3"
  zone                = "3" # Zone 3 has better availability for unrestricted SKUs

  generated_secrets_key_vault_secret_config = {
    key_vault_resource_id = module.vault.resource_id
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  network_interfaces = {
    network_interface_1 = {
      name = local.virtual_machine_nic_name
      ip_configurations = {
        ip_configuration_1 = {
          name = "ipconfig1"
          # Only private IP assigned - no public_ip_address_id specified
          # This keeps the VM private and only accessible via Bastion or internal network
          # For public access, add: public_ip_address_id = azurerm_public_ip.vm_pip.id
          private_ip_subnet_resource_id = module.vnet.subnets["compute-subnet"].resource_id
        }
      }
    }
  }

  tags = {
    environment = "Lab"
  }

  depends_on = [
    module.vault
  ]
}

# COMMENTED OUT: vm_sku module
# Reason: All Standard_D series SKUs are marked as "NotAvailableForSubscription" in eastus
# The sku-finder module was attempting to filter for D-series VMs with specific requirements:
# - 2 vCPUs with encryption_at_host and accelerated networking support
# - But subscription restrictions prevent D-series deployment in this region
# Available alternatives for eastus zone 3: Standard_DC1ds_v3, Standard_DC2ds_v3, etc.
# For zone 1: Standard_B2s (current) works without restrictions
#
# module "vm_sku" {
#   source  = "Azure/avm-utl-sku-finder/azapi"
#   version = "0.3.0"
#
#   location      = local.location
#   cache_results = true
#
#   vm_filters = {
#     min_vcpus                      = 2
#     max_vcpus                      = 2
#     encryption_at_host_supported   = true
#     accelerated_networking_enabled = true
#     premium_io_supported           = true
#     location_zone                  = local.virtual_machine_zone
#   }
# }
