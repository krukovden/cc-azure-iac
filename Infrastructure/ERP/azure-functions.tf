module "erp_executor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_executor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_executor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_executor_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_executor_func_config.logs_retention_period_days
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
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_import_report_request_dlq_queue_config.name
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "ERP_EXCHANGE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_request_report_handler_exchange_config.name
    "ERP_REQUEST_TOPIC"                      = module.erp_rmq_config.erp_rabbitmq_import_report_sender_binding_config.routing_key
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.er_rabbitmq_import_report_array_executor_queue_config.name
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_import_report_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_import_report_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_import_report_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_import_report_config.logs_quota_mb
  logs_retention_period_days         = local.erp_import_report_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "RESPONSE_EXCHANGE_NAME"                 = module.erp_rmq_config.er_rabbitmq_report_response_exchange_config.name
    "RESPONSE_HEADER_VALUE"                  = module.erp_rmq_config.erp_rabbitmq_import_report_writer_binding_config.header_value
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_import_report_request_dlq_queue_config.name
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_import_report_sender_queue_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "ABS_DIGITALPLATFORM_IMPORTREPORT_URL"   = "${local.abs_digitalplatform_config_base_url}/public/importerpreport"
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_auditor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_auditor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_auditor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_auditor_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_auditor_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"              = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                           = module.get_shared_kv_name.value
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED"   = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"           = "false"
    "REQUEST_DLQ_NAME"                         = module.erp_rmq_config.er_rabbitmq_import_report_request_dlq_queue_config.name
    "RESPONSE_DLQ_NAME"                        = module.erp_rmq_config.er_rabbitmq_import_report_response_dlq_queue_config.name
    "RESPONSE_QUEUE_NAME_PREFIX"               = module.erp_rmq_config.er_rabbitmq_import_report_response_client_queue.prefix
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
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_persist_response_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_persist_response_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_persist_response_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_persist_response_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_persist_response_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "RESPONSE_TOPIC"                         = module.erp_rmq_config.erp_rabbitmq_import_report_response_persist_retry_binding.routing_key
    "DELAY_EXCHANGE_NAME"                    = module.erp_rmq_config.er_rabbitmq_report_response_delay_exchange_config.name
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_import_report_response_dlq_queue_config.name
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_import_report_response_queue_config.name
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
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_validation_result_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.get_validation_result_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.get_validation_result_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.get_validation_result_config.logs_quota_mb
  logs_retention_period_days         = local.get_validation_result_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED"    = "1"
    "KEY_VAULT_NAME"                            = module.get_shared_kv_name.value
    "RABBIT_MQ_CONNECTION_STRING"               = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "DEAD_LETTER_QUEUE_NAME"                    = module.erp_rmq_config.er_rabbitmq_validation_request_dlq_queue_config.name
    "RESULT_EXCHANGE_NAME"                      = module.erp_rmq_config.er_rabbitmq_report_response_exchange_config.name
    "RESPONSE_TOPIC"                            = module.erp_rmq_config.erp_rabbitmq_validation_result_config.routing_key
    "SOURCE_QUEUE_NAME"                         = module.erp_rmq_config.erp_rabbitmq_validation_result_sender_queue_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"            = "false"
    "ABS_DIGITALPLATFORM_VALIDATION_REPORT_URL" = "${local.abs_digitalplatform_config_base_url}/public/getvalidationresults"
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_validation_result_scheduler_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.get_validation_result_scheduler_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.get_validation_result_scheduler_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.get_validation_result_scheduler_config.logs_quota_mb
  logs_retention_period_days         = local.get_validation_result_scheduler_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "FUNCTION_CRON_EXPRESSION"               = "*/5 * * * *"
    "RESPONSE_EXCHANGE_NAME"                 = module.erp_rmq_config.erp_rabbitmq_request_report_handler_exchange_config.name
    "RESPONSE_TOPIC"                         = module.erp_rmq_config.erp_rabbitmq_validation_result_config.routing_key
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_validation_auditor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_get_validation_auditor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_get_validation_auditor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_get_validation_auditor_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_get_validation_auditor_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"               = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                            = module.get_shared_kv_name.value
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED"    = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"            = "false"
    "REQUEST_DLQ_NAME"                          = module.erp_rmq_config.er_rabbitmq_validation_request_dlq_queue_config.name
    "RESPONSE_DLQ_NAME"                         = module.erp_rmq_config.er_rabbitmq_validation_response_dlq_queue_config.name
    "RESPONSE_QUEUE_NAME_PREFIX"                = module.erp_rmq_config.er_rabbitmq_validation_response_client_queue.prefix
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
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_validation_result_persist_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.get_validation_result_persist_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.get_validation_result_persist_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.get_validation_result_persist_config.logs_quota_mb
  logs_retention_period_days         = local.get_validation_result_persist_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "DELAY_EXCHANGE_NAME"                    = module.erp_rmq_config.er_rabbitmq_report_response_delay_exchange_config.name
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_validation_response_dlq_queue_config.name
    "RESPONSE_TOPIC"                         = module.erp_rmq_config.erp_rabbitmq_validation_result_config.routing_key
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_validation_response_queue_config.name
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_update_report_executor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_update_report_executor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_update_report_executor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_update_report_executor_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_update_report_executor_func_config.logs_retention_period_days
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
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_update_report_request_dlq_queue_config.name
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "ERP_EXCHANGE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_request_report_handler_exchange_config.name
    "ERP_REQUEST_TOPIC"                      = module.erp_rmq_config.erp_rabbitmq_update_report_sender_binding_config.routing_key
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.er_rabbitmq_update_report_executor_queue_config.name
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_update_report_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_1_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_update_report_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_1.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_update_report_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_update_report_config.logs_quota_mb
  logs_retention_period_days         = local.erp_update_report_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "RESPONSE_EXCHANGE_NAME"                 = module.erp_rmq_config.er_rabbitmq_report_response_exchange_config.name
    "RESPONSE_HEADER_VALUE"                  = module.erp_rmq_config.erp_rabbitmq_update_report_writer_binding_config.header_value
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_update_report_request_dlq_queue_config.name
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_update_report_sender_queue_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "ABS_DIGITALPLATFORM_UPDATEREPORT_URL"   = "${local.abs_digitalplatform_config_base_url}/public/updatereport"
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_1,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_update_report_auditor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_2_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_update_report_auditor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_2.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_update_report_auditor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_update_report_auditor_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_update_report_auditor_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"              = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                           = module.get_shared_kv_name.value
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED"   = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"           = "false"
    "REQUEST_DLQ_NAME"                         = module.erp_rmq_config.er_rabbitmq_update_report_request_dlq_queue_config.name
    "RESPONSE_DLQ_NAME"                        = module.erp_rmq_config.er_rabbitmq_update_report_response_dlq_queue_config.name
    "RESPONSE_QUEUE_NAME_PREFIX"               = module.erp_rmq_config.er_rabbitmq_update_report_response_client_queue.prefix
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
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_2,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_update_report_persist_response_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_2_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_update_report_persist_response_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_2.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_update_report_persist_response_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_update_report_persist_response_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_update_report_persist_response_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "RESPONSE_TOPIC"                         = module.erp_rmq_config.erp_rabbitmq_update_report_response_persist_retry_binding.routing_key
    "DELAY_EXCHANGE_NAME"                    = module.erp_rmq_config.er_rabbitmq_report_response_delay_exchange_config.name
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_update_report_response_dlq_queue_config.name
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_update_report_response_queue_config.name
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
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_2,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_voyages_executor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_2_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_get_voyages_executor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_2.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_get_voyages_executor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_get_voyages_executor_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_get_voyages_executor_func_config.logs_retention_period_days
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
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = var.keyvault_config.db_connection_string_name
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_get_voyages_request_dlq_queue_config.name
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "ERP_EXCHANGE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_request_report_handler_exchange_config.name
    "ERP_REQUEST_TOPIC"                      = module.erp_rmq_config.erp_rabbitmq_get_voyages_sender_binding_config.routing_key
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.er_rabbitmq_get_voyages_executor_queue_config.name
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_2,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_voyages_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_2_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_get_voyages_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_2.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_get_voyages_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_get_voyages_config.logs_quota_mb
  logs_retention_period_days         = local.erp_get_voyages_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "KEY_VAULT_NAME"                         = module.get_shared_kv_name.value
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "RESPONSE_EXCHANGE_NAME"                 = module.erp_rmq_config.er_rabbitmq_report_response_exchange_config.name
    "RESPONSE_HEADER_VALUE"                  = module.erp_rmq_config.erp_rabbitmq_get_voyages_writer_binding_config.header_value
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_get_voyages_request_dlq_queue_config.name
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_get_voyages_sender_queue_config.name
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "ABS_DIGITALPLATFORM_GETVOYAGES_URL"     = "${local.abs_digitalplatform_config_base_url}/public/geterpvoyages"
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_2,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_voyages_auditor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_2_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_get_voyages_auditor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_2.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_get_voyages_auditor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_get_voyages_auditor_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_get_voyages_auditor_func_config.logs_retention_period_days

  app_settings = {
    "RABBIT_MQ_CONNECTION_STRING"              = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "KEY_VAULT_NAME"                           = module.get_shared_kv_name.value
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED"   = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"           = "false"
    "REQUEST_DLQ_NAME"                         = module.erp_rmq_config.er_rabbitmq_get_voyages_request_dlq_queue_config.name
    "RESPONSE_QUEUE_NAME_PREFIX"               = module.erp_rmq_config.er_rabbitmq_get_voyages_response_client_queue.prefix
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
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_2,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_report_sof_executor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_2_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_get_report_sof_executor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_2.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_get_report_sof_executor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_get_report_sof_executor_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_get_report_sof_executor_func_config.logs_retention_period_days

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED"   = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"           = "false"
    "RABBIT_MQ_CONNECTION_STRING"              = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "POSTGRESQL_CONNECTION_STRING_KV_NAME"     = var.keyvault_config.db_connection_string_name
    "KEY_VAULT_NAME"                           = module.get_shared_kv_name.value
    "DEAD_LETTER_QUEUE_NAME"                   = module.erp_rmq_config.er_rabbitmq_get_report_sof_request_dlq_queue_config.name
    "ERP_EXCHANGE_NAME"                        = module.erp_rmq_config.erp_rabbitmq_request_report_handler_exchange_config.name
    "ERP_REQUEST_TOPIC"                        = module.erp_rmq_config.erp_rabbitmq_get_report_sof_writer_binding_config.header_value
  }

  identity_type              = local.appconf_config.identity_type
  key_vault_id               = module.get_shared_kv_id.value
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  certificate_permissions    = var.funcitons_kv_permissions.certificate_permissions
  key_permissions            = var.funcitons_kv_permissions.key_permissions
  secret_permissions         = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction,
    module.network_restrictions.apim_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_2,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_report_sof_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_2_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_get_report_sof_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_2.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_get_report_sof_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_get_report_sof_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_get_report_sof_func_config.logs_retention_period_days
  identity_type                      = local.appconf_config.identity_type
  key_vault_id                       = module.get_shared_kv_id.value
  tenant_id                          = data.azurerm_client_config.current.tenant_id
  certificate_permissions            = var.funcitons_kv_permissions.certificate_permissions
  key_permissions                    = var.funcitons_kv_permissions.key_permissions
  secret_permissions                 = var.funcitons_kv_permissions.secret_permissions
  log_analytics_workspace_id         = data.azurerm_log_analytics_workspace.lws_func_apps_logs.id

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT"         = "false"
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    "RABBIT_MQ_CONNECTION_STRING"            = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "RESPONSE_EXCHANGE_NAME"                 = module.erp_rmq_config.er_rabbitmq_report_response_exchange_config.name
    "RESPONSE_HEADER_VALUE"                  = module.erp_rmq_config.erp_rabbitmq_get_report_sof_writer_binding_config.header_value
    "DEAD_LETTER_QUEUE_NAME"                 = module.erp_rmq_config.er_rabbitmq_get_report_sof_request_dlq_queue_config.name
    "SOURCE_QUEUE_NAME"                      = module.erp_rmq_config.erp_rabbitmq_get_report_sof_sender_queue_config.name    
    "ABS_DIGITALPLATFORM_GETREPORTSOF_URL"   = "${local.abs_digitalplatform_config_base_url}/public/getsof"
    "ERP_BLOB_STORAGE_CONNECTION_STRING"     = "Blob Connection String"
    "ERP_BLOB_STORAGE_CONTAINER_NAME"        = "Blob Container Name"
  }

  func_ip_restrictions = [
    module.network_restrictions.func_shared_subnet_restriction
  ]

  depends_on = [
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_2,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}

