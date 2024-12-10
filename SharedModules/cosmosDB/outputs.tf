output "id" {
   value = azurerm_cosmosdb_account.cosmosdbAccount.id
}
output "cosmosdb_name" {
   value = azurerm_cosmosdb_sql_database.cosmosDB.name
}
output "cosmosdb_container_name" {
   value = azurerm_cosmosdb_sql_container.cosmosdbContainer.name
}
output "cosmosdb_connectionstrings" {
   value = (azurerm_cosmosdb_account.cosmosdbAccount.connection_strings)[0]
   sensitive   = true
}
output "partitionKey" {
   value = azurerm_cosmosdb_sql_container.cosmosdbContainer.partition_key_path
}

