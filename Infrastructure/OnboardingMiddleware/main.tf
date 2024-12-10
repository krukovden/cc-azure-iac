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

provider "rabbitmq" {
  endpoint = "https://${data.env_var.rabbit_url.value}"
  username = data.env_var.rabbit_user.value
  password = data.env_var.rabbit_pass.value
}

data "azurerm_client_config" "current" {}

module "get_shared_kv_id" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.keyvault_id
  label          = local.appconf_config.label
}

data "env_var" "rabbit_connection_string" {
  id       = var.shared_rabbitmq_env_vars.rabbit_connection_string
  required = true # (optional) plan will error if not found
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

data "azurerm_key_vault_secret" "ui_client_id" {
  name         = var.keyvault_values.ui_client_id_name
  key_vault_id = module.get_shared_kv_id.value
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

data "azurerm_service_plan" "shared_service_plan" {
  name                = local.shared_service_plan_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_key_vault" "shared_key_vault" {
  name                = local.shared_key_vault_params.name
  resource_group_name = local.global_settings.data_resource_group_name
}

data "azurerm_key_vault_secret" "signalR_connection_string" {
  name         = local.onboarding_middleware_signalR_service_config.connection_string_secret_name
  key_vault_id = module.get_shared_kv_id.value

  depends_on = [azurerm_key_vault_secret.signalR_connection_string_secret]
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

data "azurerm_linux_function_app" "tenant_adapter_linux_function_app" {
  name                = local.tenant_adapter_func_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_windows_function_app" "tenant_adapter_windows_function_app" {
  name                = local.tenant_adapter_func_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_linux_function_app" "onboarding_middleware_api_linux_function_app" {
  name                = local.onboarding_middleware_api_func_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_windows_function_app" "onboarding_middleware_api_windows_function_app" {
  name                = local.onboarding_middleware_api_func_name
  resource_group_name = local.global_settings.resource_group_name
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

module "onboardingmiddleware_api_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.shared_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.onboardingmiddleware_api_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.shared_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.onboardingmiddleware_api_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                          = data.azurerm_client_config.current.tenant_id #TODO: check if this is needed
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  app_settings = local.onboardingmiddleware_api_func_app_settings
  tags         = local.global_settings.tags

  cors_allowed_origins     = local.onboardingmiddleware_api_func_config.cors_allowed_origins
  cors_support_credentials = local.onboardingmiddleware_api_func_config.cors_support_credentials

  func_ip_restrictions = [ 
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [data.azurerm_key_vault_secret.signalR_connection_string]
}

module "onboardingmiddleware_api_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.shared_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.onboardingmiddleware_api_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.shared_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.onboardingmiddleware_api_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id #TODO: check if this is needed
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  app_settings = local.onboardingmiddleware_api_func_app_settings
  tags         = local.global_settings.tags

  cors_allowed_origins     = local.onboardingmiddleware_api_func_config.cors_allowed_origins
  cors_support_credentials = local.onboardingmiddleware_api_func_config.cors_support_credentials

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction 
  ]

  depends_on = [data.azurerm_key_vault_secret.signalR_connection_string]
}

module "onboardingmiddleware_vessel_processing_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.shared_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.onboarding_middleware_vessel_processing_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.shared_service_plan.id
  storage_account_name               = azurerm_storage_account.onboardingmiddleware_vessel_processing_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.onboardingmiddleware_vessel_processing_storage_account.primary_access_key
  public_network_access_enabled      = local.onboarding_middleware_vessel_processing_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  app_settings = local.onboarding_middleware_vessel_processing_func_app_settings
  tags         = local.global_settings.tags

  cors_allowed_origins     = local.onboardingmiddleware_api_func_config.cors_allowed_origins
  cors_support_credentials = local.onboardingmiddleware_api_func_config.cors_support_credentials

  func_ip_restrictions = [ 
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [ azurerm_storage_account.onboardingmiddleware_vessel_processing_storage_account ]
}

module "onboardingmiddleware_vessel_processing_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.shared_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.onboarding_middleware_vessel_processing_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.shared_service_plan.id
  storage_account_name               = azurerm_storage_account.onboardingmiddleware_vessel_processing_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.onboardingmiddleware_vessel_processing_storage_account.primary_access_key
  public_network_access_enabled      = local.onboarding_middleware_vessel_processing_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  app_settings = local.onboarding_middleware_vessel_processing_func_app_settings
  tags         = local.global_settings.tags

  cors_allowed_origins     = local.onboardingmiddleware_api_func_config.cors_allowed_origins
  cors_support_credentials = local.onboardingmiddleware_api_func_config.cors_support_credentials

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction 
  ]

  depends_on = [data.azurerm_key_vault_secret.signalR_connection_string]
}

