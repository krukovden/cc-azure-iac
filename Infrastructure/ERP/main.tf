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

module "erp_rmq_config" {
  source = "../Modules/rmqConfig"
}

module "network_restrictions" {
  source          = "../Modules/networkRestrictions"
  global_settings = local.global_settings
  vnet_name       = module.get_shared_vnet_name.value
}

#######################################################################
#---------------------Funcitons related resources---------------------#
#######################################################################

resource "azurerm_subnet" "erp_functions_subnet" {
  resource_group_name  = local.global_settings.resource_group_name
  name                 = module.subnet_config.erp_function_subnet_config.name
  address_prefixes     = [module.subnet_config.erp_function_subnet_config.address_prefix]
  virtual_network_name = module.get_shared_vnet_name.value

  service_endpoints = module.subnet_config.erp_function_subnet_config.service_endpoints
  delegation {
    name = module.subnet_config.erp_function_subnet_config.delegation_name
    service_delegation {
      name    = module.subnet_config.erp_function_subnet_config.service_delegation_name
      actions = module.subnet_config.erp_function_subnet_config.service_delegation_actions
    }
  }
}

resource "azurerm_network_security_rule" "allow-access-erp-func-to-sql" {
  name                        = var.nsr_allow_access_func_to_sql_config.name
  priority                    = var.nsr_allow_access_func_to_sql_config.priority
  direction                   = var.nsr_allow_access_func_to_sql_config.direction
  access                      = var.nsr_allow_access_func_to_sql_config.access
  protocol                    = var.nsr_allow_access_func_to_sql_config.protocol
  source_port_range           = var.nsr_allow_access_func_to_sql_config.source_port_range
  destination_port_range      = var.nsr_allow_access_func_to_sql_config.destination_port_range
  source_address_prefix       = module.subnet_config.erp_function_subnet_config.address_prefix
  destination_address_prefix  = module.get_postgresql_ip.value
  resource_group_name         = local.global_settings.resource_group_name
  network_security_group_name = module.get_shared_nsg_name.value
}

resource "azurerm_storage_account" "erp_functions_storage_account" {
  name                     = local.erp_storage_account_config.name
  resource_group_name      = local.global_settings.resource_group_name
  location                 = local.global_settings.location
  account_tier             = local.erp_storage_account_config.account_tier
  account_replication_type = local.erp_storage_account_config.account_replication_type
}

// 10-15-2024 Can be deleted after updating all environments.
/*
resource "azurerm_service_plan" "erp_functions_service_plan" {
  name                = local.erp_function_common_service_plan_config.name
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location
  os_type             = local.erp_function_common_service_plan_config.os_type
  sku_name            = local.erp_function_common_service_plan_config.sku_name
  worker_count        = local.erp_function_common_service_plan_config.worker_count
}
*/

resource "azurerm_service_plan" "erp_functions_service_plan_1" {
  name                = local.erp_function_service_plan_1_config.name
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location
  os_type             = local.erp_function_service_plan_1_config.os_type
  sku_name            = local.erp_function_service_plan_1_config.sku_name
  worker_count        = local.erp_function_service_plan_1_config.worker_count
}

resource "azurerm_service_plan" "erp_functions_service_plan_2" {
  name                = local.erp_function_service_plan_2_config.name
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location
  os_type             = local.erp_function_service_plan_2_config.os_type
  sku_name            = local.erp_function_service_plan_2_config.sku_name
  worker_count        = local.erp_function_service_plan_2_config.worker_count
}

data "azurerm_log_analytics_workspace" "lws_func_apps_logs" {
  name                = "lws-cc-cp-func-apps-logs"
  resource_group_name = local.global_settings.resource_group_name
}
