locals {
  # Automatically load environment-leve (dev/prod) variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  backend_resource_group_name = get_env("RESOURCE_GROUP_NAME")
  backend_storage_account_name = get_env("STORAGE_ACCOUNT_NAME")
  backend_container_name = get_env("CONTAINER_NAME")
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "${local.backend_resource_group_name}"
    storage_account_name = "${local.backend_storage_account_name}"
    container_name       = "${local.backend_container_name}"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}
EOF
}

terraform {
  # Force Terraform to keep trying to acquire a lock for
  # up to 20 minutes if someone else already has the lock
  extra_arguments "retry_lock" {
    commands = get_terraform_commands_that_need_locking()

    arguments = [
      "-lock-timeout=20m"
    ]
  }
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.env_vars.locals
)