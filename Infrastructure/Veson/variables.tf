variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"
    identity                 = "id-us-mgd-commoncore"

    tags = {
      Project     = "Veson",
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
    apim_name_key      = "cc:cp:apim:name:%s"
  }
}

variable "veson_storage_account_config_template" {
  default = {
    name                     = "stccvesonfunc%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "keyvault_config" {
  default = {
    blob_conneciton_string_name = "VesonBlobConnectionString"
    blob_account_key            = "VesonBlobAccountKey"
    rmq_host_name               = "RmqHostName"
    rmq_user_name               = "RmqUserName"
    rmq_password_name           = "RmqPassword"
    rmq_vhost_name              = "RmqVhost"
    rmq_port_name               = "RmqPort"
    db_connection_string_name   = "DbConnectionString"
    strg_acc_name               = "VesonStorageAccountName"
    strg_acc_key                = "VesonStorageAccountKey"
    strg_acc_uri                = "VesonStorageAccountUri"
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

variable "veson_function_service_plan_config_template" {
  default = {
    name                   = "sp-cc-veson-functions-%s"
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
    name                   = "nsr-allow-access-veson-func-to-sql"
    priority               = 110
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "*"
  }
}

variable "veson_register_tenant_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-tenant-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    veson_company_api_url         = "https://api.veslink.com/v1/companies/partners"
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "veson_puller_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-puller-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    veson_root_api_url            = "https://emea.veslink.com/api/messages"
    veson_token                   = "741cc32d80a2f74677594350e807140a96ee68014170d284657d119cdf317a51"
    veson_intent_parameter        = "PublishVoyageUpdate"
    veson_intent_from             = "PRTR"
    veson_intent_to               = "ABSS"
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
    post_count                    = 0
  }
}

variable "veson_normalize_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-canonicalize-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "veson_raw_writer_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-raw-writer-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "veson_schedule_trigger_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-schedule-trigger-adapter-%s"
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "veson_storage_account_blob_config_template" {
  default = {
    name                     = "stccvesonblob%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "veson_raw_storage_container_config_template" {
  default = {
    name = "sc-cc-veson-raw-data-blob-%s"
    type = "Block"
  }
}

variable "veson_blob_storage_config_template" {
  default = {
    name                  = "bls-cc-veson-raw-data-%s"
    container_access_type = "private"
  }
}

variable "veson_raw_republisher_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-raw-republisher-adapter-%s"
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "veson_port_schedule_trigger_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-port-schedule-trigger-%s"
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "veson_port_puller_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-port-puller-adapter-%s"
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "veson_port_writer_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-port-writer-adapter-%s"
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "veson_port_info_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-ports-api-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "veson_auditor_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-auditor-%s"
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

variable "vnet_name_template" {
  default = "vnet-cc-cp-shared-%s"
}