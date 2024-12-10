terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
    env = {
      source  = "tcarreira/env"
      version = "~> 0.2.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
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

data "env_var" "db_pass" {
  id       = var.env_vars_names.db_pass
  required = true # (optional) plan will error if not found
}

data "azurerm_client_config" "current" {}

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

data "azurerm_service_plan" "shared_service_plan" {
  name                = local.shared_service_plan_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_log_analytics_workspace" "func_apps_logs_ws" {
  name                = "lws-cc-cp-func-apps-logs"
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_private_endpoint_connection" "postgresql_private_connection" {
  name                = local.postgresql_private_endpoint_name
  resource_group_name = local.global_settings.data_resource_group_name
}

data "azurerm_storage_account" "shared_functions_storage_account" {
  name                = local.shared_func_storage_account_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_key_vault" "shared_key_vault" {
  name                = local.shared_key_vault_params.name
  resource_group_name = local.global_settings.data_resource_group_name
}

data "azurerm_service_plan" "apis_service_plan" {
  name                = local.apis_service_plan_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_service_plan" "ecdis_service_plan" {
  name                = local.ecdis_service_plan_name
  resource_group_name = local.global_settings.resource_group_name
}

module "get_shared_kv_id" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.keyvault_id
  label          = local.appconf_config.label
}

module "subnet_config" {
  source      = "../Modules/subnetConfigs"
  environment = local.global_settings.tags.Environment
}

module "network_restrictions" {
  source          = "../Modules/networkRestrictions"
  global_settings = local.global_settings
  vnet_name       = local.vnet_name
}

resource "azurerm_storage_account" "waypoints_retention_storage_account" {
  name                     = local.retention_storage_account_config.name
  resource_group_name      = local.global_settings.retention_resource_group_name
  location                 = local.global_settings.location
  account_tier             = local.retention_storage_account_config.account_tier
  account_replication_type = local.retention_storage_account_config.account_replication_type
  access_tier              = local.retention_storage_account_config.access_tier
  tags                     = local.global_settings.tags
}

resource "azurerm_key_vault_secret" "strg_acc_key" {
  name         = local.shared_key_vault_params.secrets.strg_acc_key
  value        = azurerm_storage_account.waypoints_retention_storage_account.primary_access_key
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_name" {
  name         = local.shared_key_vault_params.secrets.strg_acc_name
  value        = azurerm_storage_account.waypoints_retention_storage_account.name
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_uri" {
  name         = local.shared_key_vault_params.secrets.strg_acc_uri
  value        = azurerm_storage_account.waypoints_retention_storage_account.primary_blob_endpoint
  key_vault_id = module.get_shared_kv_id.value
}