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

data "env_var" "rabbit_url" {
  id       = var.env_vars_names.rabbit_url
  required = true # (optional) plan will error if not found
}

data "env_var" "rabbit_connection_string" {
  id       = var.env_vars_names.rabbit_connection_string
  required = true # (optional) plan will error if not found
}

data "env_var" "rabbit_pass" {
  id       = var.env_vars_names.rabbit_pass
  required = true # (optional) plan will error if not found

}
data "env_var" "rabbit_user" {
  id       = var.env_vars_names.rabbit_user
  required = true # (optional) plan will error if not found
}

data "env_var" "rabbit_vhost" {
  id       = var.env_vars_names.rabbit_vhost
  required = true # (optional) plan will error if not found
}

data "env_var" "rabbit_port" {
  id       = var.env_vars_names.rabbit_port
  required = true # (optional) plan will error if not found
}

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

data "azurerm_service_plan" "apis_service_plan" {
  name                = local.apis_service_plan_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_key_vault" "shared_key_vault" {
  name                = local.shared_key_vault_params.name
  resource_group_name = local.global_settings.data_resource_group_name
}

data "azurerm_log_analytics_workspace" "func_apps_logs_ws" {
  name                = "lws-cc-cp-func-apps-logs"
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_storage_account" "shared_functions_storage_account" {
  name                = local.shared_func_storage_account_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_private_endpoint_connection" "postgresql_private_connection" {
  name                = local.postgresql_private_endpoint_name
  resource_group_name = local.global_settings.data_resource_group_name
}

provider "rabbitmq" {
  endpoint = "https://${data.env_var.rabbit_url.value}"
  username = data.env_var.rabbit_user.value
  password = data.env_var.rabbit_pass.value
}

module "subnet_config" {
  source      = "../Modules/subnetConfigs"
  environment = local.global_settings.tags.Environment
}

module "rmq_config" {
  source = "../Modules/rmqConfig"
}

module "network_restrictions" {
  source          = "../Modules/networkRestrictions"
  global_settings = local.global_settings
  vnet_name       = local.vnet_name
}

module "tenant_api_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.apis_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.tenant_api_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.apis_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.tenant_api_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  app_settings = local.tenant_api_func_app_settings
  tags         = local.global_settings.tags

  cors_allowed_origins     = local.tenant_api_func_config.cors_allowed_origins
  cors_support_credentials = local.tenant_api_func_config.cors_support_credentials

  func_ip_restrictions = [ 
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction
  ]
}

module "tenant_api_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.apis_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.tenant_api_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.apis_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.tenant_api_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  app_settings = local.tenant_api_func_app_settings
  tags         = local.global_settings.tags

  cors_allowed_origins     = local.tenant_api_func_config.cors_allowed_origins
  cors_support_credentials = local.tenant_api_func_config.cors_support_credentials

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction 
  ]
}

resource "rabbitmq_exchange" "tenant_data_exchange" {
  name  = module.rmq_config.ta_rabbitmq_tenent_data_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.rmq_config.default_header_exchange_parameters.type
    durable     = module.rmq_config.default_header_exchange_parameters.durable
    auto_delete = module.rmq_config.default_header_exchange_parameters.auto_delete
    arguments = {
      x-delayed-type = module.rmq_config.default_header_exchange_parameters.x-delayed-type
    }
  }
}

resource "rabbitmq_exchange" "tenant_port_exchange" {
  name  = module.rmq_config.ta_rabbitmq_tenant_port_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.rmq_config.default_delay_exchange_parameters.type
    durable     = module.rmq_config.default_delay_exchange_parameters.durable
    auto_delete = module.rmq_config.default_delay_exchange_parameters.auto_delete
    arguments = {
      x-delayed-type = module.rmq_config.default_delay_exchange_parameters.x-delayed-type
    }
  }
}
