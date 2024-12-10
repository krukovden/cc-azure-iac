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

provider "azurerm" {
  features {}
}

provider "rabbitmq" {
  endpoint = "https://${data.env_var.rabbit_url.value}"
  username = data.env_var.rabbit_user.value
  password = data.env_var.rabbit_pass.value
}

data "azurerm_client_config" "current" {}

data "azurerm_service_plan" "apis_service_plan" {
  name                = local.apis_service_plan_name
  resource_group_name = local.global_settings.resource_group_name
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

module "get_postgresql_ip" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.postgres_ip_key
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

module "veson_rmq_config" {
  source = "../Modules/rmqConfig"
}

module "network_restrictions" {
  source          = "../Modules/networkRestrictions"
  global_settings = local.global_settings
  vnet_name       = module.get_shared_vnet_name.value
}

#######################################################################
#-------------------Blob storage related resources--------------------#
#######################################################################

resource "azurerm_storage_account" "vesonBlobStorageAccount" {
  name                          = local.veson_storage_account_blob_config.name
  resource_group_name           = local.global_settings.resource_group_name
  location                      = local.global_settings.location
  account_tier                  = local.veson_storage_account_blob_config.account_tier
  account_replication_type      = local.veson_storage_account_blob_config.account_replication_type
  public_network_access_enabled = true

  blob_properties {
    last_access_time_enabled = true
  }

  # network_rules {
  #   default_action = "Deny"
  #   #ip_rules                   = [var.veson_function_subnet_config.address_prefix]
  #   virtual_network_subnet_ids = [azurerm_subnet.veson_functions_subnet.id]
  # }
}

resource "azurerm_storage_management_policy" "vesonBlobStorageAccountManagementPolicy" {
  storage_account_id = azurerm_storage_account.vesonBlobStorageAccount.id
  rule {
    name    = "VesonBlobLifecycle"
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
  depends_on = [ azurerm_storage_account.vesonBlobStorageAccount ]
}

resource "azurerm_storage_container" "vesonRawDataContainer" {
  name                  = local.veson_blob_storage_config.name
  storage_account_name  = azurerm_storage_account.vesonBlobStorageAccount.name
  container_access_type = local.veson_blob_storage_config.container_access_type

  depends_on = [ azurerm_storage_account.vesonBlobStorageAccount ]
}

resource "azurerm_storage_blob" "vesonRawDataBlob" {
  name                   = local.veson_raw_storage_container_config.name
  storage_account_name   = azurerm_storage_account.vesonBlobStorageAccount.name
  storage_container_name = azurerm_storage_container.vesonRawDataContainer.name
  type                   = local.veson_raw_storage_container_config.type
}

resource "azurerm_key_vault_secret" "blob_conneciton_string" {
  name         = var.keyvault_config.blob_conneciton_string_name
  value        = azurerm_storage_account.vesonBlobStorageAccount.primary_connection_string
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "blob_account_key" {
  name         = var.keyvault_config.blob_account_key
  value        = azurerm_storage_account.vesonBlobStorageAccount.primary_access_key
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_name" {
  name         = var.keyvault_config.strg_acc_name
  value        = azurerm_storage_account.vesonBlobStorageAccount.name
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_key" {
  name         = var.keyvault_config.strg_acc_key
  value        = azurerm_storage_account.vesonBlobStorageAccount.primary_access_key
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_uri" {
  name         = var.keyvault_config.strg_acc_uri
  value        = azurerm_storage_account.vesonBlobStorageAccount.primary_blob_endpoint
  key_vault_id = module.get_shared_kv_id.value
}

#######################################################################
#---------------------Funcitons related resources---------------------#
#######################################################################

resource "azurerm_subnet" "veson_functions_subnet" {
  resource_group_name  = local.global_settings.resource_group_name
  name                 = module.subnet_config.veson_function_subnet_config.name
  address_prefixes     = [module.subnet_config.veson_function_subnet_config.address_prefix]
  virtual_network_name = module.get_shared_vnet_name.value

  service_endpoints = module.subnet_config.veson_function_subnet_config.service_endpoints
  delegation {
    name = module.subnet_config.veson_function_subnet_config.delegation_name
    service_delegation {
      name    = module.subnet_config.veson_function_subnet_config.service_delegation_name
      actions = module.subnet_config.veson_function_subnet_config.service_delegation_actions
    }
  }
}

resource "azurerm_network_security_rule" "allow-access-veson-func-to-sql" {
  name                        = var.nsr_allow_access_func_to_sql_config.name
  priority                    = var.nsr_allow_access_func_to_sql_config.priority
  direction                   = var.nsr_allow_access_func_to_sql_config.direction
  access                      = var.nsr_allow_access_func_to_sql_config.access
  protocol                    = var.nsr_allow_access_func_to_sql_config.protocol
  source_port_range           = var.nsr_allow_access_func_to_sql_config.source_port_range
  destination_port_range      = var.nsr_allow_access_func_to_sql_config.destination_port_range
  source_address_prefix       = module.subnet_config.veson_function_subnet_config.address_prefix
  destination_address_prefix  = module.get_postgresql_ip.value
  resource_group_name         = local.global_settings.resource_group_name
  network_security_group_name = module.get_shared_nsg_name.value
}

resource "azurerm_storage_account" "veson_functions_storage_account" {
  name                     = local.veson_storage_account_config.name
  resource_group_name      = local.global_settings.resource_group_name
  location                 = local.global_settings.location
  account_tier             = local.veson_storage_account_config.account_tier
  account_replication_type = local.veson_storage_account_config.account_replication_type
}

resource "azurerm_service_plan" "veson_functions_service_plan" {
  name                = local.veson_function_service_plan_config.name
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location
  os_type             = local.veson_function_service_plan_config.os_type
  sku_name            = local.veson_function_service_plan_config.sku_name
  worker_count        = local.veson_function_service_plan_config.worker_count
}

data "azurerm_log_analytics_workspace" "lws_func_apps_logs" {
  name                = "lws-cc-cp-func-apps-logs"
  resource_group_name = local.global_settings.resource_group_name
}