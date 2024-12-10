module "veson_register_tenant_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.veson_register_tenant_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_register_tenant_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_register_tenant_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_register_tenant_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "VESON_COMPANY_API_URI"                  = local.veson_register_tenant_func_config.veson_company_api_url
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "VESON_INTENT_PARAMETER"                 = "PublishVoyageUpdate"
    "VESON_ROOT_API_URL"                     = "https://emea.veslink.com/api/messages"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_register_tenant_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_register_tenant_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_register_tenant_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_register_tenant_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_register_tenant_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "VESON_COMPANY_API_URI"                  = local.veson_register_tenant_func_config.veson_company_api_url
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "VESON_INTENT_PARAMETER"                 = "PublishVoyageUpdate"
    "VESON_ROOT_API_URL"                     = "https://emea.veslink.com/api/messages"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_voyage_plan_puller_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.veson_puller_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_puller_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_puller_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_puller_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "VESON_ROOT_API_URL"                     = local.veson_puller_func_config.veson_root_api_url
    "VESON_TOKEN"                            = local.veson_puller_func_config.veson_token
    "VESON_INTENT_PARAMETER"                 = local.veson_puller_func_config.veson_intent_parameter
    "VESON_FROM_PARAMETER"                   = local.veson_puller_func_config.veson_intent_from
    "VESON_TO_PARAMETER"                     = local.veson_puller_func_config.veson_intent_to
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "RMQ_PORT_KV_NAME"                       = var.keyvault_config.rmq_port_name
    "BLOB_CONNECTION_STRING_KV_NAME"         = var.keyvault_config.blob_conneciton_string_name
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "RAW_VOYAGE_PLAN_EXCHANGE_NAME"          = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_exchange_config.name
    "RETRY_COUNT"                            = 1
    "POST_COUNT"                             = local.veson_puller_func_config.post_count
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "VESON_REPUBLISH_FUNC_URL"               = "https://${local.veson_raw_republisher_func_config.name}.azurewebsites.net/api/RepublishRawVoyagePlans"
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_voyage_plan_puller_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_puller_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_puller_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_puller_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_puller_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "VESON_ROOT_API_URL"                     = local.veson_puller_func_config.veson_root_api_url
    "VESON_TOKEN"                            = local.veson_puller_func_config.veson_token
    "VESON_INTENT_PARAMETER"                 = local.veson_puller_func_config.veson_intent_parameter
    "VESON_FROM_PARAMETER"                   = local.veson_puller_func_config.veson_intent_from
    "VESON_TO_PARAMETER"                     = local.veson_puller_func_config.veson_intent_to
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "RMQ_PORT_KV_NAME"                       = var.keyvault_config.rmq_port_name
    "BLOB_CONNECTION_STRING_KV_NAME"         = var.keyvault_config.blob_conneciton_string_name
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "RAW_VOYAGE_PLAN_EXCHANGE_NAME"          = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_exchange_config.name
    "RETRY_COUNT"                            = 1
    "POST_COUNT"                             = local.veson_puller_func_config.post_count
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "VESON_REPUBLISH_FUNC_URL"               = "https://${local.veson_raw_republisher_func_config.name}.azurewebsites.net/api/RepublishRawVoyagePlans"
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_voyage_plan_normalizer_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.veson_normalize_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_normalize_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_normalize_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_normalize_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "RMQ_PORT_KV_NAME"                       = var.keyvault_config.rmq_port_name
    "BLOB_CONNECTION_STRING_KV_NAME"         = var.keyvault_config.blob_conneciton_string_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "VOYAGE_PLAN_EXCHANGE_NAME"              = module.veson_rmq_config.shared_rabbitmq_norm_voyage_plan_exchange_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "PORT_API_URL"                           = "https://${local.veson_port_info_func_config.name}.azurewebsites.net/"
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_voyage_plan_normalizer_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_normalize_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_normalize_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_normalize_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_normalize_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "RMQ_PORT_KV_NAME"                       = var.keyvault_config.rmq_port_name
    "BLOB_CONNECTION_STRING_KV_NAME"         = var.keyvault_config.blob_conneciton_string_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "VOYAGE_PLAN_EXCHANGE_NAME"              = module.veson_rmq_config.shared_rabbitmq_norm_voyage_plan_exchange_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "PORT_API_URL"                           = "https://${local.veson_port_info_func_config.name}.azurewebsites.net/"
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "raw_voyage_plan_writer_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.veson_raw_writer_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_raw_writer_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_raw_writer_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_raw_writer_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "BLOB_CONNECTION_STRING_KV_NAME"         = var.keyvault_config.blob_conneciton_string_name
    "STRG_ACCOUNT_NAME_KV_NAME"              = var.keyvault_config.strg_acc_name
    "STRG_ACCOUNT_KEY_KV_NAME"               = var.keyvault_config.strg_acc_key
    "STRG_ACCOUNT_URI_KV_NAME"               = var.keyvault_config.strg_acc_uri
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "DELAY_EXCHANGE_NAME"                    = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_delay_exchange_config.name
    "DLQ_NAME"                               = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_dlq_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "raw_voyage_plan_writer_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_raw_writer_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_raw_writer_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_raw_writer_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_raw_writer_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "BLOB_CONNECTION_STRING_KV_NAME"         = var.keyvault_config.blob_conneciton_string_name
    "STRG_ACCOUNT_NAME_KV_NAME"              = var.keyvault_config.strg_acc_name
    "STRG_ACCOUNT_KEY_KV_NAME"               = var.keyvault_config.strg_acc_key
    "STRG_ACCOUNT_URI_KV_NAME"               = var.keyvault_config.strg_acc_uri
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "DELAY_EXCHANGE_NAME"                    = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_delay_exchange_config.name
    "DLQ_NAME"                               = module.veson_rmq_config.shared_rabbitmq_veson_voyage_plan_dlq_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_schedule_trigger_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.veson_schedule_trigger_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_schedule_trigger_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_schedule_trigger_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_schedule_trigger_func_config.logs_retention_period_days

  app_settings = {
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "PULLER_EXCHANGE_NAME"                   = module.veson_rmq_config.veson_rabbitmq_voyage_plan_pull_request_exchange_config.name
  }

  identity_type           = local.appconf_config.identity_type
  key_vault_id            = module.get_shared_kv_id.value
  tenant_id               = data.azurerm_client_config.current.tenant_id
  certificate_permissions = var.funcitons_kv_permissions.certificate_permissions
  key_permissions         = var.funcitons_kv_permissions.key_permissions
  secret_permissions      = var.funcitons_kv_permissions.secret_permissions

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan
  ]
}

