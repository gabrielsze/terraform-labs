resource "azurerm_bastion_host" "this" {
  name                = "bastion"
  location            = local.location
  resource_group_name = azurerm_resource_group.dep.name
  sku                 = "Standard"
  # Removed: virtual_network_id = module.vnet.resource_id
  # Reason: virtual_network_id is only supported with Developer SKU
  # Standard SKU uses subnet_id in ip_configuration instead
  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.vnet.subnets["bastion-subnet"].resource_id
    public_ip_address_id = azurerm_public_ip.this.id
  }
  tags = {
    environment = "Demo"
  }
}

resource "azurerm_public_ip" "this" {
  name                = "bastion-ip"
  location            = local.location
  resource_group_name = azurerm_resource_group.dep.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    environment = "Demo"
  }
}