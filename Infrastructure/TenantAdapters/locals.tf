locals {
  env = lower(var.ENV)
  region_name = lower(var.REGION_CODE)
  region_suffix = lower(var.REGION_SUFFIX)
  region_env = "${local.region_suffix}-${local.env}"
  formatted_region_env = "${local.region_suffix}${local.env}"

  postgresql_private_endpoint_name = format(var.postgresql_private_endpoint_name_template, local.env)
  vnet_name = format(var.vnet_name_template, local.env)
  apis_service_plan_name = format(var.apis_service_plan_name_template, local.env)
  shared_func_storage_account_name = format(var.shared_func_storage_account_name_template, local.formatted_region_env)

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

  shared_key_vault_params = merge(
    var.shared_key_vault_params_template,
    { name = format(var.shared_key_vault_params_template.name, local.region_env) }
  )

  tenant_api_func_app_settings = merge(
    var.tenant_api_func_app_settings_template,
    {
      "ABS_VESON_REGISTER_PARTNER_URL"         = format(var.tenant_api_func_app_settings_template["ABS_VESON_REGISTER_PARTNER_URL"], local.region_env)
      "ABS_ECDIS_REGISTER_PARTNER_URL"         = format(var.tenant_api_func_app_settings_template["ABS_ECDIS_REGISTER_PARTNER_URL"], local.region_env)
      "KEY_VAULT_NAME"                         = data.azurerm_key_vault.shared_key_vault.name
      "POSTGRESQL_CONNECTION_STRING_KV_NAME"   = local.shared_key_vault_params.secrets.db_connection_string_name
      "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
    }
  )

  tenant_api_func_config = merge(
    var.tenant_api_func_config_template,
    {
      name = format(var.tenant_api_func_config_template.name, local.region_env),
    }
  )
}