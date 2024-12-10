resource "azurerm_user_assigned_identity" "user_assigned_id" {
  location            = var.location
  name                = var.user_assigned_name
  resource_group_name = var.rg_name
  tags                = var.tags
}