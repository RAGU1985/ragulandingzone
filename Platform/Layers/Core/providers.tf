terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 3.42.0"
    }
  }
  backend "azurerm" {}
}

# Declare a standard provider block using your preferred configuration.
# This will be used for the deployment of all "Core resources".

provider "azurerm" {
  features {}
}