locals {
  env = lower(var.ENV)
  region_name = lower(var.REGION_CODE)
  region_suffix = lower(var.REGION_SUFFIX)
  region_env = "${local.region_suffix}-${local.env}"
  formatted_region_env = "${local.region_suffix}${local.env}"

  server_name = format(var.server_name_template, local.region_env)
  server_avalability_zone = local.env == "prd" ? "2" : "1"

  appconf_config = {
  for k, v in var.appconf_config_template :
    k => (k == "name" ? "${replace(v, "%s", local.region_env)}" : "${replace(v, "%s", local.env)}")
  }

  public_storage_account_config = merge(
    var.public_storage_account_config_template,
    { name = format(var.public_storage_account_config_template.name, local.formatted_region_env) }
  )

  tags = merge(var.global_settings_template.tags, { Environment = local.env })

  global_settings = merge(var.global_settings_template, { 
    location                      = local.region_name,  
    resource_group_name           = format(var.global_settings_template.resource_group_name, local.region_suffix),
    retention_resource_group_name = format(var.global_settings_template.retention_resource_group_name, local.region_suffix),
    data_resource_group_name      = format(var.global_settings_template.data_resource_group_name, local.region_suffix),
    tags                          = local.tags 
  })

  vnet_config = merge(
    var.vnet_config_template, 
    { name = format(var.vnet_config_template.name, local.env) }
  )

  postgresql_private_endpoint = merge(
    var.postgresql_private_endpoint_template,
    {
      name = format(var.postgresql_private_endpoint_template.name, local.env),
      dns_group_name = format(var.postgresql_private_endpoint_template.dns_group_name, local.env)
    }
  )

  keyvault_config = merge(
    var.keyvault_config_template, 
    { name = format(var.keyvault_config_template.name, local.region_env) }
  )

  nsr_allow_access_func_to_sql_config = merge(
    var.nsr_allow_access_func_to_sql_config_template, 
    { name = format(var.nsr_allow_access_func_to_sql_config_template.name, local.env) }
  )

  shared_func_storage_account_config = merge(
    var.shared_func_storage_account_config_template,
    { name = format(var.shared_func_storage_account_config_template.name, local.formatted_region_env) }
  )

  shared_network_security_group_config = merge(
    var.shared_network_security_group_config_template,
    { name = format(var.shared_network_security_group_config_template.name, local.env) }
  )

  shared_service_plan_config = merge(
    var.shared_service_plan_config_template,
    { 
      name = format(var.shared_service_plan_config_template.name, local.env),
      sku_name = var.shared_service_plan_sku_name[local.env] 
    }
  )

  apis_service_plan_config = merge(
    var.apis_service_plan_config_template,
    { 
      name = format(var.apis_service_plan_config_template.name, local.env),
      sku_name = var.apis_service_plan_sku_name[local.env] 
    }
  )
}
