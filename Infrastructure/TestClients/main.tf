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

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "lws_func_apps_logs" {
  name                = "lws-cc-cp-func-apps-logs"
  resource_group_name = local.global_settings.resource_group_name
}

data "env_var" "rabbit_connection_string" {
  id       = var.shared_rabbitmq_env_vars.rabbit_connection_string
  required = true # (optional) plan will error if not found
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
#---------------------Funcitons related resources---------------------#
#######################################################################

resource "azurerm_subnet" "test_client_functions_subnet" {
  resource_group_name  = local.global_settings.resource_group_name
  name                 = module.subnet_config.test_client_function_subnet_config.name
  address_prefixes     = [module.subnet_config.test_client_function_subnet_config.address_prefix]
  virtual_network_name = module.get_shared_vnet_name.value

  service_endpoints = module.subnet_config.test_client_function_subnet_config.service_endpoints
  delegation {
    name = module.subnet_config.test_client_function_subnet_config.delegation_name
    service_delegation {
      name    = module.subnet_config.test_client_function_subnet_config.service_delegation_name
      actions = module.subnet_config.test_client_function_subnet_config.service_delegation_actions
    }
  }
}

resource "azurerm_storage_account" "test_client_functions_storage_account" {
  name                     = local.test_client_storage_account_config.name
  resource_group_name      = local.global_settings.resource_group_name
  location                 = local.global_settings.location
  account_tier             = local.test_client_storage_account_config.account_tier
  account_replication_type = local.test_client_storage_account_config.account_replication_type
}

resource "azurerm_service_plan" "test_client_functions_service_plan" {
  name                = local.test_client_function_service_plan_config.name
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location
  os_type             = local.test_client_function_service_plan_config.os_type
  sku_name            = local.test_client_function_service_plan_config.sku_name
  worker_count        = local.test_client_function_service_plan_config.worker_count
}

module "test_client_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.test_client_function_service_plan_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.test_client_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.test_client_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.test_client_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.test_client_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.test_client_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.test_client_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.test_client_func_config.logs_quota_mb
  logs_retention_period_days         = local.test_client_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {    
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1",
	  "WEBSITE_RUN_FROM_PACKAGE"               = "1",
    "ROOT_LOCATION"                          = local.test_client_func_config.root_location,
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
  }

  func_ip_restrictions = [  
  ]

  depends_on = [
    azurerm_storage_account.test_client_functions_storage_account,
    azurerm_service_plan.test_client_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs,
  ]
}