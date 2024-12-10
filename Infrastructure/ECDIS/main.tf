terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
    rabbitmq = {
      source  = "cyrilgdn/rabbitmq"
      version = "~> 1.8.0"
    }
    env = {
      source  = "tcarreira/env"
      version = "~> 0.2.0"
    }
  }

  required_version = ">= 1.1.0"
}

data "env_var" "rabbit_url" {
  id       = var.shared_rabbitmq_env_vars.rabbit_url
  required = true # (optional) plan will error if not found
}

data "env_var" "rabbit_pass" {
  id       = var.shared_rabbitmq_env_vars.rabbit_pass
  required = true # (optional) plan will error if not found

}
data "env_var" "rabbit_user" {
  id       = var.shared_rabbitmq_env_vars.rabbit_user
  required = true # (optional) plan will error if not found
}

data "env_var" "rabbit_vhost" {
  id       = var.shared_rabbitmq_env_vars.rabbit_vhost
  required = true # (optional) plan will error if not found
}

data "env_var" "rabbit_port" {
  id       = var.shared_rabbitmq_env_vars.rabbit_port
  required = true # (optional) plan will error if not found
}

data "env_var" "rabbit_connection_string" {
  id       = var.shared_rabbitmq_env_vars.rabbit_connection_string
  required = true # (optional) plan will error if not found
}

provider "azurerm" {
  features {}
}

provider "rabbitmq" {
  endpoint = "https://${data.env_var.rabbit_url.value}"
  username = data.env_var.rabbit_user.value
  password = data.env_var.rabbit_pass.value
}

data "azurerm_client_config" "current" {}

data "env_var" "db_pass" {
  id       = var.env_vars_names.db_pass
  required = true # (optional) plan will error if not found
}

data "azurerm_virtual_network" "vnet" {
  name                 = local.vnet_name
  resource_group_name  = local.global_settings.resource_group_name
}

data "azurerm_subnet" "vnet_subnets" {
  for_each             = toset(data.azurerm_virtual_network.vnet.subnets)
  name                 = each.value
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_private_endpoint_connection" "postgresql_private_connection" {
  name                = local.postgresql_private_endpoint_name
  resource_group_name = local.global_settings.data_resource_group_name
}

data "azurerm_key_vault" "shared_key_vault" {
  name                = local.shared_key_vault_params.name
  resource_group_name = local.global_settings.data_resource_group_name
}

data "azurerm_log_analytics_workspace" "lws_func_apps_logs" {
  name                = "lws-cc-cp-func-apps-logs"
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_storage_account" "shared_functions_storage_account" {
  name                = local.shared_func_storage_account_name
  resource_group_name = local.global_settings.resource_group_name
}

module "rmq_config" {
  source = "../Modules/rmqConfig"
}

#######################################################################
#-------------------Read shared recources information-----------------#
#######################################################################

module "get_shared_nsg_name" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.nsg_name
  label          = local.appconf_config.label
}

module "get_shared_vnet_name" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.vnet_name
  label          = local.appconf_config.label
}

module "get_shared_kv_id" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.keyvault_id
  label          = local.appconf_config.label
}

module "get_shared_kv_name" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.keyvault_name
  label          = local.appconf_config.label
}

module "subnet_config" {
  source      = "../Modules/subnetConfigs"
  environment = local.global_settings.tags.Environment
}

module "network_restrictions" {
  source          = "../Modules/networkRestrictions"
  global_settings = local.global_settings
  vnet_name       = module.get_shared_vnet_name.value
}

#######################################################################
#-------------------Blob storage related resources--------------------#
#######################################################################

resource "azurerm_storage_account" "ecdisTempBlobStorageAccount" {
  name                          = local.ecdis_temp_storage_account_blob_config.name
  resource_group_name           = local.global_settings.resource_group_name
  location                      = local.global_settings.location
  account_tier                  = local.ecdis_temp_storage_account_blob_config.account_tier
  account_replication_type      = local.ecdis_temp_storage_account_blob_config.account_replication_type
  public_network_access_enabled = true
  
  blob_properties {
    last_access_time_enabled = true
  }
}

resource "azurerm_storage_queue" "ecdisBlobAddedQueue" {
  name                 = local.ecdis_temp_storage_account_blob_config.blob_added_queue_name
  storage_account_name = azurerm_storage_account.ecdisTempBlobStorageAccount.name
  depends_on           = [azurerm_storage_account.ecdisTempBlobStorageAccount]
}

resource "azurerm_eventgrid_event_subscription" "ecdisBlobAddedSubscription" {
  name  = local.ecdis_temp_storage_account_blob_config.blob_added_event_name
  scope = azurerm_storage_account.ecdisTempBlobStorageAccount.id

  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.ecdisTempBlobStorageAccount.id
    queue_name         = azurerm_storage_queue.ecdisBlobAddedQueue.name
  }

  included_event_types  = ["Microsoft.Storage.BlobCreated"]
  event_delivery_schema = "CloudEventSchemaV1_0"
  depends_on = [
    azurerm_storage_queue.ecdisBlobAddedQueue,
    azurerm_storage_account.ecdisTempBlobStorageAccount
  ]
}

resource "azurerm_storage_management_policy" "ecdisTempBlobStorageAccountManagementPolicy" {
  storage_account_id = azurerm_storage_account.ecdisTempBlobStorageAccount.id
  rule {
    name    = "RemoveAfterMonth"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 30
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
    }
  }
  depends_on = [ azurerm_storage_account.ecdisTempBlobStorageAccount ]
}

