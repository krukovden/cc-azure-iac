module "waypoints_adapter_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.ecdis_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.waypoints_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.ecdis_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.waypoints_adapter_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = merge(local.waypoints_adapter_func_config.app_settings, {
    "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
  })
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  tags = local.global_settings.tags

  cors_allowed_origins     = local.waypoints_adapter_func_config.cors_allowed_origins
  cors_support_credentials = local.waypoints_adapter_func_config.cors_support_credentials

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [data.azurerm_service_plan.ecdis_service_plan]
}

module "waypoints_adapter_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.ecdis_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.waypoints_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.ecdis_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.waypoints_adapter_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = merge(local.waypoints_adapter_func_config.app_settings, {
    "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
  })
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.func_apps_logs_ws.id

  tags = local.global_settings.tags

  cors_allowed_origins     = local.waypoints_adapter_func_config.cors_allowed_origins
  cors_support_credentials = local.waypoints_adapter_func_config.cors_support_credentials

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [data.azurerm_service_plan.ecdis_service_plan]
}

module "waypoints_api_adapter_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.apis_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.waypoints_api_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.apis_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.waypoints_api_adapter_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = merge(local.waypoints_api_adapter_func_config.app_settings, {
    "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
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

  cors_allowed_origins     = local.waypoints_api_adapter_func_config.cors_allowed_origins
  cors_support_credentials = local.waypoints_api_adapter_func_config.cors_support_credentials

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [data.azurerm_service_plan.apis_service_plan]
}

module "waypoints_api_adapter_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.shared_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.waypoints_api_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.shared_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.waypoints_api_adapter_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = merge(local.waypoints_api_adapter_func_config.app_settings, {
    "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
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

  cors_allowed_origins     = local.waypoints_api_adapter_func_config.cors_allowed_origins
  cors_support_credentials = local.waypoints_api_adapter_func_config.cors_support_credentials

  func_ip_restrictions = [
    module.network_restrictions.apim_subnet_restriction,
    module.network_restrictions.func_shared_subnet_restriction
  ]
}

module "waypoints_retention_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.ecdis_service_plan.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.waypoints_retention_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.ecdis_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.waypoints_retention_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = merge(local.waypoints_retention_func_config.app_settings, {
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

  cors_allowed_origins     = local.waypoints_retention_func_config.cors_allowed_origins
  cors_support_credentials = local.waypoints_retention_func_config.cors_support_credentials

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.waypoints_retention_storage_account,
    data.azurerm_service_plan.ecdis_service_plan
  ]
}

module "waypoints_retention_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = data.azurerm_service_plan.ecdis_service_plan.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.waypoints_retention_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = data.azurerm_service_plan.ecdis_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.waypoints_retention_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = merge(local.waypoints_retention_func_config.app_settings, {
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

  cors_allowed_origins     = local.waypoints_retention_func_config.cors_allowed_origins
  cors_support_credentials = local.waypoints_retention_func_config.cors_support_credentials

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.waypoints_retention_storage_account,
    data.azurerm_service_plan.ecdis_service_plan
  ]
}
