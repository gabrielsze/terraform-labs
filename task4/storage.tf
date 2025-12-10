module "storage" {
  source              = "Azure/avm-res-storage-storageaccount/azurerm"
  resource_group_name = azurerm_resource_group.dep.name
  location            = azurerm_resource_group.dep.location
  name                = local.storage_account_name

  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # some policy seems to be preventing this from being enabled
  shared_access_key_enabled = false

  role_assignments = {
    "contributor-role" = {
      principal_id               = azurerm_user_assigned_identity.this.principal_id
      role_definition_id_or_name = "Contributor"
    }
  }
}