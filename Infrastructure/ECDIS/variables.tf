variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"
    identity                 = "id-us-mgd-commoncore"
    partner_name             = "ECDIS"  

    tags = {
      Project     = "ECDIS",
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
    nsg_name           = "cc:cp:nsg:name:%s"
    vnet_name          = "cc:cp:vnet:name:%s"
    apim_subnet_id_key = "cc:cp:apim:subnet:id:%s"
    keyvault_id        = "cc:cp:kv:id:%s"
    keyvault_name      = "cc:cp:kv:name:%s"
  }
}

variable "env_vars_names" {
  default = {
    db_pass                  = "TF_DATABASE_PASSWORD"
    publisher_name           = "GH_PUBLISHER_NAME"
    publisher_email          = "GH_PUBLISHER_EMAIL"
  }
}

variable "ecdis_temp_storage_account_blob_config_template" {
  default = {
    name                     = "stccecdistemp%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    blob_added_queue_name    = "q-cccp-ecdis-blob"
    blob_added_event_name    = "move-to-q-cccp-ecdis-blob"
  }
}

variable "ecdis_permanent_storage_account_blob_config_template" {
  default = {
    name                     = "stccecdisinput%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "ecdis_storage_account_config_template" {
  default = {
    name                     = "stccecdisfunc%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "keyvault_config" {
  default = {
    db_connection_string_name             = "DbConnectionString"
    temp_blob_conneciton_string_name      = "EcdisTempBlobConnectionString"
    permanent_blob_conneciton_string_name = "EcdisPermanentBlobConnectionString"
    temp_blob_account_key                 = "EcdisTempBlobAccountKey"
    permanent_blob_account_key            = "EcdisPermanentBlobAccountKey"
    temp_blob_account_url                 = "EcdisTempBlobAccountUrl"
    permanent_blob_account_url            = "EcdisPermanentBlobAccountUrl"
    temp_blob_account_name                = "EcdisTempBlobAccountName"
    permanent_blob_account_name           = "EcdisPermanentBlobAccountName"
    rmq_host_name                         = "RmqHostName"
    rmq_user_name                         = "RmqUserName"
    rmq_password_name                     = "RmqPassword"
    rmq_vhost_name                        = "RmqVhost"
    rmq_port_name                         = "RmqPort"
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

variable "funcitons_kv_permissions" {
  default = {
    secret_permissions      = ["Get", "List"]
    key_permissions         = ["Decrypt", "Encrypt", "Get", "List"]
    certificate_permissions = ["Get", "GetIssuers", "List", "ListIssuers"]
  }
}

variable "ecdis_upload_rmq_adapter_func_config_template" {
  default = {
    name                          = "func-cc-cp-ecdis-upload-rmq-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 0
  }
}

variable "ecdis_function_service_plan_config_template" {
  default = {
    name                   = "sp-cc-ecdis-functions-%s"
    os_type                = "Linux"
    sku_name               = ""
    worker_count           = 1
    zone_balancing_enabled = false
  }
}

variable "ecdis_blob_exchange_config" {
  default = {
    name        = "et.cccp.ecdis.blob"
    type        = "topic"
    durable     = true
    auto_delete = false
  }
}

variable "ecdis_blob_queue_config" {
  default = {
    name        = "q.cccp.ecdis.blob"
    durable     = true
    auto_delete = false
  }
}

variable "ecdis_blob_dead_letter_queue_config" {
  default = {
    name        = "dlq.cccp.ecdis.blob"
    durable     = true
    auto_delete = false
  }
}

variable "ecdis_blob_delay_exchange_config" {
  default = {
    name        = "et.cccp.ecdis.blob.delay"
    type        = "x-delayed-message"
    durable     = true
    auto_delete = false
  }
}

variable "ecdis_persist_raw_adapter_func_config_tempalte" {
  default = {
    name                          = "func-cc-cp-ecdis-raw-writer-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 0
  }  
}

variable "ecdis_schema_storage_container_config" {
  default = {
    name                  = "rtz-schemas"
    container_access_type = "blob"
  }
}

variable "ecdis_ingest_adapter_func_config_template" {
  default = {
    name                          = "func-cc-cp-ecdis-canonicalize-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 0
  }
}

variable "ecdis_blob_tmp_exchange_config" {
  default = {
    name        = "et.cccp.ecdis.tmp.blob"
    type        = "topic"
    durable     = true
    auto_delete = false
  }
}

variable "ecdis_blob_tmp_queue_config" {
  default = {
    name        = "q.cccp.ecdis.tmp.blob"
    durable     = true
    auto_delete = false
  }
}

variable "ecdis_blob_tmp_dead_letter_queue_config" {
  default = {
    name        = "dlq.cccp.ecdis.tmp.blob"
    durable     = true
    auto_delete = false
  }
}

variable "ecdis_blob_tmp_delay_exchange_config" {
  default = {
    name        = "et.cccp.ecdis.tmp.blob.delay"
    type        = "x-delayed-message"
    durable     = true
    auto_delete = false    
  }
}

variable "ecdis_waypoints_exchange_config" {
  default = {
    name        = "et.cccp.ecdis.waypoints"
    type        = "topic"
    durable     = true
    auto_delete = false
  }
}

variable "ecdis_waypoints_queue_config" {
  default = {
    name        = "q.cccp.ecdis.waypoints"
    durable     = true
    auto_delete = false    
  }
}

variable "ecdis_waypoints_dead_letter_queue_config" {
  default = {
    name        = "dlq.cccp.ecdis.waypoints"
    durable     = true
    auto_delete = false
  }
}

variable "ecdis_waypoints_delay_exchange_config" {
  default = {
    name        = "et.cccp.ecdis.waypoints.delay"
    type        = "x-delayed-message"
    durable     = true
    auto_delete = false    
  }
}

variable "ecdis_status_exchange_config" {
  default = {
    name        = "et.cccp.ecdis.status"
    type        = "topic"
    durable     = true
    auto_delete = false    
  }
}

variable "ecdis_status_queue_config" {
  default = {
    name        = "q.cccp.ecdis.status"
    durable     = true
    auto_delete = false    
  }
}

variable "ecdis_tenant_adapter_func_config_template" {
  default = {
    name                          = "func-cc-cp-ecdis-tenant-adapter-%s"
    rule_default_action           = "Allow"
    rule_bypass                   = ["AzureServices", "Logging", "Metrics"]
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 0
  }
}

variable "ecdis_audit_delay_exchange_config" {
  default = {
    name        = "et.cccp.ecdis.audit.delay"
    type        = "x-delayed-message"
    durable     = true
    auto_delete = false    
  }
}

variable "ecdis_audit_queue_config" {
  default = {
    name        = "q.cccp.ecdis.audit"
    durable     = true
    auto_delete = false    
  }
}

variable "ecdis_audit_exchange_config" {
  default = {
    name        = "et.cccp.ecdis.audit"
    type        = "topic"
    durable     = true
    auto_delete = false    
  }
}

variable "shared_service_plan_name_template" {
  default = "sp-cc-cp-functions-%s"
}

variable "postgresql_private_endpoint_name_template" {
  default = "pe-cc-cp-postgresql-%s"
}

variable "ecdis_audit_func_config_template" {
  default = {
    name                          = "func-cc-cp-ecdis-auditor-%s"
    public_network_access_enabled = true
    cors_allowed_origins          = ["https://portal.azure.com"]
    cors_support_credentials      = false

    app_settings = {}
  }
}

variable "vnet_name_template" {
  default = "vnet-cc-cp-shared-%s"
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