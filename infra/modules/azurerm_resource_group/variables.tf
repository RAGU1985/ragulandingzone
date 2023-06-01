variable "environment" {
  type        = string
  description = "environment type"
}

variable "virtual_network_name" {
  type = string
}

variable "net_location" {
  type        = string
  description = "azure region for the resource"
}

variable "net_rg_name" {
  type        = string
  description = "name of the resource"
}

variable "net_additional_tags" {
  type        = map(string)
  description = "Additional Network resources tags, in addition to the resource group tags."
  default     = {}
}

variable "resource_groups" {
  description = "Resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
  default = {}
}

variable "virtual_networks" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
  description = "name of the resource"
}

variable "subnets" {
  description = "The virtal networks subnets with their properties."
  type = map(object({
    name              = string
    vnet_key          = string
    vnet_name         = string
    address_prefixes  = list(string)
    pe_enable         = bool
    service_endpoints = list(string)
    delegation = list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
  default = {}
}

variable "vnet_peering" {
  type = map(object({
    #shared_subscription = string
    destination_vnet_name                 = string
    destination_vnet_rg                   = string
    remote_destination_virtual_network_id = string
    #remote_source_virtual_network_id = string
    source_vnet_name             = string
    source_vnet_rg               = string
    allow_forwarded_traffic      = bool
    allow_virtual_network_access = bool
    allow_gateway_transit        = bool
    use_remote_gateways          = bool
  }))
  description = "Specifies the map of objects for vnet peering."
  default     = {}
}

variable "network_security_groups" {
  type = map(object({
    name = string
    tags = map(string)
    # subnet_key                = string
    subnet_name = string
    # networking_resource_group = string
    security_rules = list(object({
      name                         = string
      description                  = string
      protocol                     = string
      direction                    = string
      access                       = string
      priority                     = number
      source_address_prefix        = string
      source_address_prefixes      = list(string)
      destination_address_prefix   = string
      destination_address_prefixes = list(string)
      source_port_range            = string
      source_port_ranges           = list(string)
      destination_port_range       = string
      destination_port_ranges      = list(string)
    }))
  }))
  description = "The network security groups with their properties."
  default     = {}
}