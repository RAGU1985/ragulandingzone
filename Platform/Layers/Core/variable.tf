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


variable "tag_date" {
  description = "Date for the tag"
  default     = "00-00-0000"  # Placeholder value

  validation {
    condition     = can(regex("^\\d{2}-\\d{2}-\\d{4}$", var.tag_date))
    error_message = "Invalid date format. Please use the 'DD-MM-YYYY' format."
  }
}