variable "environment" {
  type        = string
  description = "environment type"
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