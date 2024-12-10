output "id" {
  value = azurerm_redis_cache.redis_cache.id
}

output "hostname" {
  value = azurerm_redis_cache.redis_cache.hostname
}

output "ssl_port" {
  value = azurerm_redis_cache.redis_cache.ssl_port
}

output "port" {
  value = azurerm_redis_cache.redis_cache.port
}

output "connection_string" {
  value = azurerm_redis_cache.redis_cache.primary_connection_string
}
