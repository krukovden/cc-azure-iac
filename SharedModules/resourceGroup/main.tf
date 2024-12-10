resource "azurerm_resource_group" "resourceGroup" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}
