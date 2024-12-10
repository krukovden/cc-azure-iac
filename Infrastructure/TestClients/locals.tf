locals {
  env = lower(var.ENV)
  region_name = lower(var.REGION_CODE)
  region_suffix = lower(var.REGION_SUFFIX)
  region_env = "${local.region_suffix}-${local.env}"
  formatted_region_env = "${local.region_suffix}${local.env}"

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

  test_client_storage_account_config = merge(
    var.test_client_storage_account_config_template,
    { name = format(var.test_client_storage_account_config_template.name, local.formatted_region_env) }
  )

  test_client_function_service_plan_config = merge(
    var.test_client_function_service_plan_config_template,
    { name = format(var.test_client_function_service_plan_config_template.name, local.env) }
  )

  test_client_func_config = merge(
    var.test_client_func_config_template,
    { 
      name = format(var.test_client_func_config_template.name, local.region_env)
      root_location = format(var.test_client_func_config_template.root_location, local.region_env)
    }
  )
}