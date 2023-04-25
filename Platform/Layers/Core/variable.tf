variable "root_id" {
  type    = string
  default = "mg"
}

variable "root_name" {
  type    = string
  default = "mg-root"
}

##### Subscription #######

variable "subscriptions" {
  type = map(object({
    subscription_name = string
    alias = string
    workload = string
    tags = map(string)
  }))
}

variable "subscription_billing_scope" {
  type        = string
  default     = "/providers/Microsoft.Billing/billingAccounts/xxxxxxxx/enrollmentAccounts/xxxxxxxx"
  description = <<DESCRIPTION
The billing scope for the new subscription alias.

A valid billing scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.

E.g.

- For CustomerLed and FieldLed, e.g. MCA - `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}`
- For PartnerLed, e.g. MPA - `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}`
- For Legacy EA - `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}`

You may also supply an empty string if you do not want to create a new subscription alias.
In this scenario, `subscription_enabled` should be set to `false` and `subscription_id` must be supplied.
DESCRIPTION
  validation {
    condition     = can(regex("^$|^/providers/Microsoft.Billing/billingAccounts/.*$", var.subscription_billing_scope))
    error_message = "A valid billing scope starts with /providers/Microsoft.Billing/billingAccounts/ and is case sensitive."
  }
}

variable "conditional_access" {
  description = "Name of the Conditional access policy"
  type = map(object({
    display_name = string
    state        = string
    # excluded_user_principal_names = list(string)
    # included_user_principal_names = list(string)
    included_applications = list(string)
    excluded_applications = list(string)
    included_locations = list(string)
    excluded_locations = list(string)
    included_platforms = list(string)
    excluded_platforms = list(string)
    included_users = list(string)
    excluded_users = list(string)
    included_roles = list(string)
    excluded_roles = list(string)
    included_groups = list(string)
    excluded_groups = list(string)
    client_app_types = list(string)
    user_risk_levels = list(string)
    sign_in_risk_levels = list(string)
    built_in_controls = list(string)
    operator = string
    sign_in_frequency = number
    sign_in_frequency_period = string
  }))
}
