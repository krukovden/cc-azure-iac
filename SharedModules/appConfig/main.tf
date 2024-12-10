resource "azurerm_app_configuration" "appConfig" {
  name                     = var.appconfig_name
  resource_group_name      = var.rg_name
  location                 = var.location
  sku                      = var.sku
  tags                     = var.tags
  local_auth_enabled       = var.local_auth_enabled
  purge_protection_enabled = var.purge_protection_enabled

}

  # encryption {
  #   identity_client_id = var.identity_client_id
  # }
