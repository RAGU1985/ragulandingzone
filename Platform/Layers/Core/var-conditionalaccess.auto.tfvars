 conditional_access = {
  "CA01" = {
      included_applications = ["all"]
      excluded_applications = null
      client_app_types = ["exchangeActiveSync", "other"]
      user_risk_levels = null
      sign_in_risk_levels = null
      included_locations = ["All"]
      excluded_locations = null
      included_platforms = ["all"]
      excluded_platforms = null
      included_users = ["All"]
      excluded_users = [
// list excluded users
        ]
      included_roles = null
      excluded_roles = null
      included_groups = null
      excluded_groups = null
      display_name = "CA01: Block_legacy_authentication"
      built_in_controls = ["block"]
      operator          = "OR"
      sign_in_frequency        = 0
      sign_in_frequency_period = "hours"
      state = "enabled"
  },
  "CA02" = {
      included_applications = ["all"]
      excluded_applications = null
      client_app_types = ["all"]
      user_risk_levels = null
      sign_in_risk_levels = null
      included_locations = ["All"]
      excluded_locations = null
      included_platforms = ["all"]
      excluded_platforms = null
      included_users = ["All"]
      excluded_users = [
// list excluded users
      ]
      included_roles = null
      excluded_roles = null
      included_groups = null
      excluded_groups = null
      display_name = "CA02: Require multifactor authentication for all users"
      built_in_controls = ["mfa"]
      operator          = "OR"
      sign_in_frequency        = 0
      sign_in_frequency_period = "hours"
      state = "enabled"
  },
  "CA03" = {
      included_applications = ["all"]
      excluded_applications = null
      client_app_types = ["all"]
      user_risk_levels = null
      sign_in_risk_levels = null
      included_locations = ["All"]
      excluded_locations = null
      included_platforms = ["all"]
      excluded_platforms = null
      # included_user_principal_names = null
      included_users = null
      # excluded_user_principal_names = ["D8cl2fwRmn@nordeapensiondk.onmicrosoft.com","6wSTrqd3Um@nordeapensiondk.onmicrosoft.com"]
      excluded_users = [
// list excluded users
        ]
      included_roles = [
        "62e90394-69f5-4237-9190-012177145e10", //Global Administrator
        "e8611ab8-c189-46e8-94e1-60213ab1f814", //Privileged Role Administrator`
        "7be44c8a-adaf-4e2a-84d6-ab2649e08a13", //Privileged Authentication Administrator
        "194ae4cb-b126-40b2-bd5b-6091b380977d", //Security Administrator
        "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3", //Application Administrator
        "c4e39bd9-1100-46d3-8c65-fb160da0071f", //Authentication Administrator
        "b0f54661-2d74-4c50-afa3-1ec803f12efe", //Billing Administrator
        "158c047a-c907-4556-b7ef-446551a6b5f7", //Cloud Application Administrator
        "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9", //Conditional Access Administrator
        "29232cdf-9323-42fd-ade2-1d097af3e4de", //Exchange Administrator
        "729827e3-9c14-49f7-bb1b-9608f156bbb8", //Helpdesk Administrator
        "966707d0-3269-4727-9be2-8c3a10f19b9d", //Password Administrator
        "f28a1f50-f6e7-4571-818b-6a12f2af6b6c", //SharePoint Administrator
        "fe930be7-5e62-47db-91af-98c3a49a38b1"  //User Administrator
      ]
      excluded_roles = null
      included_groups = null
      excluded_groups = null
      display_name = "CA03: Session Control Policy"
      built_in_controls = ["mfa"]
      operator          = "OR"
      sign_in_frequency        = 8
      sign_in_frequency_period = "hours"
      state = "enabled"
  },
  "CA04" = {
      included_applications = ["all"]
      excluded_applications = null
      client_app_types = ["all"]
      user_risk_levels = ["high"]
      sign_in_risk_levels = null
      included_locations = ["All"]
      excluded_locations = null
      included_platforms = ["all"]
      excluded_platforms = null
      included_users = ["All"]
      excluded_users = [
// list excluded users
      ]
      included_roles = null
      excluded_roles = null
      included_groups = null
      excluded_groups = null
      display_name = "CA04: Require password change for high-risk users"
      built_in_controls = ["mfa"]
      operator          = "OR"
      sign_in_frequency        = 0
      sign_in_frequency_period = "hours"
      state = "enabledForReportingButNotEnforced"
  },
  "CA05" = {
      included_applications = ["all"]
      excluded_applications = null
      client_app_types = ["all"]
      user_risk_levels = null
      sign_in_risk_levels = ["medium","high"]
      included_locations = ["All"]
      excluded_locations = null
      included_platforms = ["all"]
      excluded_platforms = null
      included_users = ["All"]
      excluded_users = [
// list excluded users
      ]
      included_roles = null
      excluded_roles = null
      included_groups = null
      excluded_groups = null
      display_name = "CA05: Require multifactor authentication for risky sign-ins"
      built_in_controls = ["mfa"]
      operator          = "OR"
      sign_in_frequency        = 0
      sign_in_frequency_period = "hours"
      state = "enabledForReportingButNotEnforced"
  }
 }