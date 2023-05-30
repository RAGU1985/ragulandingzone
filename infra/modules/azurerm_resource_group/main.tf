resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.location
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
}

locals {
  vnets = zipmap(var.vnet_names, var.address_space)
}
resource "azurerm_virtual_network" "virtual_network" {
  for_each            = local.vnets
  name                = each.key
  location            = var.location
  resource_group_name = var.name
  address_space       = [each.value]
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
  depends_on = [azurerm_resource_group.resource_group]
}

locals {
  subnets = zipmap(var.subnet_names, var.subnet_prefixes)
}
resource "azurerm_subnet" "subnet" {
  for_each             = local.subnets
  name                 = each.key
  virtual_network_name = "vnet-spoke-1"
  resource_group_name  = var.name
  address_prefixes     = [each.value]
  depends_on           = [azurerm_virtual_network.virtual_network]
}
