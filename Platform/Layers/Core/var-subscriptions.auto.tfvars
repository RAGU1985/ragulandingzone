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
  "management1" = {
    subscription_name = "sub-man-02"
    alias = "sub-man-02"
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
  "connectivityext1" = {
    subscription_name = "sub-con-ext-01"
    alias = "sub-con-ext-01"
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
  "connectivityint1" = {
    subscription_name = "sub-con-int-01"
    alias = "sub-con-int-01"
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
  "lzdevsample" = {
    subscription_name = "d-sub-lzdev-sample-02"
    alias = "d-sub-lzdev-sample-02"
    workload = "Production"
    tags = {
      CostApprover = ""
      BusinessUnit = "BU Name" #mandatory
      BusinessOwner = "abc@example.com" #mandatory
      TechnicalOwner = "abc@example.com" #mandatory
      DataClassification = "Internal" #mandatory
      EnvironmentType = "Development" #mandatory
      BusinessCriticality = "Medium" #mandatory
      WorkloadName = "N/A" #mandatory
      OperationsTeam = "" #mandatory
    }
  },
  "lznprdsample" = {
    subscription_name = "n-sub-lznprd-sample-02"
    alias = "n-sub-lznprd-sample-02"
    workload = "Production"
    tags = {
      CostApprover = ""
      BusinessUnit = "BU Name" #mandatory
      BusinessOwner = "abc@example.com" #mandatory
      TechnicalOwner = "abc@example.com" #mandatory
      DataClassification = "Internal" #mandatory
      EnvironmentType = "Development" #mandatory
      BusinessCriticality = "Medium" #mandatory
      WorkloadName = "N/A" #mandatory
      OperationsTeam = "" #mandatory
    }
  },
  "lzprdsample" = {
    subscription_name = "sub-lzprd-sample-02"
    alias = "sub-lzprd-sample-02"
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