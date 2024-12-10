module "ecdis_upload_rmq_adapter_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.ecdis_upload_rmq_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.ecdis_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_upload_rmq_adapter_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.ecdis_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.ecdis_upload_rmq_adapter_func_config.logs_quota_mb
  logs_retention_period_days         = local.ecdis_upload_rmq_adapter_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  tags = local.global_settings.tags
  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "STORAGE_QUEUE_CONNECTION_STRING"        = azurerm_storage_account.ecdisTempBlobStorageAccount.primary_connection_string
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
    "PARTNER_NAME"                           = local.global_settings.partner_name
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
  }

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.ecdis_functions_storage_account,
    azurerm_service_plan.ecdis_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "ecdis_upload_rmq_adapter_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.ecdis_upload_rmq_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.ecdis_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_upload_rmq_adapter_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.ecdis_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.ecdis_upload_rmq_adapter_func_config.logs_quota_mb
  logs_retention_period_days         = local.ecdis_upload_rmq_adapter_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  tags = local.global_settings.tags
  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "STORAGE_QUEUE_CONNECTION_STRING"        = azurerm_storage_account.ecdisTempBlobStorageAccount.primary_connection_string
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
    "PARTNER_NAME"                           = local.global_settings.partner_name
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
  }

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.ecdis_functions_storage_account,
    azurerm_service_plan.ecdis_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "ecdis_persist_raw_adapter_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.ecdis_persist_raw_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.ecdis_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_persist_raw_adapter_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.ecdis_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.ecdis_persist_raw_adapter_func_config.logs_quota_mb
  logs_retention_period_days         = local.ecdis_persist_raw_adapter_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  tags = local.global_settings.tags
  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
    "PARTNER_NAME"                           = local.global_settings.partner_name
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "TEMP_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.temp_blob_conneciton_string_name
    "TEMP_STRG_NAME_KV_NAME"                 = var.keyvault_config.temp_blob_account_name
    "TEMP_STRG_KEY_KV_NAME"                  = var.keyvault_config.temp_blob_account_key
    "TEMP_STRG_URI_KV_NAME"                  = var.keyvault_config.temp_blob_account_url
    "PERM_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.permanent_blob_conneciton_string_name
    "PERM_STRG_NAME_KV_NAME"                 = var.keyvault_config.permanent_blob_account_name
    "PERM_STRG_KEY_KV_NAME"                  = var.keyvault_config.permanent_blob_account_key
    "PERM_STRG_URI_KV_NAME"                  = var.keyvault_config.permanent_blob_account_url
  }

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.ecdis_functions_storage_account,
    azurerm_service_plan.ecdis_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "ecdis_persist_raw_adapter_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.ecdis_persist_raw_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.ecdis_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_persist_raw_adapter_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.ecdis_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.ecdis_persist_raw_adapter_func_config.logs_quota_mb
  logs_retention_period_days         = local.ecdis_persist_raw_adapter_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  tags = local.global_settings.tags
  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
    "PARTNER_NAME"                           = local.global_settings.partner_name
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "TEMP_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.temp_blob_conneciton_string_name
    "TEMP_STRG_NAME_KV_NAME"                 = var.keyvault_config.temp_blob_account_name
    "TEMP_STRG_KEY_KV_NAME"                  = var.keyvault_config.temp_blob_account_key
    "TEMP_STRG_URI_KV_NAME"                  = var.keyvault_config.temp_blob_account_url
    "PERM_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.permanent_blob_conneciton_string_name
    "PERM_STRG_NAME_KV_NAME"                 = var.keyvault_config.permanent_blob_account_name
    "PERM_STRG_KEY_KV_NAME"                  = var.keyvault_config.permanent_blob_account_key
    "PERM_STRG_URI_KV_NAME"                  = var.keyvault_config.permanent_blob_account_url
  }

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.ecdis_functions_storage_account,
    azurerm_service_plan.ecdis_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "ecdis_ingest_adapter_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.ecdis_ingest_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.ecdis_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_ingest_adapter_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.ecdis_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.ecdis_ingest_adapter_func_config.logs_quota_mb
  logs_retention_period_days         = local.ecdis_ingest_adapter_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  tags = local.global_settings.tags
  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
    "PARTNER_NAME"                           = local.global_settings.partner_name
    "RTZ_SCHEMA_V1_0"                        = azurerm_storage_blob.ecdisRtz10SchemaBlob.url
    "RTZ_SCHEMA_V1_2"                        = azurerm_storage_blob.ecdisRtz12SchemaBlob.url
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "PERM_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.permanent_blob_conneciton_string_name
    "PERM_STRG_NAME_KV_NAME"                 = var.keyvault_config.permanent_blob_account_name
    "PERM_STRG_KEY_KV_NAME"                  = var.keyvault_config.permanent_blob_account_key
    "PERM_STRG_URI_KV_NAME"                  = var.keyvault_config.permanent_blob_account_url
  }

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.ecdis_functions_storage_account,
    azurerm_service_plan.ecdis_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "ecdis_ingest_adapter_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.ecdis_ingest_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.ecdis_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_ingest_adapter_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.ecdis_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.ecdis_ingest_adapter_func_config.logs_quota_mb
  logs_retention_period_days         = local.ecdis_ingest_adapter_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  tags = local.global_settings.tags
  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
    "PARTNER_NAME"                           = local.global_settings.partner_name
    "RTZ_SCHEMA_V1_0"                        = azurerm_storage_blob.ecdisRtz10SchemaBlob.url
    "RTZ_SCHEMA_V1_2"                        = azurerm_storage_blob.ecdisRtz12SchemaBlob.url
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "PERM_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.permanent_blob_conneciton_string_name
    "PERM_STRG_NAME_KV_NAME"                 = var.keyvault_config.permanent_blob_account_name
    "PERM_STRG_KEY_KV_NAME"                  = var.keyvault_config.permanent_blob_account_key
    "PERM_STRG_URI_KV_NAME"                  = var.keyvault_config.permanent_blob_account_url
  }

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.ecdis_functions_storage_account,
    azurerm_service_plan.ecdis_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "ecdis_tenant_adapter_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.ecdis_tenant_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.ecdis_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_tenant_adapter_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.ecdis_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.ecdis_tenant_adapter_func_config.logs_quota_mb
  logs_retention_period_days         = local.ecdis_tenant_adapter_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "TEMP_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.temp_blob_conneciton_string_name
    "TEMP_STRG_NAME_KV_NAME"                 = var.keyvault_config.temp_blob_account_name
    "TEMP_STRG_KEY_KV_NAME"                  = var.keyvault_config.temp_blob_account_key
    "TEMP_STRG_URI_KV_NAME"                  = var.keyvault_config.temp_blob_account_url
    "PERM_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.permanent_blob_conneciton_string_name
    "PERM_STRG_NAME_KV_NAME"                 = var.keyvault_config.permanent_blob_account_name
    "PERM_STRG_KEY_KV_NAME"                  = var.keyvault_config.permanent_blob_account_key
    "PERM_STRG_URI_KV_NAME"                  = var.keyvault_config.permanent_blob_account_url
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
  }

  tags = local.global_settings.tags

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.ecdis_functions_storage_account,
    azurerm_service_plan.ecdis_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "ecdis_tenant_adapter_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.ecdis_tenant_adapter_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = azurerm_storage_account.ecdis_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.ecdis_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_tenant_adapter_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.ecdis_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.ecdis_tenant_adapter_func_config.logs_quota_mb
  logs_retention_period_days         = local.ecdis_tenant_adapter_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  tags = local.global_settings.tags
  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "TEMP_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.temp_blob_conneciton_string_name
    "TEMP_STRG_NAME_KV_NAME"                 = var.keyvault_config.temp_blob_account_name
    "TEMP_STRG_KEY_KV_NAME"                  = var.keyvault_config.temp_blob_account_key
    "TEMP_STRG_URI_KV_NAME"                  = var.keyvault_config.temp_blob_account_url
    "PERM_STRG_CONNECTION_KV_NAME"           = var.keyvault_config.permanent_blob_conneciton_string_name
    "PERM_STRG_NAME_KV_NAME"                 = var.keyvault_config.permanent_blob_account_name
    "PERM_STRG_KEY_KV_NAME"                  = var.keyvault_config.permanent_blob_account_key
    "PERM_STRG_URI_KV_NAME"                  = var.keyvault_config.permanent_blob_account_url
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "RMQ_HOST_KV_NAME"                       = var.keyvault_config.rmq_host_name
    "RMQ_USER_KV_NAME"                       = var.keyvault_config.rmq_user_name
    "RMQ_PASSWORD_KV_NAME"                   = var.keyvault_config.rmq_password_name
    "RMQ_VIRTUAL_HOST_KV_NAME"               = var.keyvault_config.rmq_vhost_name
  }

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]

  depends_on = [
    azurerm_storage_account.ecdis_functions_storage_account,
    azurerm_service_plan.ecdis_functions_service_plan,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "ecdis_audit_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.ecdis_audit_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_audit_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = merge(local.ecdis_audit_func_config.app_settings, {
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
  })
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  tags = local.global_settings.tags

  cors_allowed_origins     = local.ecdis_audit_func_config.cors_allowed_origins
  cors_support_credentials = local.ecdis_audit_func_config.cors_support_credentials

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]
}

module "ecdis_audit_windows_function_app" {
  source                             = "../Modules/windowsFunctionWithKvPolicy"
  count                              = local.ecdis_function_service_plan_config.os_type == "Windows" ? 1 : 0
  funciton_name                      = local.ecdis_audit_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.ecdis_functions_service_plan.id
  storage_account_name               = data.azurerm_storage_account.shared_functions_storage_account.name
  storage_account_primary_access_key = data.azurerm_storage_account.shared_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.ecdis_audit_func_config.public_network_access_enabled
  subnet_id                          = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
  dotnet_version                     = local.global_settings.dotnet_version
  app_settings = merge(local.ecdis_audit_func_config.app_settings, {
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
  })
  identity_type              = local.appconf_config.identity_type
  key_vault_id               = data.azurerm_key_vault.shared_key_vault.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  tags = local.global_settings.tags

  cors_allowed_origins     = local.ecdis_audit_func_config.cors_allowed_origins
  cors_support_credentials = local.ecdis_audit_func_config.cors_support_credentials

  func_ip_restrictions = [module.network_restrictions.func_shared_subnet_restriction]
}
