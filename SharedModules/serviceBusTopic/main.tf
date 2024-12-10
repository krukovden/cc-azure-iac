resource "azurerm_servicebus_topic" "servicebus_topic" {
  name                = var.servicebus_topic
  namespace_id        = var.namespace_id
  enable_partitioning = var.enable_partitioning
}
