resource "azurerm_storage_account" "funcAppStorageAccount" {
  name                     = var.func_storage_acc_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version
  tags                     = var.tags

  queue_properties  {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 30
    }
  }
}

resource "azurerm_storage_container" "storageContainer" {
  name                  = var.func_storage_cont_name
  storage_account_name  = azurerm_storage_account.funcAppStorageAccount.name
  container_access_type = var.container_access_type

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
  tags                            = var.tags
  
  site_config {
    ftps_state        = var.ftps_state
    always_on         = var.always_on
    health_check_path = var.health_check_path
    application_stack{
      use_dotnet_isolated_runtime = var.use_dotnet_isolated_runtime
      dotnet_version              = var.dotnet_version
    }
  }

  app_settings = var.app_settings

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  depends_on = [
    azurerm_service_plan.funcAppServicePlan,
    azurerm_storage_account.funcAppStorageAccount
  ]
}

data "azurerm_linux_function_app" "function_data" {
  name                = azurerm_linux_function_app.functionApp.name
  resource_group_name = var.rg_name

  depends_on = [ 
    azurerm_linux_function_app.functionApp
  ]
}