resource "azurerm_key_vault_secret" "temp_blob_conneciton_string" {
  name         = var.keyvault_config.temp_blob_conneciton_string_name
  value        = azurerm_storage_account.ecdisTempBlobStorageAccount.primary_connection_string
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "temp_blob_account_key" {
  name         = var.keyvault_config.temp_blob_account_key
  value        = azurerm_storage_account.ecdisTempBlobStorageAccount.primary_access_key
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "temp_blob_account_url" {
  name         = var.keyvault_config.temp_blob_account_url
  value        = azurerm_storage_account.ecdisTempBlobStorageAccount.primary_blob_endpoint
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "temp_blob_account_name" {
  name         = var.keyvault_config.temp_blob_account_name
  value        = azurerm_storage_account.ecdisTempBlobStorageAccount.name
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_storage_account" "ecdisPermanentBlobStorageAccount" {
  name                          = local.ecdis_permanent_storage_account_blob_config.name
  resource_group_name           = local.global_settings.resource_group_name
  location                      = local.global_settings.location
  account_tier                  = local.ecdis_permanent_storage_account_blob_config.account_tier
  account_replication_type      = local.ecdis_permanent_storage_account_blob_config.account_replication_type
  public_network_access_enabled = true

  blob_properties {
    last_access_time_enabled = true
  }
}

resource "azurerm_storage_container" "ecdisSchemaDataContainer" {
  name                  = var.ecdis_schema_storage_container_config.name
  storage_account_name  = azurerm_storage_account.ecdis_functions_storage_account.name
  container_access_type = var.ecdis_schema_storage_container_config.container_access_type
}

resource "azurerm_storage_blob" "ecdisRtz10SchemaBlob" {
  name                   = "rtz_v1.0.xsd"
  storage_account_name   = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_container_name = azurerm_storage_container.ecdisSchemaDataContainer.name
  type                   = "Block"
  source                 = "./Resources/rtz_v1.0.xsd"
}

resource "azurerm_storage_blob" "ecdisRtz12SchemaBlob" {
  name                   = "rtz_v1.2.xsd"
  storage_account_name   = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_container_name = azurerm_storage_container.ecdisSchemaDataContainer.name
  type                   = "Block"
  source                 = "./Resources/rtz_v1.2.xsd"
}

resource "azurerm_storage_management_policy" "ecdisPermanentBlobStorageAccountManagementPolicy" {
  storage_account_id = azurerm_storage_account.ecdisPermanentBlobStorageAccount.id
  rule {
    name    = "PermanentBlobLifecycle"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cold_after_days_since_modification_greater_than    = 7
        tier_to_archive_after_days_since_modification_greater_than = 30
        delete_after_days_since_last_access_time_greater_than = 1461 # 4 years
      }
    }
  }
  depends_on = [ azurerm_storage_account.ecdisPermanentBlobStorageAccount ]
}

resource "azurerm_key_vault_secret" "permanent_blob_account_key" {
  name         = var.keyvault_config.permanent_blob_account_key
  value        = azurerm_storage_account.ecdisPermanentBlobStorageAccount.primary_access_key
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "permanent_blob_conneciton_string" {
  name         = var.keyvault_config.permanent_blob_conneciton_string_name
  value        = azurerm_storage_account.ecdisTempBlobStorageAccount.primary_connection_string
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "permanent_blob_account_url" {
  name         = var.keyvault_config.permanent_blob_account_url
  value        = azurerm_storage_account.ecdisPermanentBlobStorageAccount.primary_blob_endpoint
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "permanent_blob_account_name" {
  name         = var.keyvault_config.permanent_blob_account_name
  value        = azurerm_storage_account.ecdisPermanentBlobStorageAccount.name
  key_vault_id = module.get_shared_kv_id.value
}

#######################################################################
#---------------------Funcitons related resources---------------------#
#######################################################################

resource "azurerm_subnet" "ecdis_functions_subnet" {
  resource_group_name  = local.global_settings.resource_group_name
  name                 = module.subnet_config.ecdis_function_subnet_config.name
  address_prefixes     = [module.subnet_config.ecdis_function_subnet_config.address_prefix]
  virtual_network_name = module.get_shared_vnet_name.value

  service_endpoints = module.subnet_config.ecdis_function_subnet_config.service_endpoints
  delegation {
    name = module.subnet_config.ecdis_function_subnet_config.delegation_name
    service_delegation {
      name    = module.subnet_config.ecdis_function_subnet_config.service_delegation_name
      actions = module.subnet_config.ecdis_function_subnet_config.service_delegation_actions
    }
  }
}

resource "azurerm_storage_account" "ecdis_functions_storage_account" {
  name                     = local.ecdis_storage_account_config.name
  resource_group_name      = local.global_settings.resource_group_name
  location                 = local.global_settings.location
  account_tier             = local.ecdis_storage_account_config.account_tier
  account_replication_type = local.ecdis_storage_account_config.account_replication_type
}

resource "azurerm_service_plan" "ecdis_functions_service_plan" {
  name                = local.ecdis_function_service_plan_config.name
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location
  os_type             = local.ecdis_function_service_plan_config.os_type
  sku_name            = local.ecdis_function_service_plan_config.sku_name
  worker_count        = local.ecdis_function_service_plan_config.worker_count
}