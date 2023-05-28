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

  resource_group_name = "rg-${local.rgtype}-${local.topmg}-sbx-${local.location}-001"
}

generate "provider" {
  path      = "flakes.txt"
  if_exists = "overwrite"
  contents = <<EOF
provider "azurerm" {
  subscription = "d7caf0f4-7c69-4c4a-af92-3b52493f74ca"
}
EOF
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules//azurerm_resource_group"
}

inputs = {
    name        = local.resource_group_name
    location    = local.location
    environment = local.env
}