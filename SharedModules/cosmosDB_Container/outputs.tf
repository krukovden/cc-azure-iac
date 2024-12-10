output "db_name" {
  value = data.azurerm_cosmosdb_sql_database.cosmosDB.name
}
output "container_name" {
  value = azurerm_cosmosdb_sql_container.cosmosdbContainer.name
}
output "partitionKey" {
  value = azurerm_cosmosdb_sql_container.cosmosdbContainer.partition_key_path
}