module "azurerm_signalr_service" {
  source                        = "../Modules/signalR"
  service_name                  = local.onboarding_middleware_signalR_service_config.name
  location                      = local.global_settings.location
  public_network_access_enabled = true
  sku_name                      = local.onboarding_middleware_signalR_service_config.sku_name
  resource_group_name           = local.global_settings.resource_group_name
  log_analytics_workspace_id    = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id
  connectivity_logs_enabled     = true 
}

resource "azurerm_key_vault_secret" "signalR_connection_string_secret" {
  name         = local.onboarding_middleware_signalR_service_config.connection_string_secret_name
  value        = module.azurerm_signalr_service.signalr-service_primary_connection_string
  key_vault_id = data.azurerm_key_vault.shared_key_vault.id
}

#######################################################################
#-------------------Blob storage related resources--------------------#
#######################################################################

resource "azurerm_storage_account" "onboardingmiddleware_vessel_processing_storage_account" {
  name                          = local.onboarding_middleware_vessel_processing_storage_account_config.name
  resource_group_name           = local.global_settings.resource_group_name
  location                      = local.global_settings.location
  account_tier                  = local.onboarding_middleware_vessel_processing_storage_account_config.account_tier
  account_replication_type      = local.onboarding_middleware_vessel_processing_storage_account_config.account_replication_type
  public_network_access_enabled = true
  
  blob_properties {
    last_access_time_enabled = true
  }
}

resource "azurerm_key_vault_secret" "strg_acc_name" {
  name         = var.keyvault_config.strg_acc_name
  value        = azurerm_storage_account.onboardingmiddleware_vessel_processing_storage_account.name
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_key" {
  name         = var.keyvault_config.strg_acc_key
  value        = azurerm_storage_account.onboardingmiddleware_vessel_processing_storage_account.primary_access_key
  key_vault_id = module.get_shared_kv_id.value
}

resource "azurerm_key_vault_secret" "strg_acc_uri" {
  name         = var.keyvault_config.strg_acc_uri
  value        = azurerm_storage_account.onboardingmiddleware_vessel_processing_storage_account.primary_blob_endpoint
  key_vault_id = module.get_shared_kv_id.value
}

#######################################################################
#--------------------------RMQ exchanges---------------------------#
#######################################################################
resource "rabbitmq_exchange" "onboardingmiddleware_vessel_processing_blob_exchange" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_blob_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.rmq_config.default_exchange_parameters.type
    durable     = module.rmq_config.default_exchange_parameters.durable
    auto_delete = module.rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "onboardingmiddleware_vessel_processing_blob_queue" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_blob_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "onboardingmiddleware_vessel_processing_blob_binding" {
  source           = rabbitmq_exchange.onboardingmiddleware_vessel_processing_blob_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.onboardingmiddleware_vessel_processing_blob_queue.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = "#"

  depends_on = [
    rabbitmq_queue.onboardingmiddleware_vessel_processing_blob_queue,
    rabbitmq_exchange.onboardingmiddleware_vessel_processing_blob_exchange
  ]
}

resource "rabbitmq_exchange" "onboardingmiddleware_vessel_processing_data_exchange" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_data_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.rmq_config.default_exchange_parameters.type
    durable     = module.rmq_config.default_exchange_parameters.durable
    auto_delete = module.rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "onboardingmiddleware_vessel_processing_data_queue" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_data_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "onboardingmiddleware_vessel_processing_data_binding" {
  source           = rabbitmq_exchange.onboardingmiddleware_vessel_processing_data_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.onboardingmiddleware_vessel_processing_data_queue.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = "#"

  depends_on = [
    rabbitmq_queue.onboardingmiddleware_vessel_processing_blob_queue,
    rabbitmq_exchange.onboardingmiddleware_vessel_processing_blob_exchange
  ]
}

