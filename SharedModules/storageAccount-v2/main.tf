resource "azurerm_storage_account" "storageAccount" {
  name                     = var.saccname
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version
  tags                     = var.tags

  queue_properties {
    logging {
      delete                = var.queue_delete
      read                  = var.queue_read
      write                 = var.queue_write
      version               = var.queue_version
      retention_policy_days = var.retention_policy_days
    }
  }

  blob_properties {
    versioning_enabled = var.versioning_enabled
  }
}

resource "azurerm_storage_account_network_rules" "network" {
  storage_account_id = azurerm_storage_account.storageAccount.id

  default_action             = var.default_action
  bypass                     = var.bypass
  ip_rules                   = var.ip_rules
  virtual_network_subnet_ids = var.storage_virtual_network_subnet_ids

  depends_on = [
    azurerm_storage_account.storageAccount
  ]
}

resource "azurerm_storage_container" "storageContainer" {
  name                  = var.scontname
  storage_account_name  = var.saccname
  container_access_type = var.container_access_type

  depends_on = [
    azurerm_storage_account.storageAccount
  ]
}

data "azurerm_storage_account_blob_container_sas" "blobContainerSAS" {
  connection_string = azurerm_storage_account.storageAccount.primary_connection_string
  container_name    = var.scontname
  https_only        = var.https_only

  start  = var.sas_token_start
  expiry = var.sas_token_expiry

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }

  cache_control       = var.cache_control
  content_disposition = var.content_disposition
  content_encoding    = var.content_encoding
  content_language    = var.content_language
  content_type        = var.content_type

  depends_on = [
    azurerm_storage_container.storageContainer
  ]
}

data "azurerm_storage_account_sas" "st_sas" {
  connection_string = azurerm_storage_account.storageAccount.primary_connection_string
  https_only        = var.https_only
  signed_version    = var.signed_version

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = true
    table = true
    file  = true
  }

  start  = var.sas_token_start
  expiry = var.sas_token_expiry

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
    tag     = true
    filter  = true
  }
}
