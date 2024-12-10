resource "azurerm_storage_account" "funcAppStorageAccount" {
  name                     = var.func_storage_acc_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version
  tags                     = var.tags
}

resource "azurerm_storage_container" "storageContainer" {
  name                  = var.func_storage_cont_name
  storage_account_name  = azurerm_storage_account.funcAppStorageAccount.name
  container_access_type = var.container_access_type
}

resource "azurerm_service_plan" "funcAppServicePlan" {
  name                = var.func_asp_name
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_function_app" "functionApp" {
  name                       = var.func_name
  resource_group_name        = var.rg_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.funcAppServicePlan.id
  storage_account_name       = azurerm_storage_account.funcAppStorageAccount.name
  storage_account_access_key = azurerm_storage_account.funcAppStorageAccount.primary_access_key
  https_only                 = var.https_only
  tags                       = var.tags
  
  site_config {
    ftps_state        = var.ftps_state
    always_on         = var.always_on
    health_check_path = var.health_check_path
    application_stack{
      use_dotnet_isolated_runtime = var.use_dotnet_isolated_runtime
      dotnet_version              = var.dotnet_version
    }
  }

  app_settings = {
    "COSMOS_DATABASE_NAME"                     = var.db_name,
    "COSMOS_CONTAINER_NAME"                    = var.container_name,
    "COSMOS_DB_CONNECTION_STRING"              = var.db_connection_string,
    "SETTINGS_COSMOS_CONTAINER_NAME"           = var.settings_container_name,
    "WEBSITE_RUN_FROM_PACKAGE"                 = var.sas_url,
    "FUNCTIONS_WORKER_RUNTIME"                 = var.functions_worker_runtime,
    "WEBSITE_CONTENTSHARE"                     = "${var.func_name}-content",
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = var.st_connection_string,
    "APPINSIGHTS_INSTRUMENTATIONKEY"           = var.instrumentation_key,
    "APPLICATIONINSIGHTS_CONNECTION_STRING"    = var.appi_connection_string,
    "BLOB_STORAGE_CONNECTION"                  = var.blob_connection_string,
    "TRANSFORM_CONTAINER"                      = var.transform_container_name,
    "SERVICE_BUS_CONNECTION"                   = var.service_bus_connection_string,
    "TRANSFORM_INPUT_TOPIC"                    = var.transform_input_topic,
    "TRANSFORM_INPUT_TOPIC_SUBSCRIPTION"       = var.transform_input_topic_subscription,
    "TRANSFORM_OUTPUT_TOPIC"                   = var.transform_output_topic,
    "ALERT_OUTPUT_TOPIC"                       = var.alert_output_topic,
    "ACTIVE_DIRECTORY_TENANT"                  = var.ad_tenant,
    "ACTIVE_DIRECTORY_INITIAL_PASSWORD"        = var.ad_initial_password,
    "ACTIVE_DIRECTORY_REDIRECT_URL"            = var.ad_redirect_url,
    "SMTP_SERVER"                              = var.smtp_server,
    "SMTP_PORT"                                = var.smtp_port,
    "SMTP_USERNAME"                            = var.smtp_username,
    "SMTP_PASSWORD"                            = var.smtp_password,
    "SMTP_ENABLE_SSL"                          = var.smtp_enable_ssl
  }
}

data "azurerm_linux_function_app" "function_data" {
  name                = azurerm_linux_function_app.functionApp.name
  resource_group_name = var.rg_name

  depends_on = [ 
    azurerm_linux_function_app.functionApp
  ]
}
