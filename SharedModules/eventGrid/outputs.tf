output "system_topic_name" {
  value = azurerm_eventgrid_system_topic.eventGridSystemTopic.name
}

output "system_topic_event_subscription_name" {
  value = azurerm_eventgrid_system_topic_event_subscription.eventGridEventSub.name
}
