data "azurerm_client_config" "this" {}

module "vault" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  resource_group_name = azurerm_resource_group.dep.name
  location            = local.location
  name                = local.key_vault_name

  sku_name = "standard"

  # Enable public network so selected IP rules are honored (still blocked by default_action = "Deny")
  public_network_access_enabled = true

  network_acls = {
    bypass           = "AzureServices"
    default_action   = "Deny"
    ip_rules         = ["115.66.195.0/32"]
  }

  role_assignments = {
    "contributor-role" = {
      principal_id               = azurerm_user_assigned_identity.this.principal_id
      role_definition_id_or_name = "Contributor"
    }
  }

  legacy_access_policies_enabled = true
  legacy_access_policies = {
    test = {
      object_id          = data.azurerm_client_config.this.object_id
      tenant_id          = data.azurerm_client_config.this.tenant_id
      secret_permissions = ["Get", "List", "Set", "Delete"]
    }
  }
  tenant_id = data.azurerm_client_config.this.tenant_id
}
