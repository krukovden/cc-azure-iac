resource "azurerm_static_site" "static_web_app" {
  name                = var.app_name
  resource_group_name = var.rg_name
  location            = var.location
  sku_tier            = var.sku_tier
  sku_size            = var.sku_size
  tags                = var.tags
}
