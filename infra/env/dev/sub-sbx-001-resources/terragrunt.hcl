include {
  path = find_in_parent_folders()
}

locals {
  # Load environment-level variables from files in parents folders
  env_vars      = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract common variables for reuse
  location = local.env_vars.locals.location
  env      = local.env_vars.locals.env_name
  topmg    = local.env_vars.locals.topmg
  rgtype   = local.env_vars.locals.rgtype
  provider_version = "3.52.0"
  resource_group_name = "rg-${local.rgtype}-${local.topmg}-sbx-${local.location}-002"
  vnet_names = ["vnet-spoke-1", "vnet-spoke-2"]
  address_space = ["10.0.0.0/16", "10.2.0.0/16"]
  subnet_prefixes = ["10.0.1.0/26", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  subnet_names = ["AzureBastionSubnet", "Management", "Tools", "Workloads"]
  nsg_names    = ["nsg-allowbastion-001"]
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "azurerm" {
  version = "=${local.provider_version}"
  features {}
  skip_provider_registration = true
}
EOF
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules//azurerm_resource_group"
}

inputs = {
    name            = local.resource_group_name
    location        = local.location
    environment     = local.env
    vnet_names      = local.vnet_names
    address_space   = local.address_space
    subnet_prefixes = local.subnet_prefixes
    subnet_names    = local.subnet_names
    nsg_names       = local.nsg_names
}