module "erp_get_report_sof_auditor_linux_function_app" {
  source                             = "../Modules/linuxFunctionWithKvPolicy"
  count                              = local.erp_function_service_plan_2_config.os_type == "Linux" ? 1 : 0
  funciton_name                      = local.erp_get_report_sof_auditor_func_config.name
  resource_group_name                = local.global_settings.resource_group_name
  location                           = local.global_settings.location
  service_plan_id                    = azurerm_service_plan.erp_functions_service_plan_2.id
  storage_account_name               = azurerm_storage_account.erp_functions_storage_account.name
  storage_account_primary_access_key = azurerm_storage_account.erp_functions_storage_account.primary_access_key
  public_network_access_enabled      = local.erp_get_report_sof_auditor_func_config.public_network_access_enabled
  subnet_id                          = azurerm_subnet.erp_functions_subnet.id
  dotnet_version                     = local.global_settings.dotnet_version
  logs_quota_mb                      = local.erp_get_report_sof_auditor_func_config.logs_quota_mb
  logs_retention_period_days         = local.erp_get_report_sof_auditor_func_config.logs_retention_period_days

  app_settings = {
    "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED"   = "1"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"           = "false"
    "RABBIT_MQ_CONNECTION_STRING"              = "amqps://${data.env_var.rabbit_user.value}:${data.env_var.rabbit_pass.value}@${data.env_var.rabbit_url.value}/${data.env_var.rabbit_vhost.value}"
    "REQUEST_DLQ_NAME"                         = module.erp_rmq_config.er_rabbitmq_get_report_sof_request_dlq_queue_config.name
    "RESPONSE_QUEUE_NAME_PREFIX"               = module.erp_rmq_config.er_rabbitmq_get_report_sof_response_client_queue.prefix
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
    azurerm_storage_account.erp_functions_storage_account,
    azurerm_service_plan.erp_functions_service_plan_2,
    data.azurerm_log_analytics_workspace.lws_func_apps_logs
  ]
}
