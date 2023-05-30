variable "environment" {
  type        = string
  description = "environment type"
}

variable "location" {
  type        = string
  description = "azure region for the resource"
}

variable "name" {
  type        = string
  description = "name of the resource"
}

variable "vnet_names" {
  type        = list(string)
  description = "name of the resource"
}

variable "address_space" {
  type        = list(string)
  description = "name of the resource"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "name of the resource"
}

variable "subnet_names" {
  type        = list(string)
  description = "name of the resource"
}

variable "nsg_names" {
  type        = list(string)
  description = "name of the resource"
}