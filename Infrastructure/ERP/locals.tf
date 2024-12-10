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

  erp_storage_account_config = merge(
    var.erp_storage_account_config_template,
    { name = format(var.erp_storage_account_config_template.name, local.formatted_region_env) }
  )

  erp_executor_func_config = merge(
    var.erp_executor_func_config_template,
    { name = format(var.erp_executor_func_config_template.name, local.region_env) }
  )

  erp_function_common_service_plan_config = merge(
    var.erp_function_service_plan_config_template,
    {
      name     = format(var.erp_function_service_plan_config_template.name, local.env)
      sku_name = var.function_service_plan_sku_name[local.env]
    }
  )

  erp_function_service_plan_1_config = merge(
    local.erp_function_common_service_plan_config,
    { name = join("-", [local.erp_function_common_service_plan_config.name, "1"]) }
  )

  erp_function_service_plan_2_config = merge(
    local.erp_function_common_service_plan_config,
    { name = join("-", [local.erp_function_common_service_plan_config.name, "2"]) }
  )

  erp_import_report_config = merge(
    var.erp_import_report_config_template,
    { name = format(var.erp_import_report_config_template.name, local.region_env) }
  )

  erp_auditor_func_config = merge(
    var.erp_auditor_func_config_template,
    { name = format(var.erp_auditor_func_config_template.name, local.region_env) }
  )

  erp_persist_response_func_config = merge(
    var.erp_persist_response_func_config_template,
    { name = format(var.erp_persist_response_func_config_template.name, local.region_env) }
  )

  get_validation_result_config = merge(
    var.get_validation_result_config_template,
    { name = format(var.get_validation_result_config_template.name, local.region_env) }
  )

  get_validation_result_scheduler_config = merge(
    var.get_validation_result_scheduler_config_template,
    { name = format(var.get_validation_result_scheduler_config_template.name, local.region_env) }
  )

  erp_get_validation_auditor_func_config = merge(
    var.erp_get_validation_auditor_func_config_template,
    { name = format(var.erp_get_validation_auditor_func_config_template.name, local.region_env) }
  )

  get_validation_result_persist_config = merge(
    var.get_validation_result_persist_config_template,
    { name = format(var.get_validation_result_persist_config_template.name, local.region_env) }
  )

  erp_update_report_executor_func_config = merge(
    var.erp_update_report_executor_func_config_template,
    { name = format(var.erp_update_report_executor_func_config_template.name, local.region_env) }
  )

  erp_update_report_config = merge(
    var.erp_update_report_config_template,
    { name = format(var.erp_update_report_config_template.name, local.region_env) }
  )

  erp_update_report_auditor_func_config = merge(
    var.erp_update_report_auditor_func_config_template,
    { name = format(var.erp_update_report_auditor_func_config_template.name, local.region_env) }
  )

  erp_update_report_persist_response_func_config = merge(
    var.erp_update_report_persist_response_func_config_template,
    { name = format(var.erp_update_report_persist_response_func_config_template.name, local.region_env) }
  )

  erp_get_voyages_executor_func_config = merge(
    var.erp_get_voyages_executor_func_config_template,
    { name = format(var.erp_get_voyages_executor_func_config_template.name, local.region_env) }
  )

  erp_get_voyages_config = merge(
    var.erp_get_voyages_config_template,
    { name = format(var.erp_get_voyages_config_template.name, local.region_env) }
  )

  erp_get_voyages_auditor_func_config = merge(
    var.erp_get_voyages_auditor_func_config_template,
    { name = format(var.erp_get_voyages_auditor_func_config_template.name, local.region_env) }
  )

  erp_get_report_sof_executor_func_config = merge(
    var.erp_get_report_sof_executor_func_config_template,
    { name = format(var.erp_get_report_sof_executor_func_config_template.name, local.region_env) }
  )

  erp_get_report_sof_func_config = merge(
    var.erp_get_report_sof_config_template,
    { name = format(var.erp_get_report_sof_config_template.name, local.region_env) }
  )

  erp_get_report_sof_auditor_func_config = merge(
    var.erp_get_report_sof_auditor_func_config_template,
    { name = format(var.erp_get_report_sof_auditor_func_config_template.name, local.region_env) }
  )

  abs_digitalplatform_config_base_url = "https://uat-erport-background.ase-erport-dev.p.azurewebsites.net/api"
}
