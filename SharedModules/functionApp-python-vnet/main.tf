resource "azurerm_storage_account" "funcAppStorageAccount" {
  name                     = var.func_storage_acc_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version
  tags                     = var.tags

  blob_properties {
    versioning_enabled = var.versioning_enabled
  }

  queue_properties  {
    logging {
      delete                = var.queue_logging_delete
      read                  = var.queue_logging_read
      write                 = var.queue_logging_write
      version               = var.queue_logging_version
      retention_policy_days = var.retention_policy_days
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

resource "azurerm_service_plan" "funcAppServicePlan" {
  name                = var.func_asp_name
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name
  worker_count        = var.worker_count
  tags                = var.tags
}

resource "azurerm_linux_function_app" "functionApp" {
  name                            = var.func_name
  resource_group_name             = var.rg_name
  location                        = var.location
  service_plan_id                 = azurerm_service_plan.funcAppServicePlan.id
  storage_account_name            = azurerm_storage_account.funcAppStorageAccount.name
  storage_account_access_key      = azurerm_storage_account.funcAppStorageAccount.primary_access_key
  https_only                      = var.https_only
  key_vault_reference_identity_id = var.key_vault_reference_identity_id
  virtual_network_subnet_id       = var.function_virtual_network_subnet_id
  tags                            = var.tags
  
  site_config {
    ftps_state        = var.ftps_state
    always_on         = var.always_on
    health_check_path = var.health_check_path
    application_stack{
      python_version = var.python_version
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