resource "rabbitmq_exchange" "onboardingmiddleware_vessel_processing_persist_exchange" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_persist_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.rmq_config.default_exchange_parameters.type
    durable     = module.rmq_config.default_exchange_parameters.durable
    auto_delete = module.rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "onboardingmiddleware_vessel_processing_persist_queue" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_persist_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "onboardingmiddleware_vessel_processing_persist_binding" {
  source           = rabbitmq_exchange.onboardingmiddleware_vessel_processing_persist_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.onboardingmiddleware_vessel_processing_persist_queue.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = "#"

  depends_on = [
    rabbitmq_queue.onboardingmiddleware_vessel_processing_persist_queue,
    rabbitmq_exchange.onboardingmiddleware_vessel_processing_persist_exchange
  ]
}

resource "rabbitmq_exchange" "onboardingmiddleware_vessel_processing_delay_exchange" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_delay_exchange_config.name
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

resource "rabbitmq_binding" "onboardingmiddleware_vessel_processing_persist_retry_binding" {
  source           = module.rmq_config.onboardingmiddleware_vessel_processing_delay_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = module.rmq_config.onboardingmiddleware_vessel_processing_persist_queue_config.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = "#"

  depends_on = [
    rabbitmq_queue.onboardingmiddleware_vessel_processing_persist_queue,
    rabbitmq_exchange.onboardingmiddleware_vessel_processing_delay_exchange
  ]
}

resource "rabbitmq_queue" "onboardingmiddleware_vessel_processing_response_queue" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_response_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "onboardingmiddleware_vessel_processing_response_binding" {
  source           = rabbitmq_exchange.onboardingmiddleware_vessel_processing_persist_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.onboardingmiddleware_vessel_processing_response_queue.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = "#"

  depends_on = [
    rabbitmq_queue.onboardingmiddleware_vessel_processing_response_queue,
    rabbitmq_exchange.onboardingmiddleware_vessel_processing_persist_exchange
  ]
}