module "veson_schedule_trigger_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_schedule_trigger_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_schedule_trigger_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_schedule_trigger_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_schedule_trigger_func_config.logs_retention_period_days

  app_settings = {
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "PULLER_EXCHANGE_NAME"                   = module.veson_rmq_config.veson_rabbitmq_voyage_plan_pull_request_exchange_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "TENANT_CHUNK_SIZE"                      = "500"
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "raw_voyage_plan_republisher_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_raw_republisher_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_raw_republisher_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_raw_republisher_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_raw_republisher_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "BLOB_CONNECTION_STRING_KV_NAME"         = var.keyvault_config.blob_conneciton_string_name
    "STRG_ACCOUNT_NAME_KV_NAME"              = var.keyvault_config.strg_acc_name
    "STRG_ACCOUNT_KEY_KV_NAME"               = var.keyvault_config.strg_acc_key
    "STRG_ACCOUNT_URI_KV_NAME"               = var.keyvault_config.strg_acc_uri
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_port_schedule_trigger_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_port_schedule_trigger_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_port_schedule_trigger_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_port_schedule_trigger_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_port_schedule_trigger_func_config.logs_retention_period_days

  app_settings = {
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "PULLER_EXCHANGE_NAME"                   = module.veson_rmq_config.veson_rabbitmq_port_pull_request_exchange_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "TENANT_CHUNK_SIZE"                      = "500"
    "TriggerSchedule"                        = "0 0 12 1/3 * *"
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_port_puller_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_port_puller_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_port_puller_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_port_puller_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_port_puller_func_config.logs_retention_period_days

  app_settings = {
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "PORT_EXCHANGE_NAME"                     = module.veson_rmq_config.veson_rabbitmq_port_parse_exchange_config.name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "RETRY_COUNT"                            = 1
    "VESON_PORT_API_URL"                     = "https://api.veslink.com/v1/ports/"
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_port_writer_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_port_writer_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_port_writer_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_port_writer_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_port_writer_func_config.logs_retention_period_days

  app_settings = {
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "DELAY_EXCHANGE_NAME"                    = module.veson_rmq_config.veson_rabbitmq_port_parse_delay_exchange_config.name
    "DLQ_NAME"                               = module.veson_rmq_config.veson_rabbitmq_port_dlq_queue_config.name
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "veson_port_info_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.apis_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_port_info_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.apis_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_port_info_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_port_info_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_port_info_func_config.logs_retention_period_days
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
  }

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction,
    {
      virtual_network_subnet_id = azurerm_subnet.veson_functions_subnet.id
      action                    = "Allow"
      priority                  = module.network_restrictions.veson_func_subnet_priority
      name                      = "veson-func-subnet"
    }
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    data.azurerm_service_plan.apis_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs,
    azurerm_subnet.veson_functions_subnet
  ]
}

module "veson_auditor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = azurerm_service_plan.veson_functions_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.veson_auditor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.veson_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.veson_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.veson_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.veson_auditor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.veson_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.veson_auditor_func_config.logs_quota_mb
  logs_retention_period_days         = local.veson_auditor_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction,
    {
      virtual_network_subnet_id = azurerm_subnet.veson_functions_subnet.id
      action                    = "Allow"
      priority                  = module.network_restrictions.veson_func_subnet_priority
      name                      = "veson-func-subnet"
    }
  ]

  depends_on = [
    azurerm_storage_account.veson_functions_storage_account,
    azurerm_service_plan.veson_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs,
    azurerm_subnet.veson_functions_subnet
  ]
}
