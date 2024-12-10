resource "azurerm_storage_account" "storageAccount" {
  name                     = var.saccname
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
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

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "storageContainer" {
  name                  = var.scontname
  storage_account_name  = var.saccname
  container_access_type = "private"

  depends_on = [
    azurerm_storage_account.storageAccount
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

data "azurerm_storage_account_sas" "st_sas" {
  connection_string = azurerm_storage_account.storageAccount.primary_connection_string
  https_only        = true
  signed_version    = "2021-12-02"

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

  start  = "2023-04-18"
  expiry = "2030-07-18"

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
