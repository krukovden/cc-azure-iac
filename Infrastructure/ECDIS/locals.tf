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

  postgresql_private_endpoint_name = format(var.postgresql_private_endpoint_name_template, local.env)
  vnet_name = format(var.vnet_name_template, local.env)
  shared_func_storage_account_name = format(var.shared_func_storage_account_name_template, local.formatted_region_env)
  shared_service_plan_name = format(var.shared_service_plan_name_template, local.env)

  ecdis_temp_storage_account_blob_config = merge(
    var.ecdis_temp_storage_account_blob_config_template,
    { name = format(var.ecdis_temp_storage_account_blob_config_template.name, local.formatted_region_env) }
  )

  ecdis_permanent_storage_account_blob_config = merge(
    var.ecdis_permanent_storage_account_blob_config_template,
    { name = format(var.ecdis_permanent_storage_account_blob_config_template.name, local.formatted_region_env) }
  )

  ecdis_storage_account_config = merge(
    var.ecdis_storage_account_config_template,
    { name = format(var.ecdis_storage_account_config_template.name, local.formatted_region_env) }
  )

  ecdis_function_service_plan_config = merge(
    var.ecdis_function_service_plan_config_template,
    { 
      name = format(var.ecdis_function_service_plan_config_template.name, local.env),
      sku_name = var.function_service_plan_sku_name[local.env] 
    }
  )

  ecdis_upload_rmq_adapter_func_config = merge(
    var.ecdis_upload_rmq_adapter_func_config_template,
    { name = format(var.ecdis_upload_rmq_adapter_func_config_template.name, local.region_env) }
  )

  ecdis_persist_raw_adapter_func_config = merge(
    var.ecdis_persist_raw_adapter_func_config_tempalte,
    { name = format(var.ecdis_persist_raw_adapter_func_config_tempalte.name, local.region_env) }
  )

  ecdis_ingest_adapter_func_config = merge(
    var.ecdis_ingest_adapter_func_config_template,
    { name = format(var.ecdis_ingest_adapter_func_config_template.name, local.region_env) }
  )

  ecdis_tenant_adapter_func_config = merge(
    var.ecdis_tenant_adapter_func_config_template,
    { name = format(var.ecdis_tenant_adapter_func_config_template.name, local.region_env) }
  )

  shared_key_vault_params = merge(
    var.shared_key_vault_params_template,
    { name = format(var.shared_key_vault_params_template.name, local.region_env) }
  )

  ecdis_audit_func_config = merge(
    var.ecdis_audit_func_config_template,
    { name = format(var.ecdis_audit_func_config_template.name, local.region_env) }
  )
}