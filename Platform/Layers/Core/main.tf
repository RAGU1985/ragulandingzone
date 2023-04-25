# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "core" {}

##### Module for Subscriptions #########

module "subscription" {
  source = "../../../modules/subscription"
  subscriptions = var.subscriptions
}

# Declare the Azure landing zones Terraform module
# and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "3.0.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "./lib"

  ###### Deploys MG structure with naming convention provided by customer and disables deployment of default core structure ######

  deploy_core_landing_zones = false

  custom_landing_zones = {
      "${var.root_id}" = {
        display_name               = "${lower(var.root_name)}"
        parent_management_group_id = "${data.azurerm_client_config.core.tenant_id}"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "es_root"
          parameters     = {}
          access_control = {}
        }
       } 
      "${var.root_id}-decommissioned" = {
        display_name               = "${lower(var.root_id)}-decommissioned"
        parent_management_group_id = "${var.root_id}"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "es_decommissioned"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-platform" = {
        display_name               = "${lower(var.root_id)}-platform"
        parent_management_group_id = "${var.root_id}"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "es_platform"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-connectivity" = {
        display_name               = "${lower(var.root_id)}-connectivity"
        parent_management_group_id = "${var.root_id}-platform"
        subscription_ids           = ["${module.subscription.subscription_id["sub-con-ext-01"]}","${module.subscription.subscription_id["sub-con-int-01"]}"]
        archetype_config = {
          archetype_id   = "es_connectivity"
          parameters     = {}
          access_control = {}
        }
        # depends_on= [azurerm_subscription.connectivity1,azurerm_subscription.connectivity2]
      }
      "${var.root_id}-management" = {
        display_name               = "${lower(var.root_id)}-management"
        parent_management_group_id = "${var.root_id}-platform"
        subscription_ids           = ["${module.subscription.subscription_id["sub-man-02"]}"]
        archetype_config = {
          archetype_id   = "es_management"
          parameters     = {}
          access_control = {}
        }
        # depends_on= [azurerm_subscription.management1]
      }
      "${var.root_id}-identity" = {
        display_name               = "${lower(var.root_id)}-identity"
        parent_management_group_id = "${var.root_id}-platform"
        subscription_ids           = ["${module.subscription.subscription_id["sub-idn-02"]}"]
        archetype_config = {
          archetype_id   = "es_identity"
          parameters     = {}
          access_control = {}
        }
        # depends_on= [azurerm_subscription.identity1]
      }
      ##### landing zone #####
      "${var.root_id}-landing-zones" = {
        display_name               = "${lower(var.root_id)}-landing-zones"
        parent_management_group_id = "${var.root_id}"
        subscription_ids           = []
        archetype_config = {
          archetype_id   = "es_landing_zones"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-prod" = {
        display_name               = "${lower(var.root_id)}-prod"
        parent_management_group_id = "${var.root_id}-landing-zones"
        subscription_ids           = ["${module.subscription.subscription_id["sub-lzprd-sample-02"]}"]
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-nonprod" = {
        display_name               = "${lower(var.root_id)}-nonprod"
        parent_management_group_id = "${var.root_id}-landing-zones"
        subscription_ids           = ["${module.subscription.subscription_id["n-sub-lznprd-sample-02"]}"]
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      "${var.root_id}-dev" = {
        display_name               = "${lower(var.root_id)}-dev"
        parent_management_group_id = "${var.root_id}-landing-zones"
        subscription_ids           = ["${module.subscription.subscription_id["d-sub-lzdev-sample-02"]}"]
        archetype_config = {
          archetype_id   = "default_empty"
          parameters     = {}
          access_control = {}
        }
      }
      ##### SandBox #####
      "${var.root_id}-sandboxes" = {
        display_name               = "${lower(var.root_id)}-sandboxes"
        parent_management_group_id = "${var.root_id}"
        subscription_ids           = ["${module.subscription.subscription_id["n-sub-sandbox-04"]}"]
        archetype_config = {
          # archetype_id   = "default_empty"
          archetype_id   = "es_sandboxes"
          parameters     = {}
          access_control = {}
        }
      }
    }
  depends_on = [
    module.subscription
  ]
}


module "conditionalaccess" {
  source = "../../../modules/conditionalaccess"
  conditional_access = var.conditional_access
}