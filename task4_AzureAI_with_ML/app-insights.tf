module "app-insights" {
  source = "Azure/avm-res-insights-component/azurerm"
  # ...
  location            = local.location
  name                = local.app_insights_name
  resource_group_name = azurerm_resource_group.dep.name
  workspace_id        = azurerm_log_analytics_workspace.this.id
  enable_telemetry    = var.enable_telemetry # see variables.tf
}

#Log Analytics Workspace for diagnostic settings. Required for workspace-based diagnostic settings.
resource "azurerm_log_analytics_workspace" "this" {
  location            = local.location
  name                = local.log_analytics_workspace_name
  resource_group_name = azurerm_resource_group.dep.name
  sku                 = "PerGB2018"
}