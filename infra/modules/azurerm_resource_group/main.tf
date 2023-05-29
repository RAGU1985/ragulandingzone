resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.location
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet1
  location            = var.location
  resource_group_name = var.name
  address_space       = each.address_space
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
}