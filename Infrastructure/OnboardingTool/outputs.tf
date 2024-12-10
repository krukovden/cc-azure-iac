output "static_web_app_deployment_token" {
  value       = azurerm_static_web_app.onboardingtool_static_site.api_key
  description = "The API Key of the Static webapp/Site."
  sensitive   = true
}

output "id" {
  value       = azurerm_static_web_app.onboardingtool_static_site.id
  description = "The ID of the Static /webappSite."
  sensitive   = true
}

output "default_host_name" {
  value       = azurerm_static_web_app.onboardingtool_static_site.default_host_name
  description = "The Default Host Name of the Static Site."
}