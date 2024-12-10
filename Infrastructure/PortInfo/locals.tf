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

  tags                   = merge(var.global_settings_template.tags, { Environment = local.env })
  vnet_name              = format(var.vnet_name_template, local.env)
  apis_service_plan_name = format(var.apis_service_plan_name_template, local.env)

  global_settings = merge(var.global_settings_template, { 
    location                 = local.region_name,  
    resource_group_name      = format(var.global_settings_template.resource_group_name, local.region_suffix),
    data_resource_group_name = format(var.global_settings_template.data_resource_group_name, local.region_suffix),
    tags                     = local.tags 
  })

  port_info_veson_func_config = merge(
    var.port_info_veson_func_config_template,
    { name = format(var.port_info_veson_func_config_template.name, local.region_env) }
  )

  port_info_storage_account_config = merge(
    var.port_info_storage_account_config_template,
    { name = format(var.port_info_storage_account_config_template.name, local.formatted_region_env) }
  )

  port_info_unece_func_config = merge(
    var.port_info_unece_func_config_template,
    { name = format(var.port_info_unece_func_config_template.name, local.region_env) }
  )

  port_info_auditor_func_config = merge(
    var.port_info_auditor_func_config_template,
    { name = format(var.port_info_auditor_func_config_template.name, local.region_env) }
  )

  port_info_function_service_plan_config = merge(
    var.port_info_function_service_plan_config_template,
    { 
      name = format(var.port_info_function_service_plan_config_template.name, local.env)
      sku_name = var.function_service_plan_sku_name[local.env] 
    }
  )
}