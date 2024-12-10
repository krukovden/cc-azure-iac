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