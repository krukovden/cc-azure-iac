variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"
    identity                 = "id-us-mgd-commoncore"

    tags = {
      Environment = "%s",
      CreatedBy   = "Terraform"
    }
  }
}

variable "appconf_config_template" {
  default = {
    name          = "appconf-cc-cp-%s"
    label         = "%s"
    identity_type = "SystemAssigned"
    apim_name_key = "cc:cp:apim:name:%s"
  }
}

variable erp_getreportsof_func_name_template {
  default = "func-cc-er-executor-getreportsof-adapter-%s"
}

variable erp_getreportsof_apim_api_params {
  default = {
    name        = "abs-cc-erp-getreportsof-api"
    path        = "erpadapters"
    displayName = "ERP Adapters API"
    revision    = "1"
    description = "ERP Adapters API"
    protocols   = ["https"]
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