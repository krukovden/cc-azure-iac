resource "azurerm_eventgrid_system_topic" "eventGridSystemTopic" {
  name                   = var.system_topic_name
  resource_group_name    = var.rg_name
  location               = var.location
  source_arm_resource_id = var.source_arm_resource_id
  topic_type             = var.topic_type

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }
}

resource "azurerm_eventgrid_system_topic_event_subscription" "eventGridEventSub" {
  name                          = var.event_subscription_name
  system_topic                  = azurerm_eventgrid_system_topic.eventGridSystemTopic.name
  resource_group_name           = var.rg_name
  service_bus_topic_endpoint_id = var.sb_topic_endpoint_id
  included_event_types          = var.included_event_types

  advanced_filter {
    string_contains {
      key    = var.filter_key
      values = var.filter_value
    }
  }

  depends_on = [
    azurerm_eventgrid_system_topic.eventGridSystemTopic
  ]
}
