locals {
  env = lower(var.ENV)
  region_name = lower(var.REGION_CODE)
  region_suffix = lower(var.REGION_SUFFIX)
  region_env = "${local.region_suffix}-${local.env}"
  formatted_region_env = "${local.region_suffix}${local.env}"
  ui_client_id = data.azurerm_key_vault_secret.ui_client_id.value
  formatted_ui_client_id = lower(replace(local.ui_client_id, "-", ""))
  tenant_adapter_func_name = format(var.tenant_adapter_func_name_template, local.region_env)
  onboarding_middleware_api_func_name = format(var.onboarding_middleware_api_func_config_template.name, local.region_env)

  appconf_config = {
  for k, v in var.appconf_config_template :
    k => (k == "name" ? "${replace(v, "%s", local.region_env)}" : "${replace(v, "%s", local.env)}")
  }

  tags = merge(var.global_settings_template.tags, { Environment = local.env })

  global_settings = merge(var.global_settings_template, { 
    location                 = local.region_name,  
    resource_group_name      = format(var.global_settings_template.resource_group_name, local.region_suffix),
    data_resource_group_name = format(var.global_settings_template.data_resource_group_name, local.region_suffix),
    tags                     = local.tags 
  })

  postgresql_private_endpoint_name = format(var.postgresql_private_endpoint_name_template, local.env)
  vnet_name = format(var.vnet_name_template, local.env)
  shared_service_plan_name = format(var.shared_service_plan_name_template, local.env)
  shared_func_storage_account_name = format(var.shared_func_storage_account_name_template, local.formatted_region_env)

  shared_key_vault_params = merge(
    var.shared_key_vault_params_template,
    { name = format(var.shared_key_vault_params_template.name, local.region_env) }
  )

  onboardingmiddleware_api_func_app_settings = merge(
    var.onboardingmiddleware_api_func_app_settings_template,
    {      
      "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
      "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
      "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
      "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
      "TENANT_DATA_SOURCE_QUEUE_NAME"          = format(var.onboardingmiddleware_api_func_app_settings_template.TENANT_DATA_SOURCE_QUEUE_NAME, local.formatted_ui_client_id)
      "AzureSignalRConnectionString"           = data.azurerm_key_vault_secret.signalR_connection_string.value
      "PERM_STRG_MDF_VESSEL_API_BASE_URL"      = var.MDF_VESSEL_BASE_URL
      "PERM_STRG_MDF_TENANT_API_BASE_URL"      = var.MDF_TENANT_BASE_URL
      "TenantAdapterBaseUrl"                   = format("https://%s/api/", try(data.azurerm_windows_function_app.tenant_adapter_windows_function_app.default_hostname, data.azurerm_linux_function_app.tenant_adapter_linux_function_app.default_hostname))
    }
  )

  onboardingmiddleware_api_func_config = merge(
    var.onboarding_middleware_api_func_config_template,
    {
      name = format(var.onboarding_middleware_api_func_config_template.name, local.region_env),
    }
  )

  onboarding_middleware_signalR_service_config = merge(
    var.onboarding_middleware_signalR_service_config_template,
    {
      name = format(var.onboarding_middleware_signalR_service_config_template.name, local.region_env),
    }
  )
  
  onboarding_middleware_vessel_processing_storage_account_config = merge(
    var.onboarding_middleware_vessel_processing_storage_account_config_template,
    { name = format(var.onboarding_middleware_vessel_processing_storage_account_config_template.name, local.formatted_region_env) }
  )

   onboarding_middleware_vessel_processing_func_config = merge(
    var.onboarding_middleware_vessel_processing_func_config_template,
    { name = format(var.onboarding_middleware_vessel_processing_func_config_template.name, local.region_env) }
  )

    onboarding_middleware_vessel_processing_func_app_settings = merge(
      var.onboardingmiddleware_api_func_app_settings_template,
      {      
        "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
        "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
        "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
        "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
        "PERM_STRG_NAME_KV_NAME"                 = var.onboarding_middleware_vessel_processing_key_vault_params_template.permanent_blob_account_name
        "PERM_STRG_KEY_KV_NAME"                  = var.onboarding_middleware_vessel_processing_key_vault_params_template.permanent_blob_account_key
        "PERM_STRG_URI_KV_NAME"                  = var.onboarding_middleware_vessel_processing_key_vault_params_template.permanent_blob_account_url
        "PERM_STRG_MDF_VESSEL_API_BASE_URL"      = var.MDF_VESSEL_BASE_URL
        "PERM_STRG_MDF_TENANT_API_BASE_URL"      = var.MDF_TENANT_BASE_URL
        "TENANT_DATA_SOURCE_QUEUE_NAME"          = format(var.onboardingmiddleware_api_func_app_settings_template.TENANT_DATA_SOURCE_QUEUE_NAME, local.formatted_ui_client_id)
        "AzureSignalRConnectionString"           = data.azurerm_key_vault_secret.signalR_connection_string.value
      }
  )

  onboarding_middleware_vessel_catalog_storage_account_blob_config = merge(
    var.onboarding_middleware_vessel_catalog_storage_account_blob_config_template,
    { name = format(var.onboarding_middleware_vessel_catalog_storage_account_blob_config_template.name, local.formatted_region_env) }
  )

  onboarding_middleware_vessel_catalog_processing_func_config = merge(
    var.onboarding_middleware_vessel_catalog_processing_func_config_template,
    { name = format(var.onboarding_middleware_vessel_catalog_processing_func_config_template.name, local.region_env) }
  )

    onboarding_middleware_vessel_catalog_processing_func_app_settings = merge(
      var.onboardingmiddleware_api_func_app_settings_template,
      {      
        "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
        "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
        "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
        "RABBIT_MQ_CONNECTION_STRING"            = data.env_var.rabbit_connection_string.value
      }
  )    
}