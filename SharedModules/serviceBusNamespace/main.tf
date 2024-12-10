resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  name                          = var.servicebus_namespace
  location                      = var.location
  resource_group_name           = var.rg_name
  sku                           = var.sku
  local_auth_enabled            = var.local_auth_enabled
  public_network_access_enabled = var.public_network_access_enabled
  minimum_tls_version           = var.minimum_tls_version
  tags                          = var.tags
}
