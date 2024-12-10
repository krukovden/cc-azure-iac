variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"
    identity                 = "id-us-mgd-commoncore"

    tags = {
      Project     = "CommonCore",
      Environment = "%s",
      CreatedBy   = "Terraform"
    }
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

variable "appconf_config_template" {
  default = {
    name                  = "appconf-cc-cp-%s"
    label                 = "%s"
    identity_type         = "SystemAssigned"
    postgres_ip_key       = "cc:cp:postgresql:ip:%s"
    nsg_name              = "cc:cp:nsg:name:%s"
    vnet_name             = "cc:cp:vnet:name:%s"
    apim_subnet_id_key    = "cc:cp:apim:subnet:id:%s"
    keyvault_id           = "cc:cp:kv:id:%s"
    keyvault_name         = "cc:cp:kv:name:%s"
    apim_name_key         = "cc:cp:apim:name:%s"
    public_network_access = "Enabled"
  }
}

variable "disco_storage_account_config_template" {
  default = {
    name                     = "stcccpdiscofunc%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "disco_function_service_plan_config_template" {
  default = {
    name         = "sp-cc-disco-functions-%s"
    os_type      = "Linux"
    sku_name     = ""
    worker_count = 1
  }
}

variable "disco_error_receiver_func_config_template" {
  default = {
    name                          = "func-cc-disco-error-receiver-%s"
    public_network_access_enabled = true
    logs_quota_mb                 = 30
    logs_retention_period_days    = 0
  }
}

variable "funcitons_kv_permissions" {
  default = {
    secret_permissions      = ["Get", "List"]
    key_permissions         = ["Decrypt", "Encrypt", "Get", "List"]
    certificate_permissions = ["Get", "GetIssuers", "List", "ListIssuers"]
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