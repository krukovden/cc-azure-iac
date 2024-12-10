locals {
  env = lower(var.ENV)
  region_name = lower(var.REGION_CODE)
  region_suffix = lower(var.REGION_SUFFIX)
  region_env = "${local.region_suffix}-${local.env}"
  formatted_region_env = "${local.region_suffix}${local.env}"

  vnet_name                        = format(var.vnet_name_template, local.env)
  apis_service_plan_name           = format(var.apis_service_plan_name_template, local.env)
  shared_service_plan_name         = format(var.shared_service_plan_name_template, local.env)
  shared_func_storage_account_name = format(var.shared_func_storage_account_name_template, local.formatted_region_env)

  appconf_config = {
  for k, v in var.appconf_config_template :
    k => (k == "name" ? "${replace(v, "%s", local.region_env)}" : "${replace(v, "%s", local.env)}")
  }

  tags = merge(var.global_settings_template.tags, { Environment = local.env })

  global_settings = merge(var.global_settings_template, { 
    location                      = local.region_name,  
    resource_group_name           = format(var.global_settings_template.resource_group_name, local.region_suffix),
    retention_resource_group_name = format(var.global_settings_template.retention_resource_group_name, local.region_suffix),
    data_resource_group_name      = format(var.global_settings_template.data_resource_group_name, local.region_suffix),
    tags                          = local.tags 
  })

  voyage_plan_api_func_config = merge(
    var.voyage_plan_api_func_config_template,
    { name = format(var.voyage_plan_api_func_config_template.name, local.region_env) }
  )

  voyage_plan_normalized_writer_func_config = merge(
    var.voyage_plan_normalized_writer_func_config_template,
    { name = format(var.voyage_plan_normalized_writer_func_config_template.name, local.region_env) }
  )

  shared_key_vault_params = merge(
    var.shared_key_vault_params_template,
    { name = format(var.shared_key_vault_params_template.name, local.region_env) }
  )

  voyage_plan_retention_func_config = merge(
    var.voyage_plan_retention_func_config_template,
    { name = format(var.voyage_plan_retention_func_config_template.name, local.region_env) }
  )

  retention_storage_account_config = merge(
    var.retention_storage_account_config_template,
    { name = format(var.retention_storage_account_config_template.name, local.formatted_region_env) }
  )
}