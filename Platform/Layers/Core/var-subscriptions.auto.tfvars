subscriptions = {
  "sandbox1" = {
    subscription_name = "n-sub-sandbox-04"
    alias = "n-sub-sandbox-04"
    workload = "Production"
    tags = {
      CostApprover = ""
      BusinessUnit = "BU Name" #mandatory
      BusinessOwner = "abc@example.com" #mandatory
      TechnicalOwner = "abc@example.com" #mandatory
      DataClassification = "Open" #mandatory
      EnvironmentType = "Sandbox" #mandatory
      BusinessCriticality = "Low" #mandatory
      WorkloadName = "N/A" #mandatory
      OperationsTeam = "" #mandatory
    }
  },
  "identity1" = {
    subscription_name = "sub-idn-02"
    alias = "sub-idn-02"
    workload = "Production"
    tags = {
      CostApprover = ""
      BusinessUnit = "BU Name" #mandatory
      BusinessOwner = "abc@example.com" #mandatory
      TechnicalOwner = "abc@example.com" #mandatory
      DataClassification = "Confidential" #mandatory
      EnvironmentType = "Production" #mandatory
      BusinessCriticality = "Business unit-critical" #mandatory
      WorkloadName = "Platform" #mandatory
      OperationsTeam = "" #mandatory
    }
  },

}