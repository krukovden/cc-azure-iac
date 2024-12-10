variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"
    identity                 = "id-us-mgd-commoncore"

    tags = {
      Project     = "TenantAdapters",
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

variable "env_vars_names" {
  default = {
    rabbit_url               = "TF_RMQ_URL"
    rabbit_connection_string = "TF_RMQ_CONNECTION_STRING"
    rabbit_pass              = "TF_RMQ_PASS"
    rabbit_user              = "TF_RMQ_USER"
    rabbit_vhost             = "TF_RMQ_VHOST"
    rabbit_port              = "TF_RMQ_PORT"
    db_pass                  = "TF_DATABASE_PASSWORD"
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

variable "tenant_api_func_config_template" {
  default = {
    name                          = "func-cc-cp-tenant-api-%s"
    public_network_access_enabled = true
    cors_allowed_origins          = ["https://portal.azure.com"]
    cors_support_credentials      = false
    app_settings                  = {}
  }
}

variable "tenant_api_func_app_settings_template" {
  default = {
    "DiagnosticServices_EXTENSION_VERSION"       = "~3"
    "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED"     = "1"
    "KEY_VAULT_NAME"                             = "kv-cc-cp-%s"
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"       = "DbConnectionString"
    "ABS_VESON_REGISTER_PARTNER_URL"             = "https://func-cc-cp-veson-tenant-adapter-%s.azurewebsites.net/api/RegisterVesonTenant"
    "ABS_ECDIS_REGISTER_PARTNER_URL"             = "https://func-cc-cp-ecdis-tenant-adapter-%s.azurewebsites.net/api/RegisterEcdisTenant"
    "RMQ_HOST_KV_NAME"                           = "RmqHostName"
    "RMQ_USER_KV_NAME"                           = "RmqUserName"
    "RMQ_PASSWORD_KV_NAME"                       = "RmqPassword"
    "RMQ_VIRTUAL_HOST_KV_NAME"                   = "RmqVhost"
    "VESON_PULLER_EXCHANGE_NAME"                 = "et.cccp.veson.voyageplan.puller"
  }
}

variable "apis_service_plan_name_template" {
  default = "sp-cc-cp-api-functions-%s"
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