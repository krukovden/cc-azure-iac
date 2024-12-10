variable "global_settings_template" {
  default = {
    location                      = ""
    resource_group_name           = "rg-%s-commoncore-001"
    retention_resource_group_name = "rg-%s-cccp-retention"
    data_resource_group_name      = "rg-%s-commoncore-001-data"
    dotnet_version                = "8.0"

    tags = {
      Project     = "CommonCore",
      Environment = "%s",
      CreatedBy   = "Terraform"
    }
  }
}

variable "shared_network_security_group_config_template" {
  default = {
    name = "nsg-cc-cp-shared-%s"
  }
}

variable "nsr_allow_access_func_to_sql_config_template" {
  default = {
    name                   = "nsr-allow-access-func-to-sql-%s"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "*"
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
    publisher_name           = "GH_PUBLISHER_NAME"
    publisher_email          = "GH_PUBLISHER_EMAIL"
  }
}

variable "funcitons_kv_permissions" {
  default = {
    secret_permissions      = ["Get", "List"]
    key_permissions         = ["Decrypt", "Encrypt", "Get", "List"]
    certificate_permissions = ["Get", "GetIssuers", "List", "ListIssuers"]
  }
}

variable "keyvault_config_template" {
  default = {
    name                      = "kv-cc-cp-%s"
    sku_name                  = "standard"
    db_connection_string_name = "DbConnectionString"
    rmq_host_name             = "RmqHostName"
    rmq_user_name             = "RmqUserName"
    rmq_password_name         = "RmqPassword"
    rmq_vhost_name            = "RmqVhost"
    rmq_port_name             = "RmqPort"

    access_policies = {
      "DEV_TEAM" = {
        object_id               = "6b6362d0-0a53-4aeb-bfc7-95d83f396706"
        secret_permissions      = ["Get", "Set", "Delete", "List", "Recover", "Backup", "Restore", "Purge"]
        key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
        certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
      }

      "TERRAFORM" = {
        object_id               = "42c0ea39-d811-4e22-9b3a-279aee6774fe"
        secret_permissions      = ["Get", "Set", "Delete", "List", "Recover", "Backup", "Restore", "Purge"]
        key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
        certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
      }

      "PRD_TERRAFORM" = {
        object_id               = "f145375d-bf8a-4b43-ad6d-3c43af289933"
        secret_permissions      = ["Get", "Set", "Delete", "List", "Recover", "Backup", "Restore", "Purge"]
        key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
        certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
      }

      "FUNCTIONS" = {
        object_id               = "74037b57-50dd-4220-a9e9-89ad8dc9f8ce"
        secret_permissions      = ["Get", "List"]
        key_permissions         = ["Decrypt", "Encrypt", "Get", "List"]
        certificate_permissions = ["Get", "GetIssuers", "List", "ListIssuers"]
      }
    }
  }
}

variable "vnet_config_template" {
  default = {
    name          = "vnet-cc-cp-shared-%s"
    address_space = ["10.0.0.0/16"]
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

variable "shared_func_storage_account_config_template" {
  default = {
    name                     = "stcccpfunc%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "postgresql_private_endpoint_template" {
  default = {
    name                 = "pe-cc-cp-postgresql-%s"
    is_manual_connection = false
    subresource          = ["postgresqlServer"]
    dns_group_name       = "dns-cc-cp-postgresql-%s"
  }
}

variable "shared_service_plan_config_template" {
  default = {
    name                   = "sp-cc-cp-functions-%s"
    os_type                = "Linux"
    sku_name               = ""
    worker_count           = 1
    zone_balancing_enabled = false
  }
}

variable "shared_service_plan_sku_name" {
  default = {
    dev = "P1mv3"
    qa  = "P1mv3"
    stg = "P1mv3"
    prd = "P1mv3"
  }
}

variable "apis_service_plan_config_template" {
  default = {
    name                   = "sp-cc-cp-api-functions-%s"
    os_type                = "Linux"
    sku_name               = ""
    worker_count           = 1
    zone_balancing_enabled = false
  }
}

variable "apis_service_plan_sku_name" {
  default = {
    dev = "P1mv3"
    qa  = "P1mv3"
    stg = "P1mv3"
    prd = "P1mv3"
  }
}

variable "public_storage_account_config_template" {
  default = {
    name                     = "stccppublic%s"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

variable "contracts_container_config" {
  default = {
    name                  = "contracts",
    container_access_type = "blob"
  }
}

variable "server_name_template" {
  default = "cc-cp-norm-server-%s"
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
