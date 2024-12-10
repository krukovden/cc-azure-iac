output "sas_url_query_string" {
  value = data.azurerm_storage_account_sas.st_sas.sas
  sensitive   = true
}
output "blob_sas_url" {
  value = data.azurerm_storage_account_blob_container_sas.blobContainerSAS.sas
  sensitive   = true
}
output "container_name" {
  value = azurerm_storage_container.storageContainer.name
}
output "connection_string" {
  value = azurerm_storage_account.storageAccount.primary_connection_string
}
output "id" {
  value = azurerm_storage_account.storageAccount.id
}
