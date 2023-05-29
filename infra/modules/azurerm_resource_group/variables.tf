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

variable "vnet1" {
  type        = string
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
  type        = string
  description = "name of the resource"
}