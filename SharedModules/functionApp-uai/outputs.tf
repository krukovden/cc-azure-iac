output "funcst_connection_string" {
  value = azurerm_storage_account.funcAppStorageAccount.primary_connection_string
}

output "url" {
  value = "https://${data.azurerm_linux_function_app.function_data.default_hostname}/api/"
}

output "principal_id" {
  value = azurerm_linux_function_app.functionApp.identity[0].principal_id
}

output "storage_acc_id" {
  value = azurerm_storage_account.funcAppStorageAccount.id
}