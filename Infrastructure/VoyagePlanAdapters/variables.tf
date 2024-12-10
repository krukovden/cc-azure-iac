variable "global_settings_template" {
  default = {
    location                      = ""
    resource_group_name           = "rg-%s-commoncore-001"
    retention_resource_group_name = "rg-%s-cccp-retention"
    data_resource_group_name      = "rg-%s-commoncore-001-data"
    dotnet_version                = "8.0"
    identity                      = "id-us-mgd-commoncore"

    tags = {
      Project     = "VoyagePlanAdapters",
      Environment = "%s",
      CreatedBy   = "Terraform"
    }
  }
}

variable "appconf_config_template" {
  default = {
    name               = "appconf-cc-cp-%s"
    label              = "%s"
    identity_type      = "SystemAssigned"
    apim_name_key      = "cc:cp:apim:name:%s"
    apim_subnet_id_key = "cc:cp:apim:subnet:id:%s"
    keyvault_id        = "cc:cp:kv:id:%s"
    keyvault_name      = "cc:cp:kv:name:%s"
  }
}

variable "vnet_name_template" {
  default = "vnet-cc-cp-shared-%s"
}

variable "shared_service_plan_name_template" {
  default = "sp-cc-cp-functions-%s"
}

variable "shared_func_storage_account_name_template" {
  default = "stcccpfunc%s"
}

variable "funcitons_kv_permissions" {
  default = {
    secret_permissions      = ["Get", "List"]
    key_permissions         = ["Decrypt", "Encrypt", "Get", "List"]
    certificate_permissions = ["Get", "GetIssuers", "List", "ListIssuers"]
  }
}

variable "voyage_plan_api_func_config_template" {
  default = {
    name                          = "func-cc-cp-voyage-plan-api-adapter-%s"
    public_network_access_enabled = true
  }
}

variable "voyage_plan_normalized_writer_func_config_template" {
  default = {
    name                          = "func-cc-cp-voyage-plan-persist-adapter-%s"
    public_network_access_enabled = true
  }
}

variable "env_vars_names" {
  default = {
    rabbit_connection_string = "TF_RMQ_CONNECTION_STRING"
  }
}

variable "shared_key_vault_params_template" {
  default = {
    name = "kv-cc-cp-%s"
    secrets = {
      db_connection_string_name = "DbConnectionString",
      strg_acc_name             = "VoyagePlanRetentionStorageAccountName"
      strg_acc_key              = "VoyagePlanRetentionStorageAccountKey"
      strg_acc_uri              = "VoyagePlanRetentionStorageAccountUri"
    }
  }
}

variable "voyage_plan_retention_func_config_template" {
  default = {
    name                          = "func-cc-cp-voyage-plan-retention-adapter-%s"
    public_network_access_enabled = true
    cors_allowed_origins          = ["https://portal.azure.com"]
    cors_support_credentials      = false

    app_settings = {
      "SCHEDULE_TRIGGER_TIME" = "0 0 0 2 Jan *"
    }
  }
}

variable "retention_storage_account_config_template" {
  default = {
    name                     = "stcccpvpretention%s"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    access_tier              = "Cool"
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

variable "apis_service_plan_name_template" {
  default = "sp-cc-cp-api-functions-%s"
}