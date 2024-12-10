variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"
    identity                 = "id-us-mgd-commoncore"

    tags = {
      Project     = "ERP",
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
    postgres_ip_key    = "cc:cp:postgresql:ip:%s"
    nsg_name           = "cc:cp:nsg:name:%s"
    vnet_name          = "cc:cp:vnet:name:%s"
    apim_subnet_id_key = "cc:cp:apim:subnet:id:%s"
    keyvault_id        = "cc:cp:kv:id:%s"
    keyvault_name      = "cc:cp:kv:name:%s"
  }
}

variable "erp_storage_account_config_template" {
  default = {
    name                     = "stccerpfunc%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "keyvault_config" {
  default = {
    db_connection_string_name = "DbConnectionString"
  }
}

variable "shared_rabbitmq_env_vars" {
  default = {
    rabbit_url               = "TF_RMQ_URL"
    rabbit_connection_string = "TF_RMQ_CONNECTION_STRING"
    rabbit_pass              = "TF_RMQ_PASS"
    rabbit_user              = "TF_RMQ_USER"
    rabbit_vhost             = "TF_RMQ_VHOST"
  }
}

variable "erp_function_service_plan_config_template" {
  default = {
    name                   = "sp-cc-erp-functions-%s"
    os_type                = "Linux"
    sku_name               = ""
    worker_count           = 1
    zone_balancing_enabled = false
  }
}

variable "funcitons_kv_permissions" {
  default = {
    secret_permissions      = ["Get", "List"]
    key_permissions         = ["Decrypt", "Encrypt", "Get", "List"]
    certificate_permissions = ["Get", "GetIssuers", "List", "ListIssuers"]
  }
}

variable "nsr_allow_access_func_to_sql_config" {
  default = {
    name                   = "nsr-allow-access-erp-func-to-sql"
    priority               = 150
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "*"
  }
}

variable "erp_executor_func_config_template" {
  default = {
    name                          = "func-cc-er-executor-import-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_import_report_config_template" {
  default = {
    name                          = "func-cc-erp-import-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_auditor_func_config_template" {
  default = {
    name                          = "func-cc-er-auditor-import-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_persist_response_func_config_template" {
  default = {
    name                          = "func-cc-er-persist-import-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "get_validation_result_config_template" {
  default = {
    name                          = "func-cc-erp-validation-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "get_validation_result_scheduler_config_template" {
  default = {
    name                          = "func-cc-er-validation-report-scheduler-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_get_validation_auditor_func_config_template" {
  default = {
    name                          = "func-cc-er-auditor-validation-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "get_validation_result_persist_config_template" {
  default = {
    name                          = "func-cc-er-persist-validation-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "function_service_plan_sku_name" {
  default = {
    dev = "P1mv3"
    qa  = "P1mv3"
    stg = "P1mv3"
    prd = "P1mv3"
  }
}

variable "erp_update_report_executor_func_config_template" {
  default = {
    name                          = "func-cc-er-executor-update-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_update_report_config_template" {
  default = {
    name                          = "func-cc-erp-update-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_update_report_auditor_func_config_template" {
  default = {
    name                          = "func-cc-er-auditor-update-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_update_report_persist_response_func_config_template" {
  default = {
    name                          = "func-cc-er-persist-update-report-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_get_voyages_executor_func_config_template" {
  default = {
    name                          = "func-cc-er-executor-getvoyages-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_get_voyages_config_template" {
  default = {
    name                          = "func-cc-erp-getvoyages-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_get_voyages_auditor_func_config_template" {
  default = {
    name                          = "func-cc-er-auditor-getvoyages-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_get_report_sof_executor_func_config_template" {
  default = {
    name                          = "func-cc-er-executor-getreportsof-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_get_report_sof_config_template" {
  default = {
    name                          = "func-cc-erp-getreportsof-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "erp_get_report_sof_auditor_func_config_template" {
  default = {
    name                          = "func-cc-er-auditor-getreportsof-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
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