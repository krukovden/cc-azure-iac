data "azurerm_app_configuration" "app_config" {
  name                = var.appconfig_name
  resource_group_name = var.rg_name
}

resource "azurerm_app_configuration_key" "app_config_key" {
  configuration_store_id = data.azurerm_app_configuration.app_config.id
  key                    = var.key
  label                  = var.label
  value                  = var.value
  type                   = var.type
}
