resource "azurerm_storage_account" "storageAccount" {
  name                     = var.saccname
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version
  tags                     = var.tags
  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 10
    }
  }

  # identity {
  #   type         = var.identity_type
  #   identity_ids = var.identity_ids
  # }
}

resource "azurerm_storage_container" "storageContainer" {
  name                  = var.scontname
  storage_account_name  = var.saccname
  container_access_type = var.container_access_type

  depends_on = [
    azurerm_storage_account.storageAccount
  ]
}

resource "azurerm_eventgrid_system_topic" "eventGridSystemTopic" {
  name                   = var.system_topic_name
  resource_group_name    = var.rg_name
  location               = var.location
  source_arm_resource_id = azurerm_storage_account.storageAccount.id
  topic_type             = var.topic_type

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  depends_on = [
    azurerm_storage_account.storageAccount
  ]
}

resource "azurerm_eventgrid_system_topic_event_subscription" "eventGridEventSub" {
  name                          = var.event_subscription_name
  system_topic                  = azurerm_eventgrid_system_topic.eventGridSystemTopic.name
  resource_group_name           = var.rg_name
  service_bus_topic_endpoint_id = var.sb_topic_endpoint_id
  included_event_types          = var.included_event_types

  advanced_filter {
    string_contains {
      key = var.filter_key 
      values = var.filter_value
    }
  }

  depends_on = [
    azurerm_eventgrid_system_topic.eventGridSystemTopic
  ]
}

data "azurerm_storage_account_blob_container_sas" "blobContainerSAS" {
  connection_string = azurerm_storage_account.storageAccount.primary_connection_string
  container_name    = var.scontname
  https_only        = true

  # ip_address = "168.1.5.65"

  # VARIABLIZE 
  start  = "2023-04-18"
  expiry = "2030-07-20"
  #start  = formatdate(YYYY-MM-DD, timestamp())
  #expiry = formatdate(YYYY-MM-DD, timeadd(timestamp(), "720h"))

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }

  cache_control       = "max-age=5"
  content_disposition = "inline"
  content_encoding    = "deflate"
  content_language    = "en-US"
  content_type        = "application/json"

  depends_on = [
    azurerm_storage_container.storageContainer
  ]
}
