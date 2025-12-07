module "vnet" {
  source    = "Azure/avm-res-network-virtualnetwork/azurerm"
  version   = "0.16.0"
  location  = local.location
  name      = local.virtual_network_name
  parent_id = azurerm_resource_group.dep.id

  address_space = ["192.168.0.0/16"]

  dns_servers = {
    dns_servers = ["8.8.8.8"]
  }

  role_assignments = {
    role1 = {
      principal_id               = azurerm_user_assigned_identity.this.principal_id
      role_definition_id_or_name = "Contributor"
    }
  }

  enable_vm_protection = true

  encryption = {
    enabled     = true
    enforcement = "AllowUnencrypted"
  }

  flow_timeout_in_minutes = 30

  subnets = {
    compute-subnet = {
      name                            = local.subnet_compute_name
      default_outbound_access_enabled = false
      address_prefixes                = ["192.168.0.0/24"]
    }
    bastion-subnet = {
      name                            = local.subnet_bastion_name
      default_outbound_access_enabled = false
      address_prefixes                = ["192.168.1.0/24"]
    }
    pe-subnet = {
      name                            = local.subnet_pe_name
      default_outbound_access_enabled = false
      address_prefixes                = ["192.168.2.0/24"]
    }
    private_endpoints = {
      name                            = local.subnet_private_endpoints_name
      default_outbound_access_enabled = false
      address_prefixes                = ["192.168.3.0/24"]
    }
  }
  tags = {
    environment = "Lab"
  }
}
