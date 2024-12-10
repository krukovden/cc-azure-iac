output "sas_url_query_string" {
  value     = data.azurerm_storage_account_sas.st_sas.sas
  sensitive = true
}
output "connection_string" {
  value = azurerm_storage_account.storageAccount.primary_connection_string
}
output "id" {
  value = azurerm_storage_account.storageAccount.id
}
