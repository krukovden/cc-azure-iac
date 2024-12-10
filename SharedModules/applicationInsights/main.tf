resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.sku
  retention_in_days   = var.retention
}

resource "azurerm_application_insights" "app-insights" {
  name                = var.appi_name
  location            = var.location
  resource_group_name = var.rg_name
  application_type    = var.application_type
  workspace_id        = azurerm_log_analytics_workspace.log_workspace.id
  tags                = var.tags
}