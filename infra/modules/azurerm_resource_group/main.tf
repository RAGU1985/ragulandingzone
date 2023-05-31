data "azurerm_resource_group" "this" {
  name = var.net_rg_name
}

data "azurerm_virtual_network" "this" {
  for_each            = local.existing_vnets
  name                = each.value
  resource_group_name = var.net_rg_name
}

locals {
  location = var.net_location
  tags     = merge(data.azurerm_resource_group.this.tags, var.net_additional_tags)

  existing_vnets = {
    for subnet_k, subnet_v in var.subnets :
    subnet_k => subnet_v.vnet_name if(subnet_v.vnet_key == null && subnet_v.vnet_name != null)
  }
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.net_rg_name
  location = var.net_location
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  for_each            = var.virtual_networks
  name                = each.value["name"]
  location            = var.net_location
  resource_group_name = var.net_rg_name
  address_space       = each.value["address_space"]
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
  depends_on = [azurerm_resource_group.resource_group]
}
resource "azurerm_subnet" "subnet" {
  for_each                                      = var.subnets
  name                                          = each.value["name"]
  resource_group_name                           = var.net_rg_name
  address_prefixes                              = each.value["address_prefixes"]
  service_endpoints                             = lookup(each.value, "service_endpoints", null)
  private_endpoint_network_policies_enabled     = coalesce(lookup(each.value, "pe_enable"), false)
  private_link_service_network_policies_enabled = coalesce(lookup(each.value, "pe_enable"), false)
  virtual_network_name                          = each.value.vnet_key != null ? lookup(var.virtual_networks, each.value["vnet_key"])["name"] : data.azurerm_virtual_network.this[each.key].name

  dynamic "delegation" {
    for_each = coalesce(lookup(each.value, "delegation"), [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = coalesce(lookup(delegation.value, "service_delegation"), [])
        content {
          name    = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }

  depends_on = [azurerm_virtual_network.virtual_network]
}

resource "azurerm_virtual_network_peering" "source_to_destination" {
  for_each                     = var.vnet_peering
  name                         = format("%s-to-%s", each.value["source_vnet_name"], each.value["destination_vnet_name"])
  resource_group_name          = each.value["source_vnet_rg"]
  remote_virtual_network_id    = each.value["remote_destination_virtual_network_id"]
  virtual_network_name         = each.value["source_vnet_name"]
  allow_forwarded_traffic      = coalesce(lookup(each.value, "allow_forwarded_traffic"), true)
  allow_virtual_network_access = coalesce(lookup(each.value, "allow_virtual_network_access"), true)
  allow_gateway_transit        = coalesce(lookup(each.value, "allow_gateway_transit"), false)
  use_remote_gateways          = coalesce(lookup(each.value, "use_remote_gateways"), false)

  lifecycle {
    ignore_changes = [remote_virtual_network_id]
  }
  depends_on = [azurerm_virtual_network.virtual_network]
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "nsg-allowbastion-001"
  location            = var.net_location
  resource_group_name = var.net_rg_name

  security_rule {
    name                       = "AllowHTTPsInbound"
    description                = "AllowHTTPsInbound"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 120
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "AllowGatewayManagerInbound"
    description                = "AllowGatewayManagerInbound"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 130
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    description                = "AllowAzureLoadBalancerInbound"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 140
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
  }

  security_rule {
    name                       = "AllowBastionHostCommunication"
    description                = "AllowBastionHostCommunication"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 150
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["8080", "5701"]
  }

  security_rule {
    name                       = "SSHRDP"
    description                = "ssh rdp"
    protocol                   = "Tcp"
    direction                  = "Outbound"
    access                     = "Allow"
    priority                   = 100
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
  }
  security_rule {
    name                       = "AllowAzureCloudOutbound"
    description                = "AllowAzureCloudOutbound"
    protocol                   = "Tcp"
    direction                  = "Outbound"
    access                     = "Allow"
    priority                   = 110
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
    source_port_range          = "*"
    destination_port_range     = "443"
  }
  security_rule {
    name                       = "AllowBastionCommunication"
    description                = "AllowBastionCommunication"
    protocol                   = "*"
    direction                  = "Outbound"
    access                     = "Allow"
    priority                   = 120
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    source_port_range          = "*"
    destination_port_ranges    = ["8080", "5701"]
  }
  security_rule {
    name                       = "AllowHttpOutbound"
    description                = "AllowHttpOutbound"
    protocol                   = "Tcp"
    direction                  = "Outbound"
    access                     = "Allow"
    priority                   = 130
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
    source_port_range          = "*"
    destination_port_range     = "80"
  }

}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  for_each                  = azurerm_subnet.subnet
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
  depends_on                = [azurerm_network_security_group.network_security_group]
}