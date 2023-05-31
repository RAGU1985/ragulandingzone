include {
  path = find_in_parent_folders()
}

locals {
  # Load environment-level variables from files in parents folders
  env_vars      = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  virtual_networks = {
    virtualnetwork1 = {
      name                 = "vnet-sandbox-brazilsouth-001"
      address_space        = ["10.0.0.0/16"]
      dns_servers          = null
      ddos_protection_plan = null
    }
    virtualnetwork2 = {
      name                 = "vnet-sandbox-brazilsouth-002"
      address_space        = ["10.1.0.0/16"]
      dns_servers          = null
      ddos_protection_plan = null
    }
  }
  subnets = {
    subnet1 = {
      vnet_key          = "virtualnetwork1"
      vnet_name         = null #jstartvmssfirst
      name              = "snet-firewall-brazilsouth-001"
      address_prefixes  = ["10.0.0.0/26"]
      service_endpoints = []
      pe_enable         = false
      delegation        = []
    },
    subnet2 = {
      vnet_key          = "virtualnetwork1"
      vnet_name         = null #jstartvmssfirst
      name              = "snet-bastion-brazilsouth-001"
      address_prefixes  = ["10.0.0.64/26"]
      service_endpoints = []
      pe_enable         = false
      delegation        = []
    },
    subnet3 = {
      vnet_key          = "virtualnetwork1"
      vnet_name         = null #jstartvmssfirst
      name              = "snet-mgmt-brazilsouth-001"
      address_prefixes  = ["10.0.0.128/26"]
      service_endpoints = []
      pe_enable         = false
      delegation        = []
    },
    subnet4 = {
      vnet_key          = "virtualnetwork2"
      vnet_name         = null #jstartvmssfirst
      name              = "snet-aks-brazilsouth-001"
      address_prefixes  = ["10.1.0.0/24"]
      service_endpoints = []
      pe_enable         = false
      delegation        = []
    },
  }

  vnet_peering = {
    akstobastion = {
      destination_vnet_name                 = local.virtual_networks.virtualnetwork1.name
      destination_vnet_rg                   = local.net_rg_name #"[__resource_group_name__]"
      remote_destination_virtual_network_id = "/subscriptions/d7caf0f4-7c69-4c4a-af92-3b52493f74ca/resourceGroups/rg-net-itaudev-sbx-brazilsouth-001/providers/Microsoft.Network/virtualNetworks/vnet-sandbox-brazilsouth-001"
      source_vnet_name                      = local.virtual_networks.virtualnetwork2.name
      source_vnet_rg                        = local.net_rg_name
      allow_forwarded_traffic               = true
      allow_virtual_network_access          = true
      allow_gateway_transit                 = false
      use_remote_gateways                   = false
    }
    bastiontoaks = {
      destination_vnet_name                 = local.virtual_networks.virtualnetwork2.name
      destination_vnet_rg                   = local.net_rg_name #"[__resource_group_name__]"
      remote_destination_virtual_network_id = "/subscriptions/d7caf0f4-7c69-4c4a-af92-3b52493f74ca/resourceGroups/rg-net-itaudev-sbx-brazilsouth-001/providers/Microsoft.Network/virtualNetworks/vnet-sandbox-brazilsouth-002"
      source_vnet_name                      = local.virtual_networks.virtualnetwork1.name
      source_vnet_rg                        = local.net_rg_name
      allow_forwarded_traffic               = true
      allow_virtual_network_access          = true
      allow_gateway_transit                 = false
      use_remote_gateways                   = false
    }
  }
  # Extract common variables for reuse
  location = local.env_vars.locals.location
  env      = local.env_vars.locals.env_name
  mghead   = local.env_vars.locals.mghead
  provider_version = "3.52.0"
  net_rg_name = "rg-net-${local.mghead}-sbx-${local.location}-002"
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
    net_rg_name         = local.net_rg_name
    net_location        = local.location
    environment         = local.env
    virtual_networks    = local.virtual_networks
    subnets             = local.subnets
    net_additional_tags = null
    vnet_peering        = local.vnet_peering
}