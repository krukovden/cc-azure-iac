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

data "env_var" "rabbit_connection_string" {
  id       = var.env_vars_names.rabbit_connection_string
  required = true # (optional) plan will error if not found
}

data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = local.global_settings.resource_group_name
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

data "azurerm_service_plan" "apis_service_plan" {
  name                = local.apis_service_plan_name
  resource_group_name = local.global_settings.resource_group_name
}

resource "azurerm_key_vault_secret" "strg_acc_key" {
  name         = local.shared_key_vault_params.secrets.strg_acc_key
  value        = azurerm_storage_account.voyage_plan_retention_storage_account.primary_access_key
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_name" {
  name         = local.shared_key_vault_params.secrets.strg_acc_name
  value        = azurerm_storage_account.voyage_plan_retention_storage_account.name
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_uri" {
  name         = local.shared_key_vault_params.secrets.strg_acc_uri
  value        = azurerm_storage_account.voyage_plan_retention_storage_account.primary_blob_endpoint
  key_vault_id = module.get_shared_kv_id.value
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

module "get_shared_kv_id" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.keyvault_id
  label          = local.appconf_config.label
}

module "voyage_plan_api_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.apis_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.voyage_plan_api_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.apis_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.voyage_plan_api_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"               = "1"
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
  }
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  tags = local.global_settings.tags

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [data.azurerm_service_plan.apis_service_plan]
}

module "voyage_plan_api_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.apis_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.voyage_plan_api_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.apis_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.voyage_plan_api_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"               = "1"
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
  }
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  tags = local.global_settings.tags

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [data.azurerm_service_plan.apis_service_plan]
}

module "voyage_plan_writer_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.shared_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.voyage_plan_normalized_writer_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.shared_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.voyage_plan_normalized_writer_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = {
    "KEY_VAULT_NAME"                       = data.azurerm_key_vault.shared_key_vault.name
    "RABBIT_MQ_CONNECTION_STRING"          = data.env_var.rabbit_connection_string.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME" = local.shared_key_vault_params.secrets.db_connection_string_name
    "DELAY_EXCHANGE_NAME"                  = module.rmq_config.shared_rabbitmq_voyage_plan_delay_exchange_config.name
    "DLQ_NAME"                             = module.rmq_config.shared_rabbitmq_veson_voyage_plan_dlq_config.name
  }
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  tags = local.global_settings.tags

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]
}

module "voyage_plan_writer_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.shared_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.voyage_plan_normalized_writer_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.shared_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.voyage_plan_normalized_writer_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = {
    "KEY_VAULT_NAME"                       = data.azurerm_key_vault.shared_key_vault.name
    "RABBIT_MQ_CONNECTION_STRING"          = data.env_var.rabbit_connection_string.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME" = local.shared_key_vault_params.secrets.db_connection_string_name
    "DELAY_EXCHANGE_NAME"                  = module.rmq_config.shared_rabbitmq_voyage_plan_delay_exchange_config.name
    "DLQ_NAME"                             = module.rmq_config.shared_rabbitmq_veson_voyage_plan_dlq_config.name
  }
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  tags = local.global_settings.tags

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]
}

module "voyage_plan_retention_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.shared_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.voyage_plan_retention_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.shared_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.voyage_plan_retention_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = merge(local.voyage_plan_retention_func_config.app_settings, {
    "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
    "RETENTION_STRG_NAME_KV_NAME"            = local.shared_key_vault_params.secrets.strg_acc_name
    "RETENTION_STRG_KEY_KV_NAME"             = local.shared_key_vault_params.secrets.strg_acc_key
    "RETENTION_STRG_URI_KV_NAME"             = local.shared_key_vault_params.secrets.strg_acc_uri
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
  })
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  tags = local.global_settings.tags

  cors_allowed_origins     = local.voyage_plan_retention_func_config.cors_allowed_origins
  cors_support_credentials = local.voyage_plan_retention_func_config.cors_support_credentials

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]
}

resource "azurerm_storage_account" "voyage_plan_retention_storage_account" {
  name                     = local.retention_storage_account_config.name
  resource_group_name      = local.global_settings.retention_resource_group_name
  location                 = local.global_settings.location
  account_tier             = local.retention_storage_account_config.account_tier
  account_replication_type = local.retention_storage_account_config.account_replication_type
  access_tier              = local.retention_storage_account_config.access_tier
  tags                     = local.global_settings.tags
}

resource "azurerm_storage_management_policy" "voyagePlanRetentionBlobStorageAccountManagementPolicy" {
  storage_account_id = azurerm_storage_account.voyage_plan_retention_storage_account.id
  rule {
    name    = "VoyagePlanRetentionBlobLifecycle"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_archive_after_days_since_creation_greater_than = 1
      }
    }
  }
  depends_on = [azurerm_storage_account.voyage_plan_retention_storage_account]
}
