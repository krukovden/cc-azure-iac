output "storage_account_name" {
  value = azurerm_storage_account.storageAccount.name
}

output "storage_account_connection_string" {
  value = azurerm_storage_account.storageAccount.primary_connection_string
}

output "storage_account_container_name" {
  value = azurerm_storage_container.storageContainer.name
}

output "system_topic_name" {
  value = azurerm_eventgrid_system_topic.eventGridSystemTopic.name
}

output "system_topic_event_subscription_name" {
  value = azurerm_eventgrid_system_topic_event_subscription.eventGridEventSub.name
}

output "blob_sas_url" {
  value = data.azurerm_storage_account_blob_container_sas.blobContainerSAS.sas
  sensitive   = true
}