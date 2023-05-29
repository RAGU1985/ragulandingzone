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
  address_space       = var.address_space
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
  depends_on = [ azurerm_resource_group.resource_group ]
}

locals {
  subnets = zipmap(var.subnet_names, var.subnet_prefixes)
}
resource "azurerm_subnet" "subnet" {
  for_each             = local.subnets
  name                 = each.key
  virtual_network_name = var.vnet1
  resource_group_name  = var.name
  address_prefixes     = [each.value]
  depends_on = [ azurerm_virtual_network.virtual_network ]
}
