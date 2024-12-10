resource "azurerm_servicebus_queue" "serviceBusQueue" {
  name         = var.queue_name
  namespace_id = var.namespace_id

  enable_partitioning = var.enable_partition
}