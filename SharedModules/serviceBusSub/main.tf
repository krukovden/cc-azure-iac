resource "azurerm_servicebus_subscription" "servicebus_sub" {
  name               = var.servicebus_sub
  topic_id           = var.topic_id
  max_delivery_count = var.max_delivery_count
}
