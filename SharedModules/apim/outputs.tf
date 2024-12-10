output "name" {
  value = azurerm_api_management.apim.name
}

output "id" {
  value = azurerm_api_management.apim.id
}

output "logger_id" {
  value = azurerm_api_management_logger.logger.id
}

output "instrumentation_key" {
  value = azurerm_application_insights.app-insights.instrumentation_key
}

output "app_id" {
  value = azurerm_application_insights.app-insights.app_id
}

output "connection_string" {
  value = azurerm_application_insights.app-insights.connection_string
}
