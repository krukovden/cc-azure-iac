resource "azurerm_static_site" "static_web_app" {
  name                = var.app_name
  resource_group_name = var.rg_name
  location            = var.location
  sku_tier            = "Standard"
  sku_size            = "Standard"
  tags                = var.tags

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }
}
