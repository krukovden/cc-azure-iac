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

module "rmq_config" {
  source = "../Modules/rmqConfig"
}

#######################################################################
#---------------------Funcitons related resources---------------------#
#######################################################################

resource "azurerm_subnet" "disco_functions_subnet" {
  resource_group_name  = local.global_settings.resource_group_name
  name                 = module.subnet_config.disco_function_subnet_config.name
  address_prefixes     = [module.subnet_config.disco_function_subnet_config.address_prefix]
  virtual_network_name = module.get_shared_vnet_name.value

  service_endpoints = module.subnet_config.disco_function_subnet_config.service_endpoints
  delegation {
    name = module.subnet_config.disco_function_subnet_config.delegation_name
    service_delegation {
      name    = module.subnet_config.disco_function_subnet_config.service_delegation_name
      actions = module.subnet_config.disco_function_subnet_config.service_delegation_actions
    }
  }
}

resource "azurerm_storage_account" "disco_functions_storage_account" {
  name                     = local.disco_storage_account_config.name
  resource_group_name      = local.global_settings.resource_group_name
  location                 = local.global_settings.location
  account_tier             = local.disco_storage_account_config.account_tier
  account_replication_type = local.disco_storage_account_config.account_replication_type
}

resource "azurerm_service_plan" "disco_functions_service_plan" {
  name                = local.disco_function_service_plan_config.name
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location
  os_type             = local.disco_function_service_plan_config.os_type
  sku_name            = local.disco_function_service_plan_config.sku_name
  worker_count        = local.disco_function_service_plan_config.worker_count
}

module "disco_error_receiver_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.disco_function_service_plan_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.disco_error_receiver_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.disco_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.disco_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.disco_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.disco_error_receiver_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.disco_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.disco_error_receiver_func_config.logs_quota_mb
  logs_retention_period_days         = local.disco_error_receiver_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
  }

  depends_on = [
    azurerm_storage_account.disco_functions_storage_account,
    azurerm_service_plan.disco_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "get_apim_subnet_id" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.apim_subnet_id_key
  label          = local.appconf_config.label
}

#######################################################################
#-------------------------Rabbit MQ resources-------------------------#
#######################################################################

resource "rabbitmq_exchange" "disco_shovel_exchange" {
  name  = module.rmq_config.disco_rabbitmq_shovel_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.rmq_config.default_exchange_parameters.type
    durable     = module.rmq_config.default_exchange_parameters.durable
    auto_delete = module.rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "disco_error_queue" {
  name  = module.rmq_config.disco_rabbitmq_error_test_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "disco_error_binding" {
  source           = rabbitmq_exchange.disco_shovel_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.disco_error_queue.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.disco_error_queue,
    rabbitmq_exchange.disco_shovel_exchange
  ]
}

data "azurerm_log_analytics_workspace" "lws_func_apps_logs" {
  name                = "lws-cc-cp-func-apps-logs"
  resource_group_name = local.global_settings.resource_group_name
}
