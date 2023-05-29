#variable "environment" {
#  type        = string
#  description = "environment type"
#}
#
#variable "location" {
#  type        = string
#  description = "azure region for the resource"
#}
#
#variable "name" {
#  type        = string
#  description = "name of the resource"
#}

variable "resource_config" {
  type = map(object({
    // Define the configuration attributes for the resource
    name     = string
    location = string
  }))
  default     = {}
}