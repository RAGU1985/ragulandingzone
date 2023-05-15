variable "root_id" {
  type    = string
  default = "mg-itaudev"
}

variable "root_name" {
  type    = string
  default = "Itaudev"
}



# #############################################################################
# Variables - Resource Groups
# #############################################################################
# -
# - Resource Group
# -
variable "resource_groups" {
  description = "Resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
  default = {}
}