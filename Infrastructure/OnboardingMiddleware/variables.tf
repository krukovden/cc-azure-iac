variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"
    identity                 = "id-us-mgd-commoncore"

    tags = {
      Project     = "OnboardingMiddleware",
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
    keyvault_id   = "cc:cp:kv:id:%s"
  }
}

variable "keyvault_values" {
  default = {
    ui_client_id_name = "UIClientId"
  }
}

variable "funcitons_kv_permissions" {
  default = {
    secret_permissions      = ["Get", "List"]
    key_permissions         = ["Decrypt", "Encrypt", "Get", "List"]
    certificate_permissions = ["Get", "GetIssuers", "List", "ListIssuers"]
  }
}

variable "vnet_name_template" {
  default = "vnet-cc-cp-shared-%s"
}

variable "onboarding_middleware_api_func_config_template" {
  default = {
    name                          = "func-cc-cp-onboarding-middleware-api-%s"
    public_network_access_enabled = true
    cors_allowed_origins          = ["https://portal.azure.com"]
    cors_support_credentials      = false
    app_settings                  = {}
  }
}

variable "onboardingmiddleware_api_func_app_settings_template" {
  default = {
    "DiagnosticServices_EXTENSION_VERSION"   = "~3"
    "WEBSITE_RUN_FROM_PACKAGE"               = "1"
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = "kv-cc-cp-%s"
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = "DbConnectionString"
    "UI_CLIENT_ID_KV_NAME"                   = "UIClientId"
    "TENANT_DATA_SOURCE_QUEUE_NAME"          = "q.cccp.tenant-data.%s"
    "RABBIT_MQ_CONNECTION_STRING"            = "%"
    "AzureSignalRConnectionString"           = "%"
  }
}

variable "shared_service_plan_name_template" {
  default = "sp-cc-cp-functions-%s"
}

variable "shared_func_storage_account_name_template" {
  default = "stcccpfunc%s"
}

variable "shared_key_vault_params_template" {
  default = {
    name    = "kv-cc-cp-%s"
    secrets = {
      db_connection_string_name = "DbConnectionString"
    }
  }
}

variable "onboarding_middleware_vessel_processing_key_vault_params_template" {
  default = {
    permanent_blob_account_name = "OnboardingPermanentBlobAccountName"
    permanent_blob_account_key  = "OnboardingPermanentBlobAccountKey"
    permanent_blob_account_url  = "OnboardingPermanentBlobAccountUrl"
  }
}

variable "shared_rabbitmq_env_vars" {
  default = {
    rabbit_url               = "TF_RMQ_URL"
    rabbit_connection_string = "TF_RMQ_CONNECTION_STRING"
    rabbit_pass              = "TF_RMQ_PASS"
    rabbit_user              = "TF_RMQ_USER"
    rabbit_vhost             = "TF_RMQ_VHOST"
    rabbit_port              = "TF_RMQ_PORT"
  }
}

variable "postgresql_private_endpoint_name_template" {
  default = "pe-cc-cp-postgresql-%s"
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

variable "MDF_VESSEL_BASE_URL" {
  description = "MDF Vessel API base url"
  type = string
}

variable "MDF_TENANT_BASE_URL" {
  description = "MDF Tenant API base url"
  type = string
}

variable "onboarding_middleware_signalR_service_config_template" {
  default = {
    name                          = "signalr-cc-cp-onboarding-middleware-%s"
    public_network_access_enabled = true
    cors_allowed_origins          = ["*"]
    app_settings                  = {}
    sku_name                      = "Premium_P1"
    connection_string_secret_name = "OnboardingMiddlewareSignalRConnectionString"
  }
}

variable "onboarding_middleware_vessel_processing_storage_account_config_template" {
  default = {
    name                     = "stcconbmiddleware%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "onboarding_middleware_vessel_processing_func_config_template" {
  default = {
    name                          = "func-cc-cp-onboarding-vessel-processing-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "tenant_adapter_func_name_template" {
  default = "func-cc-cp-tenant-api-%s"
}

variable "keyvault_config" {
  default = {
    strg_acc_name               = "OnboardingPermanentBlobAccountName"
    strg_acc_key                = "OnboardingPermanentBlobAccountKey"
    strg_acc_uri                = "OnboardingPermanentBlobAccountUrl"
  }
}

variable "onboarding_middleware_vessel_catalog_storage_account_blob_config_template" {
  default = {
    name                     = "stccvesselcat%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    blob_added_queue_name    = "q-cccp-vessel-catalog-blob"
    blob_added_event_name    = "move-to-q-cccp-vessel-catalog-blob"
    container_name           = "vessel-catalogs"
    container_access_type    = "container"
  }
}

variable "onboarding_middleware_vessel_catalog_processing_func_config_template" {
  default = {
    name                          = "func-cc-cp-onboarding-vessel-catalog-processing-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}