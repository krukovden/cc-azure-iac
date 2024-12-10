data "azurerm_app_configuration" "app_config" {
  name                = var.appconfig_name
  resource_group_name = var.rg_name
}

data "azurerm_app_configuration_key" "appconf_get_value" {
  configuration_store_id = data.azurerm_app_configuration.app_config.id
  key                    = var.key
  label                  = var.label

  depends_on = [
    data.azurerm_app_configuration.app_config
  ]
}
