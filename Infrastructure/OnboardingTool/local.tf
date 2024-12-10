locals {

  env = lower(var.ENV)
  region_name = lower(var.REGION_CODE)
  region_suffix = lower(var.REGION_SUFFIX)
  tags = merge(var.global_settings.tags, { Environment = local.env })

  web_app = merge(
    var.web_app_config,
    {
      domain_name = format(var.web_app_config.domain_name, local.region_suffix, local.env),
    }
  )

  global_settings = merge(var.global_settings, { 
    location                 = local.region_name,  
    resource_group_name      = format(var.global_settings.resource_group_name, local.region_suffix),
    tags                     = local.tags 
  })
}
