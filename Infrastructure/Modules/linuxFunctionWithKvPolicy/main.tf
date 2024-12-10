resource "azurerm_linux_function_app" "function" {
  name                          = var.funciton_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = var.service_plan_id
  storage_account_name          = var.storage_account_name
  storage_account_access_key    = var.storage_account_primary_access_key
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.subnet_id

  site_config {
    always_on = true
    application_stack {
      dotnet_version              = var.dotnet_version
      use_dotnet_isolated_runtime = var.use_dotnet_isolated_runtime
    }
    app_service_logs {
      disk_quota_mb         = var.logs_quota_mb
      retention_period_days = var.logs_retention_period_days
    }
    cors {
      allowed_origins     = var.cors_allowed_origins
      support_credentials = var.cors_support_credentials
    }

    vnet_route_all_enabled = var.vnet_route_all_enabled

    dynamic "ip_restriction" {
      for_each = var.func_ip_restrictions
      content {
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        action                    = ip_restriction.value.action
        priority                  = ip_restriction.value.priority
        name                      = ip_restriction.value.name
      }
    }
  }

  app_settings = merge(var.app_settings, {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = false
  })
  tags = var.tags

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  dynamic "connection_string" {
    for_each = var.func_connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id            = var.key_vault_id
  count                   = var.key_vault_id == null ? 0 : 1
  tenant_id               = var.tenant_id
  object_id               = azurerm_linux_function_app.function.identity[0].principal_id
  certificate_permissions = var.certificate_permissions
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions

  depends_on = [azurerm_linux_function_app.function]
}

resource "azurerm_monitor_diagnostic_setting" "function_ds" {
  name                       = "ds_${var.funciton_name}_logs"
  target_resource_id         = azurerm_linux_function_app.function.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "FunctionAppLogs"
  }

  depends_on = [azurerm_linux_function_app.function]

  metric {
    category = "AllMetrics"
    enabled  = false
  }
}