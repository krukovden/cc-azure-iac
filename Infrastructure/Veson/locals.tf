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

  apis_service_plan_name = format(var.apis_service_plan_name_template, local.env)
  vnet_name              = format(var.vnet_name_template, local.env)
  tags                   = merge(var.global_settings_template.tags, { Environment = local.env })

  global_settings = merge(var.global_settings_template, { 
    location                 = local.region_name,  
    resource_group_name      = format(var.global_settings_template.resource_group_name, local.region_suffix),
    data_resource_group_name = format(var.global_settings_template.data_resource_group_name, local.region_suffix),
    tags                     = local.tags 
  })

  veson_storage_account_config = merge(
    var.veson_storage_account_config_template,
    { name = format(var.veson_storage_account_config_template.name, local.formatted_region_env) }
  )

  veson_function_service_plan_config = merge(
    var.veson_function_service_plan_config_template,
    { 
      name = format(var.veson_function_service_plan_config_template.name, local.env)
      sku_name = var.function_service_plan_sku_name[local.env]
    }
  )

  veson_register_tenant_func_config = merge(
    var.veson_register_tenant_func_config_template,
    { name = format(var.veson_register_tenant_func_config_template.name, local.region_env) }
  )

  veson_puller_func_config = merge(
    var.veson_puller_func_config_template,
    { name = format(var.veson_puller_func_config_template.name, local.region_env) }
  )

  veson_raw_writer_func_config = merge(
    var.veson_raw_writer_func_config_template,
    { name = format(var.veson_raw_writer_func_config_template.name, local.region_env) }
  )

  veson_normalize_func_config = merge(
    var.veson_normalize_func_config_template,
    { name = format(var.veson_normalize_func_config_template.name, local.region_env) }
  )

  veson_schedule_trigger_func_config = merge(
    var.veson_schedule_trigger_func_config_template,
    { name = format(var.veson_schedule_trigger_func_config_template.name, local.region_env) }
  )

  veson_raw_republisher_func_config = merge(
    var.veson_raw_republisher_func_config_template,
    { name = format(var.veson_raw_republisher_func_config_template.name, local.region_env) }
  )

  veson_port_schedule_trigger_func_config = merge(
    var.veson_port_schedule_trigger_func_config_template,
    { name = format(var.veson_port_schedule_trigger_func_config_template.name, local.region_env) }
  )

  veson_port_puller_func_config = merge(
    var.veson_port_puller_func_config_template,
    { name = format(var.veson_port_puller_func_config_template.name, local.region_env) }
  )

  veson_port_writer_func_config = merge(
    var.veson_port_writer_func_config_template,
    { name = format(var.veson_port_writer_func_config_template.name, local.region_env) }
  )

  veson_port_info_func_config = merge(
    var.veson_port_info_func_config_template,
    { name = format(var.veson_port_info_func_config_template.name, local.region_env) }
  )

  veson_auditor_func_config = merge(
    var.veson_auditor_func_config_template,
    { name = format(var.veson_auditor_func_config_template.name, local.region_env) }
  )

  veson_storage_account_blob_config = merge(
    var.veson_storage_account_blob_config_template,
    { name = format(var.veson_storage_account_blob_config_template.name, local.formatted_region_env) }
  )

  veson_blob_storage_config = merge(
    var.veson_blob_storage_config_template,
    { name = format(var.veson_blob_storage_config_template.name, local.env) }
  )

  veson_raw_storage_container_config = merge(
    var.veson_raw_storage_container_config_template,
    { name = format(var.veson_raw_storage_container_config_template.name, local.env) }
  )
}