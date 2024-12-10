variable "global_settings" {
  default = {
    location            = "Central US"
    resource_group_name = "rg-%s-onboarding"

    tags = {
      Project     = "CommonCore",
      Name        = "OnboardingTool",
      Environment = "%s",
      CreatedBy   = "Terraform"
    }
  }
}

variable "appconf_config" {
  default = {
    app_name = "OnboardingTool"
    sku_tier = "Standard"
    sku_size = "Standard"
    location = "Central US"
  }
}

variable "web_app_config" {
  default = {
    domain_name     = "cc-ot-%s-%s.absns.cloud"
    validation_type = "cname-delegation"
  }
}

variable ENV {
  description = "DEV, QA, STG or PRD"
  type        = string
}

variable REGION_SUFFIX {
  description = "eus (East US), wus (West US), eu (Europe) or ..."
  type = string
}

variable REGION_CODE {
  description = "europe, southcentralus, eastus or ..."
  type = string
}