resource "rabbitmq_queue" "onboardingmiddleware_vessel_processing_blob_dlq" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_blob_dlq_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "onboardingmiddleware_vessel_processing_parser_dlq" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_parser_dlq_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "onboardingmiddleware_vessel_processing_persist_dlq" {
  name  = module.rmq_config.onboardingmiddleware_vessel_processing_persist_dlq_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "onboardingmiddleware_sync_tenant_request_queue" {
  name  = module.rmq_config.onboardingmiddleware_sync_tenant_request_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

#######################################################################
#--------------------------Vessel Catalog Resources------------------#
#######################################################################

resource "azurerm_storage_account" "vesselCatalogBlobStorageAccount" {
  name                          = local.onboarding_middleware_vessel_catalog_storage_account_blob_config.name
  resource_group_name           = local.global_settings.resource_group_name
  location                      = local.global_settings.location
  account_tier                  = local.onboarding_middleware_vessel_catalog_storage_account_blob_config.account_tier
  account_replication_type      = local.onboarding_middleware_vessel_catalog_storage_account_blob_config.account_replication_type
  public_network_access_enabled = true
  
  blob_properties {
    last_access_time_enabled = true
  }
}

resource "azurerm_storage_container" "vesselCatalogBlobStorageContainer" {
  name                  = local.onboarding_middleware_vessel_catalog_storage_account_blob_config.container_name
  storage_account_name  = azurerm_storage_account.vesselCatalogBlobStorageAccount.name
  container_access_type = local.onboarding_middleware_vessel_catalog_storage_account_blob_config.container_access_type
}

resource "azurerm_storage_blob" "industryCatalog" {
  name                   = "industry/industry-catalog-v1.json"
  storage_account_name   = azurerm_storage_account.vesselCatalogBlobStorageAccount.name
  storage_container_name = azurerm_storage_container.vesselCatalogBlobStorageContainer.name
  type                   = "Block"
  source                 = "./Resources/industry-catalog-v1.json"
}

resource "azurerm_eventgrid_event_subscription" "vesselCatalogBlobAddedSubscription" {
  name  = local.onboarding_middleware_vessel_catalog_storage_account_blob_config.blob_added_event_name
  scope = azurerm_storage_account.vesselCatalogBlobStorageAccount.id

  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.vesselCatalogBlobStorageAccount.id
    queue_name         = azurerm_storage_queue.vesselCatalogBlobAddedQueue.name
  }

  included_event_types  = ["Microsoft.Storage.BlobCreated"]
  event_delivery_schema = "CloudEventSchemaV1_0"
  depends_on = [
    azurerm_storage_queue.vesselCatalogBlobAddedQueue,
    azurerm_storage_account.vesselCatalogBlobStorageAccount
  ]
}

resource "azurerm_storage_blob" "organizationCatalog" {
  name                   = "organization/organization-catalog-v1.json"
  storage_account_name   = azurerm_storage_account.vesselCatalogBlobStorageAccount.name
  storage_container_name = azurerm_storage_container.vesselCatalogBlobStorageContainer.name
  type                   = "Block"
  source                 = "./Resources/organization-catalog-v1.json"
}

resource "azurerm_storage_queue" "vesselCatalogBlobAddedQueue" {
  name                 = local.onboarding_middleware_vessel_catalog_storage_account_blob_config.blob_added_queue_name
  storage_account_name = azurerm_storage_account.vesselCatalogBlobStorageAccount.name
  depends_on           = [azurerm_storage_account.vesselCatalogBlobStorageAccount]
}

module "onboardingmiddleware_vessel_catalog_processor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.shared_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.onboarding_middleware_vessel_catalog_processing_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.shared_service_plan.id
  storage_account_name               = azurerm_storage_account.vesselCatalogBlobStorageAccount.name
  storage_account_primary_access_key = azurerm_storage_account.vesselCatalogBlobStorageAccount.primary_access_key
  public_network_access_enabled      = local.onboarding_middleware_vessel_catalog_processing_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"               = "1"
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
    "STORAGE_CONNECTION_STRING"              = azurerm_storage_account.vesselCatalogBlobStorageAccount.primary_connection_string
    "DELAY_EXCHANGE_NAME"                    = module.rmq_config.onboardingmiddleware_vessel_catalog_processing_update_delay_exchange_config.name
    "ONBOARDING_MIDDLEWARE_BASE_URL"         = format("https://%s/api/", try(data.azurerm_linux_function_app.onboarding_middleware_api_linux_function_app.default_hostname, data.azurerm_windows_function_app.onboarding_middleware_api_windows_function_app.default_hostname))
  }
  tags         = local.global_settings.tags

  func_ip_restrictions = [ 
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [ 
    azurerm_storage_account.vesselCatalogBlobStorageAccount
  ]
}

resource "rabbitmq_exchange" "onboardingmiddleware_vessel_catalog_processing_update_exchange" {
  name  = module.rmq_config.onboardingmiddleware_vessel_catalog_processing_update_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.rmq_config.default_exchange_parameters.type
    durable     = module.rmq_config.default_exchange_parameters.durable
    auto_delete = module.rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "onboardingmiddleware_vessel_catalog_processing_update_queue" {
  name  = module.rmq_config.onboardingmiddleware_vessel_catalog_processing_update_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "onboardingmiddleware_vessel_catalog_processing_update_binding" {
  source           = module.rmq_config.onboardingmiddleware_vessel_catalog_processing_update_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = module.rmq_config.onboardingmiddleware_vessel_catalog_processing_update_queue_config.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = "#"

  depends_on = [
    rabbitmq_queue.onboardingmiddleware_vessel_catalog_processing_update_queue,
    rabbitmq_exchange.onboardingmiddleware_vessel_catalog_processing_update_exchange
  ]
}

resource "rabbitmq_exchange" "onboardingmiddleware_vessel_catalog_processing_update_delay_exchange" {
  name  = module.rmq_config.onboardingmiddleware_vessel_catalog_processing_update_delay_exchange_config.name
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

resource "rabbitmq_binding" "onboardingmiddleware_vessel_catalog_processing_update_retry_binding" {
  source           = module.rmq_config.onboardingmiddleware_vessel_catalog_processing_update_delay_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = module.rmq_config.onboardingmiddleware_vessel_catalog_processing_update_queue_config.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = "#"

  depends_on = [
    rabbitmq_queue.onboardingmiddleware_vessel_catalog_processing_update_queue,
    rabbitmq_exchange.onboardingmiddleware_vessel_catalog_processing_update_delay_exchange
  ]
}


#######################################################################
#--------------------------End----------------------------------------#
#######################################################################
