module "naming" {
  source  = "Azure/naming/azurerm"
  version = " >= 0.3.0"
}


module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.3.0"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

resource "azurerm_resource_group" "dep" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = "${module.naming.resource_group.name_unique}-dep"
}

resource "azurerm_user_assigned_identity" "this" {
  location            = azurerm_resource_group.dep.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = azurerm_resource_group.dep.name
}
