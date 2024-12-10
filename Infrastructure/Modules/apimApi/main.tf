locals {

  apim_name = module.get_apim_name.value

  function_app_hostname = try(data.azurerm_windows_function_app.windows_function_app.default_hostname, data.azurerm_linux_function_app.linux_function_app.default_hostname)
  function_app_id = try(data.azurerm_windows_function_app.windows_function_app.id, data.azurerm_linux_function_app.linux_function_app.id)

  apim_api_backend_params = {
    name        = var.apim_api_backend_params.name
    protocol    = var.apim_api_backend_params.protocol
    url         = format("%s%s/api", "https://", local.function_app_hostname)
    description = var.apim_api_backend_params.description
    resource_id = format("%s%s", var.apim_api_backend_params.url, local.function_app_id)
  }
}

data "azurerm_linux_function_app" "linux_function_app" {
  name                = var.azure_function_name
  resource_group_name = var.global_settings.resource_group_name
}

data "azurerm_windows_function_app" "windows_function_app" {
  name                = var.azure_function_name
  resource_group_name = var.global_settings.resource_group_name
}

module "get_apim_name" {
  source         = "../../../SharedModules/appConfigGetValue"
  appconfig_name = var.appconf_config.name
  rg_name        = var.global_settings.resource_group_name
  key            = var.appconf_config.apim_name_key
  label          = var.appconf_config.label
}

resource "azurerm_api_management_api" "apim_api" {
  name                  = var.apim_api_params.name
  resource_group_name   = var.global_settings.resource_group_name
  api_management_name   = local.apim_name
  revision              = var.apim_api_params.revision
  path                  = var.apim_api_params.path
  display_name          = var.apim_api_params.displayName
  protocols             = var.apim_api_params.protocols
  subscription_required = false
}

resource "azurerm_api_management_api_policy" "apim_api_policy" {
  api_name            = azurerm_api_management_api.apim_api.name
  api_management_name = azurerm_api_management_api.apim_api.api_management_name
  resource_group_name = azurerm_api_management_api.apim_api.resource_group_name
  xml_content         = local.apim-api-policy-xml-content
}

resource "azurerm_api_management_backend" "apim_api_backend" {
  name                = var.apim_api_backend_params.name
  resource_group_name = azurerm_api_management_api.apim_api.resource_group_name
  api_management_name = local.apim_name
  protocol            = local.apim_api_backend_params.protocol
  url                 = local.apim_api_backend_params.url
  description         = local.apim_api_backend_params.description
  resource_id         = local.apim_api_backend_params.resource_id 
}

resource "azurerm_api_management_api_operation" "function_operation" {
  for_each            = var.azure_function_operations

  api_name            = azurerm_api_management_api.apim_api.name
  api_management_name = local.apim_name
  resource_group_name = azurerm_api_management_api.apim_api.resource_group_name

  operation_id        = each.key
  display_name        = each.value.displayDame
  url_template        = each.value.urlTemplate
  description         = each.value.description
  method              = each.value.httpMethod
}