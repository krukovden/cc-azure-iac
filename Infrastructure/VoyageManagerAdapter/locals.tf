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
    location                      = local.region_name,  
    resource_group_name           = format(var.global_settings_template.resource_group_name, local.region_suffix),
    data_resource_group_name      = format(var.global_settings_template.data_resource_group_name, local.region_suffix),
    tags                          = local.tags 
  })

  vnet_name                        = format(var.vnet_name_template, local.env)
  shared_service_plan_name         = format(var.shared_service_plan_name_template, local.env)
  shared_func_storage_account_name = format(var.shared_func_storage_account_name_template, local.formatted_region_env)
  postgresql_private_endpoint_name = format(var.postgresql_private_endpoint_name_template, local.env)

  vm_provision_adapter_func_config = merge(
    var.vm_provision_adapter_func_config_template,
    { name = format(var.vm_provision_adapter_func_config_template.name, local.region_env) }
  )

  vm_key_rotation_func_config = merge(
    var.vm_key_rotation_func_config_template,
    { name = format(var.vm_key_rotation_func_config_template.name, local.region_env) }
  )

  shared_key_vault_params = merge(
    var.shared_key_vault_params_template,
    { name = format(var.shared_key_vault_params_template.name, local.region_env) }
  )
}