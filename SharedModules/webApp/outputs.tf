output "static_web_app_deployment_token" {
  value = azurerm_static_site.static_web_app.api_key
  description = "The API Key of the Static webapp/Site."
}

output "id" {
  value       = azurerm_static_site.static_web_app.id
  description = "The ID of the Static /webappSite."
}

output "default_host_name" {
  value       = azurerm_static_site.static_web_app.default_host_name
  description = "The Default Host Name of the Static Site."
}
