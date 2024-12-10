variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"
    identity                 = "id-us-mgd-commoncore"

    tags = {
      Project     = "VoyageManager",
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

variable "vnet_name_template" {
  default = "vnet-cc-cp-shared-%s"
}

variable "shared_service_plan_name_template" {
  default = "sp-cc-cp-functions-%s"
}

variable "postgresql_private_endpoint_name_template" {
  default = "pe-cc-cp-postgresql-%s"
}

variable "shared_func_storage_account_name_template" {
  default = "stcccpfunc%s"
}

variable "storage_account_config_template" {
  default = {
    name                     = "stccvmfunc%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "shared_key_vault_params_template" {
  default = {
    name = "kv-cc-cp-%s"
    secrets = {
      db_connection_string_name = "DbConnectionString"
      rmq_host_name             = "RmqHostName"
      rmq_user_name             = "RmqUserName"
      rmq_password_name         = "RmqPassword"
      rmq_vhost_name            = "RmqVhost"
      rmq_port_name             = "RmqPort"
      encryption_key_name       = "VoyageManagerAesGcmKey"
      key_rotation_interval     = "0 0 0 1 * *"
    }
  }
}

variable "function_service_plan_config_template" {
  default = {
    name                   = "sp-cc-vm-functions-%s"
    os_type                = "Linux"
    sku_name               = ""
    worker_count           = 1
    zone_balancing_enabled = false
  }
}

variable "funcitons_kv_permissions" {
  default = {
    secret_permissions      = ["Get", "List", "Set"]
    key_permissions         = ["Decrypt", "Encrypt", "Get", "List"]
    certificate_permissions = ["Get", "GetIssuers", "List", "ListIssuers"]
  }
}

variable "nsr_allow_access_func_to_sql_config" {
  default = {
    name                   = "nsr-allow-access-vm-func-to-sql"
    priority               = 110
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "*"
  }
}

variable "vm_provision_adapter_func_config_template" {
  default = {
    name                          = "func-cc-cp-vm-provision-adapter-%s"
    public_network_access_enabled = true
    cors_allowed_origins          = ["https://portal.azure.com"]
    cors_support_credentials      = false
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1

    app_settings = {}
  }
}

variable "vm_key_rotation_func_config_template" {
  default = {
    name                          = "func-cc-cp-vm-key-rotation-%s"
    public_network_access_enabled = true
    cors_allowed_origins          = ["https://portal.azure.com"]
    cors_support_credentials      = false
    logs_quota_mb                 = 30
    logs_retention_period_days    = 1

    app_settings = {}
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

variable "ENV" {
  description = "DEV, QA, STG or PRD"
  type        = string
}

variable "REGION_SUFFIX" {
  description = "eus (East US), wus (West US), eu (Europe) or ..."
  type        = string
}

variable "REGION_CODE" {
  description = "europe, southcentralus, eastus or ..."
  type        = string
}
