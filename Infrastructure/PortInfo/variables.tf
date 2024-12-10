variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"
    identity                 = "id-us-mgd-commoncore"

    tags = {
      Project     = "Port Info",
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

variable "port_info_storage_account_config_template" {
  default = {
    name                     = "stccportinfofunc%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "keyvault_config" {
  default = {
    db_connection_string_name   = "DbConnectionString"
    rmq_host_name               = "RmqHostName"
    rmq_user_name               = "RmqUserName"
    rmq_password_name           = "RmqPassword"
    rmq_vhost_name              = "RmqVhost"
    rmq_port_name               = "RmqPort"
    strg_acc_name               = "PortInfoStorageAccountName"
    strg_acc_key                = "PortInfoStorageAccountKey"
    strg_acc_uri                = "PortInfoStorageAccountUri"
  }
}

variable "subnet_config" {
  default = {}
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

variable "port_info_function_service_plan_config_template" {
  default = {
    name                   = "sp-cc-port-info-functions-%s"
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
  default = {}
}

variable "port_info_unece_func_config_template" {
  default = {
    name                          = "func-cc-cp-un-locode-api-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "unports_dlq_config" {
  default = {
    name        = "dlq.cccp.unports"
    durable     = true
    auto_delete = false
  }
}

variable "unports_parse_binding_config" {
  default = {
    destination_type = "queue"
    routing_key      = "#"
  }
}

variable "unports_parse_delay_exchange_config" {
  default = {
    name        = "et.cccp.unports.parse.delay"
    type        = "x-delayed-message"
    durable     = true
    auto_delete = false
  }
}

variable "unports_parse_exchange_config" {
  default = {
    name        = "et.cccp.unports.parse"
    type        = "topic"
    durable     = true
    auto_delete = false
  }
}

variable "unports_parse_queue_config" {
  default = {
    name        = "q.cccp.unports.parse"
    durable     = true
    auto_delete = false
  }
}

variable "unports_status_exchange_config" {
  default = {
    name        = "et.ports.parse"
    type        = "topic"
    durable     = true
    auto_delete = false
  }
}

variable "port_info_auditor_func_config_template" {
  default = {
    name                          = "func-cc-cp-portinfo-auditor-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1
  }
}

variable "port_info_veson_func_config_template" {
  default = {
    name                          = "func-cc-cp-veson-ports-api-adapter-%s"
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