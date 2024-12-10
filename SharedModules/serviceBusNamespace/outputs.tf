output "sb_namespace_id" {
  value = azurerm_servicebus_namespace.servicebus_namespace.id
}

output "sb_namespace_name" {
  value = azurerm_servicebus_namespace.servicebus_namespace.name
}

output "connection_string" {
  value = azurerm_servicebus_namespace.servicebus_namespace.default_primary_connection_string
}