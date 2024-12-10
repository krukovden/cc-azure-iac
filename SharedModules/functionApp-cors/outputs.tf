output "funcst_connection_string" {
  value = azurerm_storage_account.funcAppStorageAccount.primary_connection_string
}

output "url" {
  value = "https://${data.azurerm_linux_function_app.function_data.default_hostname}/api/"
}
