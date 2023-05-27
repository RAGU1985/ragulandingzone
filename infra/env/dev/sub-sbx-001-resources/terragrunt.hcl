include {
  path = find_in_parent_folders()
}

dependency "subscription" {
  config_path = "../sub-sbx-001"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    subscription_id = "fake-subscription-id"
  }
}

# When using this terragrunt config, terragrunt will generate the file "provider.tf" with the aws provider block before
# calling to terraform. Note that this will overwrite the `provider.tf` file if it already exists.
generate "provider" {
  path      = "flakes.txt"
  if_exists = "overwrite"
  contents = <<EOF
provider "azurerm" {
  subscription = "${dependency.subscription.outputs.subscription_id}"
}
EOF
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules//sandbox-subscription"
}

inputs = {
    subscription_id = dependency.subscription.outputs.subscription_id
}