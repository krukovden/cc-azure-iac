resource "azurerm_signalr_service" "signalr-service" {
  name                                      = var.service_name
  location                                  = var.location
  resource_group_name                       = var.resource_group_name
  service_mode                              = var.service_mode
  public_network_access_enabled             = var.public_network_access_enabled
  serverless_connection_timeout_in_seconds  = var.connection_timeout_in_seconds
  connectivity_logs_enabled                 = var.connectivity_logs_enabled
  cors {
    allowed_origins = ["*"]
  }
  sku {
    capacity = var.capacity
    name     = var.sku_name
  }
}

resource "azurerm_monitor_diagnostic_setting" "signalr_ds" {
  name                       = "ds_${var.service_name}_logs"
  target_resource_id         = azurerm_signalr_service.signalr-service.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AllLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = false
  }

  depends_on = [azurerm_signalr_service.signalr-service]
}