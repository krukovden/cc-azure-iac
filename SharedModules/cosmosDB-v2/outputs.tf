output "id" {
   value = azurerm_cosmosdb_account.cosmosdbAccount.id
}
output "name" {
   value = azurerm_cosmosdb_sql_database.cosmosDB.name
}
output "container_name" {
   value = azurerm_cosmosdb_sql_container.cosmosdbContainer.name
}
output "connection_string" {
   value = (azurerm_cosmosdb_account.cosmosdbAccount.connection_strings)[0]
   sensitive   = true
}
output "partition_key" {
   value = azurerm_cosmosdb_sql_container.cosmosdbContainer.partition_key_path
}