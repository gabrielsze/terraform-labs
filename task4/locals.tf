locals {
  # Define the name of the resource group
  resource_group_name_dep = "ai-dep-rg"
  # Define the name of the resource group
  resource_group_name = "ai-rg"
  # Define the name of the user assigned identity
  user_assigned_identity_name = "ai-identity"
  # Define the name of the lock
  lock_name = "ai-lock"
  # Define the name of the role assignment
  role_assignment_name = "ai-role-assignment"
  # Define the name of the resource group tag
  resource_group_tag = {
    Environment = "Lab"
  }
  # Define the name of location
  location = "East US"

  # Define the name of the virtual network
  virtual_network_name = "ai-vnet"
  # Define the names of subnets
  subnet_compute_name           = "compute-subnet"
  subnet_bastion_name           = "AzureBastionSubnet"
  subnet_pe_name                = "pe-subnet"
  subnet_private_endpoints_name = "private_endpoints"

  # Define the name for virtual machine
  virtual_machine_name = "ai-vm"
  # Define the name for the virtual machine zone
  # Changed from zone "1" to zone "3"
  # Reason: Zone 1 has capacity restrictions for available SKUs
  # Zone 3 offers Standard_DC1ds_v3 with no restrictions (see az vm list-skus output)
  virtual_machine_zone = "3"
  # Define the name for the virtual machine nic
  virtual_machine_nic_name = "ai-vm-nic"

  # Define the name of the key vault
  key_vault_name = "aikv${substr(md5("${azurerm_resource_group.dep.name}"), 0, 4)}"

  # Define the name of the storage account
  storage_account_name = "aist${substr(md5("${azurerm_resource_group.dep.name}"), 0, 8)}"

  # Define the name for the app insights
  app_insights_name = "ai-app-insights"

  # Define the name for the log analytics workspace
  log_analytics_workspace_name = "ai-la"

  # Define the name for the private endpoint
  private_endpoint_name = "ai-pe"

  # Define the name for the network interface
  network_interface_name = "ai-pe-nic"

  # Define the name for the Azure Machine Learning workspace
  machine_learning_workspace_name = "ai-mlws"
}
