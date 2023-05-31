data "azurerm_resource_group" "this" {
  name = var.net_rg_name
}

data "azurerm_virtual_network" "this" {
  for_each            = local.existing_vnets
  name                = each.value
  resource_group_name = var.net_rg_name
}

data "azurerm_subnet" "this" {
  for_each             = local.subnet_network_security_group_associations
  name                 = each.value.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.net_rg_name
}

locals {
  location = var.net_location
  tags     = merge(data.azurerm_resource_group.this.tags, var.net_additional_tags)

  existing_vnets = {
    for subnet_k, subnet_v in var.subnets :
    subnet_k => subnet_v.vnet_name if(subnet_v.vnet_key == null && subnet_v.vnet_name != null)
  }
}

locals {
  subnet_network_security_group_associations = {
    for k, v in var.network_security_groups : k => v if(v.subnet_name != null)
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

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.network_security_groups
  name                = each.value["name"]
  location            = var.net_location
  resource_group_name = var.net_rg_name

  dynamic "security_rule" {
    for_each = lookup(each.value, "security_rules", [])
    content {
      name                         = security_rule.value["name"]
      description                  = lookup(security_rule.value, "description", null)
      protocol                     = coalesce(security_rule.value["protocol"], "Tcp")
      direction                    = security_rule.value["direction"]
      access                       = coalesce(security_rule.value["access"], "Allow")
      priority                     = security_rule.value["priority"]
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
    }
  }
  depends_on = [azurerm_subnet.subnet]
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  for_each                  = local.subnet_network_security_group_associations
  subnet_id                 = lookup(data.azurerm_subnet.this, each.key)["id"]
  network_security_group_id = azurerm_network_security_group.nsg[each.key]["id"]
}