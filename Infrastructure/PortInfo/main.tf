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

data "azurerm_log_analytics_workspace" "lws_func_apps_logs" {
  name                = "lws-cc-cp-func-apps-logs"
  resource_group_name = local.global_settings.resource_group_name
}

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

module "network_restrictions" {
  source          = "../Modules/networkRestrictions"
  global_settings = local.global_settings
  vnet_name       = module.get_shared_vnet_name.value
}

#######################################################################
#---------------------Funcitons related resources---------------------#
#######################################################################

resource "azurerm_subnet" "port_info_functions_subnet" {
  resource_group_name  = local.global_settings.resource_group_name
  name                 = module.subnet_config.port_info_function_subnet_config.name
  address_prefixes     = [module.subnet_config.port_info_function_subnet_config.address_prefix]
  virtual_network_name = module.get_shared_vnet_name.value

  service_endpoints = module.subnet_config.port_info_function_subnet_config.service_endpoints
  delegation {
    name = module.subnet_config.port_info_function_subnet_config.delegation_name
    service_delegation {
      name    = module.subnet_config.port_info_function_subnet_config.service_delegation_name
      actions = module.subnet_config.port_info_function_subnet_config.service_delegation_actions
    }
  }
}

resource "azurerm_storage_account" "port_info_functions_storage_account" {
  name                     = local.port_info_storage_account_config.name
  resource_group_name      = local.global_settings.resource_group_name
  location                 = local.global_settings.location
  account_tier             = local.port_info_storage_account_config.account_tier
  account_replication_type = local.port_info_storage_account_config.account_replication_type
}

resource "azurerm_key_vault_secret" "strg_acc_name" {
  name         = var.keyvault_config.strg_acc_name
  value        = azurerm_storage_account.port_info_functions_storage_account.name
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_key" {
  name         = var.keyvault_config.strg_acc_key
  value        = azurerm_storage_account.port_info_functions_storage_account.primary_access_key
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_uri" {
  name         = var.keyvault_config.strg_acc_uri
  value        = azurerm_storage_account.port_info_functions_storage_account.primary_blob_endpoint
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_service_plan" "port_info_functions_service_plan" {
  name                = local.port_info_function_service_plan_config.name
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location
  os_type             = local.port_info_function_service_plan_config.os_type
  sku_name            = local.port_info_function_service_plan_config.sku_name
  worker_count        = local.port_info_function_service_plan_config.worker_count
}

module "port_info_unece_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.apis_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.port_info_unece_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.apis_service_plan.id
  storage_account_name               = azurerm_storage_account.port_info_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.port_info_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.port_info_unece_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.port_info_unece_func_config.logs_quota_mb
  logs_retention_period_days         = local.port_info_unece_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1",
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "STRG_ACCOUNT_NAME_KV_NAME"              = var.keyvault_config.strg_acc_name
    "STRG_ACCOUNT_KEY_KV_NAME"               = var.keyvault_config.strg_acc_key
    "STRG_ACCOUNT_URI_KV_NAME"               = var.keyvault_config.strg_acc_uri
    "Schedule"                               = "0 0 1 * *"
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
  }

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.port_info_functions_storage_account,
    data.azurerm_service_plan.apis_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs,
  ]
}

module "port_info_auditor_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = local.port_info_function_service_plan_config.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.port_info_auditor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.port_info_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.port_info_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.port_info_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.port_info_auditor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.port_info_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.port_info_auditor_func_config.logs_quota_mb
  logs_retention_period_days         = local.port_info_auditor_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.port_info_functions_storage_account,
    azurerm_service_plan.port_info_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "port_info_auditor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.port_info_function_service_plan_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.port_info_auditor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.port_info_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.port_info_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.port_info_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.port_info_auditor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.port_info_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.port_info_auditor_func_config.logs_quota_mb
  logs_retention_period_days         = local.port_info_auditor_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.port_info_functions_storage_account,
    azurerm_service_plan.port_info_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}
