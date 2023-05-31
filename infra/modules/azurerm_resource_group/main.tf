resource "azurerm_resource_group" "resource_group" {
  name     = var.net_rg_name
  location = var.location
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
}

locals {
  vnets   = zipmap(var.vnet_names, var.address_space)
  subnets = zipmap(var.subnet_names, var.subnet_prefixes)
}
resource "azurerm_virtual_network" "virtual_network" {
  for_each            = local.vnets
  name                = each.key
  location            = var.location
  resource_group_name = var.net_rg_name
  address_space       = [each.value]
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
  depends_on = [azurerm_resource_group.resource_group]
}
resource "azurerm_subnet" "subnet" {
  for_each             = local.subnets
  name                 = each.key
  virtual_network_name = values(azurerm_virtual_network.virtual_network)[0].name
  resource_group_name  = var.net_rg_name
  address_prefixes     = [each.value]
  depends_on           = [azurerm_virtual_network.virtual_network]
}

resource "azurerm_virtual_network_peering" "source_to_destination" {
  name                         = format("%s-to-%s", values(azurerm_virtual_network.virtual_network)[0].name, values(azurerm_virtual_network.virtual_network)[1].name)
  resource_group_name          = var.net_rg_name
  remote_virtual_network_id    = "/subscriptions/d7caf0f4-7c69-4c4a-af92-3b52493f74ca/resourceGroups/${var.net_rg_name}/providers/Microsoft.Network/virtualNetworks/${values(azurerm_virtual_network.virtual_network)[1].name}"
  virtual_network_name         = values(azurerm_virtual_network.virtual_network)[0].name
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.virtual_network]

  lifecycle {
    ignore_changes = [remote_virtual_network_id]
  }
}

resource "azurerm_virtual_network_peering" "destination_to_source" {
  name                         = format("%s-to-%s", values(azurerm_virtual_network.virtual_network)[1].name, values(azurerm_virtual_network.virtual_network)[0].name)
  resource_group_name          = var.net_rg_name
  remote_virtual_network_id    = "/subscriptions/d7caf0f4-7c69-4c4a-af92-3b52493f74ca/resourceGroups/${var.net_rg_name}/providers/Microsoft.Network/virtualNetworks/${values(azurerm_virtual_network.virtual_network)[0].name}"
  virtual_network_name         = values(azurerm_virtual_network.virtual_network)[1].name
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.virtual_network]

  lifecycle {
    ignore_changes = [remote_virtual_network_id]
  }
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "nsg-allowbastion-001"
  location            = var.location
  resource_group_name = var.net_rg_name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  for_each                  = azurerm_subnet.subnet
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
  depends_on                = [azurerm_network_security_group.network_security_group]
}