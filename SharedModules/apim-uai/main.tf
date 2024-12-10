resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.rg_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  tags                = var.tags
  sku_name            = var.sku_name
  min_api_version     = var.min_api_version

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }
}

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

resource "azurerm_api_management_logger" "logger" {
  name                = var.apim_logger_name
  api_management_name = var.apim_name
  resource_group_name = var.rg_name
  resource_id         = azurerm_application_insights.app-insights.id
  application_insights {
    instrumentation_key = azurerm_application_insights.app-insights.instrumentation_key
  }
  depends_on = [
    azurerm_application_insights.app-insights 
  ]  
}

