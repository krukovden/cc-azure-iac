resource "azurerm_storage_account" "funcAppStorageAccount" {
  name                     = var.func_storage_acc_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version
  tags                     = var.tags

  blob_properties {
    versioning_enabled = true
  }

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 30
    }
  }
}

resource "azurerm_storage_account_network_rules" "network" {
  storage_account_id = azurerm_storage_account.funcAppStorageAccount.id

  default_action = var.default_action
  bypass         = var.bypass

  virtual_network_subnet_ids = var.storage_virtual_network_subnet_ids

  depends_on = [
    azurerm_storage_account.funcAppStorageAccount
  ]
}

resource "azurerm_windows_function_app" "functionApp" {
  name                            = var.func_name
  resource_group_name             = var.rg_name
  location                        = var.location
  service_plan_id                 = var.service_plan_id #azurerm_service_plan.funcAppServicePlan.id
  storage_account_name            = azurerm_storage_account.funcAppStorageAccount.name
  storage_account_access_key      = azurerm_storage_account.funcAppStorageAccount.primary_access_key
  https_only                      = var.https_only
  key_vault_reference_identity_id = var.key_vault_reference_identity_id
  public_network_access_enabled   = var.public_network_access_enabled
  virtual_network_subnet_id       = var.function_virtual_network_subnet_id
  tags                            = var.tags

  site_config {
    ftps_state        = var.ftps_state
    always_on         = var.always_on
    health_check_path = var.health_check_path
    application_stack {
      use_dotnet_isolated_runtime = var.use_dotnet_isolated_runtime
      dotnet_version              = var.dotnet_version
    }

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions != [] ? var.ip_restrictions : []
      content {
        name       = ip_restriction.value.name
        ip_address = ip_restriction.value.ip_address
        action     = ip_restriction.value.action
        priority   = ip_restriction.value.priority
      }
    }
  }

  app_settings = var.app_settings

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  depends_on = [
    azurerm_storage_account.funcAppStorageAccount,
    azurerm_storage_account_network_rules.network
  ]
}

data "azurerm_windows_function_app" "function_data" {
  name                = azurerm_windows_function_app.functionApp.name
  resource_group_name = var.rg_name

  depends_on = [
    azurerm_windows_function_app.functionApp
  ]
}
