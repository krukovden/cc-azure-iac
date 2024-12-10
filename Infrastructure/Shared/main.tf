terraform {
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
  backend "azurerm" {}
}

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

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

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

resource "azurerm_resource_group" "default" {
  name     = local.global_settings.resource_group_name
  location = local.global_settings.location
}

resource "azurerm_resource_group" "retention" {
  name     = local.global_settings.retention_resource_group_name
  location = local.global_settings.location
}

resource "azurerm_resource_group" "data" {
  name     = local.global_settings.data_resource_group_name
  location = local.global_settings.location
}

resource "azurerm_app_configuration" "app_config" {
  name                  = local.appconf_config.name
  resource_group_name   = azurerm_resource_group.default.name
  location              = local.global_settings.location
  public_network_access = local.appconf_config.public_network_access
  local_auth_enabled    = true

  depends_on = [azurerm_resource_group.default]
}

#######################################################################
#---------------------Funcitons related resources---------------------#
#######################################################################

resource "azurerm_storage_account" "voyage_plan_functions_storage_account" {
  name                     = local.shared_func_storage_account_config.name
  resource_group_name      = azurerm_resource_group.default.name
  location                 = local.global_settings.location
  account_tier             = local.shared_func_storage_account_config.account_tier
  account_replication_type = local.shared_func_storage_account_config.account_replication_type
  tags                     = local.global_settings.tags

  depends_on = [azurerm_resource_group.default]
}

resource "azurerm_service_plan" "shared_service_plan" {
  name                = local.shared_service_plan_config.name
  resource_group_name = azurerm_resource_group.default.name
  location            = local.global_settings.location
  os_type             = local.shared_service_plan_config.os_type
  sku_name            = local.shared_service_plan_config.sku_name
  worker_count        = local.shared_service_plan_config.worker_count
  tags                = local.global_settings.tags

  depends_on = [azurerm_resource_group.default]
}

resource "azurerm_service_plan" "apis_service_plan" {
  name                = local.apis_service_plan_config.name
  resource_group_name = azurerm_resource_group.default.name
  location            = local.global_settings.location
  os_type             = local.apis_service_plan_config.os_type
  sku_name            = local.apis_service_plan_config.sku_name
  worker_count        = local.apis_service_plan_config.worker_count
  tags                = local.global_settings.tags

  depends_on = [azurerm_resource_group.default]
}

resource "azurerm_log_analytics_workspace" "func_apps_logs_ws" {
  name                = "lws-cc-cp-func-apps-logs"
  location            = local.global_settings.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  depends_on = [azurerm_resource_group.default]
}

#######################################################################
#-----Save shared recources information for using in other scripts----#
#######################################################################

module "save_postgresql_ip" {
  source         = "../../SharedModules/appConfigKey"
  appconfig_name = local.appconf_config.name
  rg_name        = azurerm_resource_group.default.name
  key            = local.appconf_config.postgres_ip_key
  label          = local.appconf_config.label
  value          = azurerm_private_endpoint.postgresql_private_endpoint.private_service_connection[0].private_ip_address

  depends_on = [
    azurerm_private_endpoint.postgresql_private_endpoint,
    azurerm_resource_group.default,
    azurerm_app_configuration.app_config
  ]
}

module "save_shared_kv_id" {
  source         = "../../SharedModules/appConfigKey"
  appconfig_name = local.appconf_config.name
  rg_name        = azurerm_resource_group.default.name
  key            = local.appconf_config.keyvault_id
  label          = local.appconf_config.label
  value          = azurerm_key_vault.shared_key_vault.id

  depends_on = [
    azurerm_key_vault.shared_key_vault,
    azurerm_resource_group.default,
    azurerm_app_configuration.app_config
  ]
}

module "save_shared_kv_name" {
  source         = "../../SharedModules/appConfigKey"
  appconfig_name = local.appconf_config.name
  rg_name        = azurerm_resource_group.default.name
  key            = local.appconf_config.keyvault_name
  label          = local.appconf_config.label
  value          = azurerm_key_vault.shared_key_vault.name

  depends_on = [
    azurerm_key_vault.shared_key_vault,
    azurerm_resource_group.default,
    azurerm_app_configuration.app_config
  ]
}

module "save_shared_nsg_name" {
  source         = "../../SharedModules/appConfigKey"
  appconfig_name = local.appconf_config.name
  rg_name        = azurerm_resource_group.default.name
  key            = local.appconf_config.nsg_name
  label          = local.appconf_config.label
  value          = azurerm_network_security_group.shared_nsg.name

  depends_on = [
    azurerm_network_security_group.shared_nsg,
    azurerm_resource_group.default,
    azurerm_app_configuration.app_config
  ]
}

module "save_vnet_name" {
  source         = "../../SharedModules/appConfigKey"
  appconfig_name = local.appconf_config.name
  rg_name        = azurerm_resource_group.default.name
  key            = local.appconf_config.vnet_name
  label          = local.appconf_config.label
  value          = local.vnet_config.name

  depends_on = [
    azurerm_resource_group.default,
    azurerm_app_configuration.app_config
  ]
}

#######################################################################
#-------------------Blob storage related resources--------------------#
#######################################################################

resource "azurerm_storage_account" "publicStorageAccount" {
  name                          = local.public_storage_account_config.name
  resource_group_name           = local.global_settings.resource_group_name
  location                      = local.global_settings.location
  account_tier                  = local.public_storage_account_config.account_tier
  account_replication_type      = local.public_storage_account_config.account_replication_type
  public_network_access_enabled = true

  depends_on = [azurerm_resource_group.default]
}

resource "azurerm_storage_container" "contractsDataContainer" {
  name                  = var.contracts_container_config.name
  storage_account_name  = azurerm_storage_account.publicStorageAccount.name
  container_access_type = var.contracts_container_config.container_access_type
}