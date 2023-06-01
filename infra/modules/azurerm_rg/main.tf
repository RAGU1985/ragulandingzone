
locals {
  location = var.net_location
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.net_rg_name
  location = var.net_location
  tags = {
    env          = "prod"
    automated_by = "ms"
  }
}

