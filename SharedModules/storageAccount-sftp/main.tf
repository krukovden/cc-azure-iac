resource "azurerm_storage_account" "storageAccount" {
  name                     = var.saccname
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version
  sftp_enabled             = var.sftp_enabled
  is_hns_enabled           = var.is_hns_enabled
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

resource "azurerm_storage_data_lake_gen2_filesystem" "data_lake_gen2" {
  name               = var.data_lake_name
  storage_account_id = azurerm_storage_account.storageAccount.id

  depends_on = [
    azurerm_storage_account.storageAccount
  ]
}

# resource "azurerm_storage_account_network_rules" "network" {
#   storage_account_id = azurerm_storage_account.storageAccount.id

#   default_action = var.default_action
#   bypass         = var.bypass

#   virtual_network_subnet_ids = var.storage_virtual_network_subnet_ids

#   depends_on = [
#     azurerm_storage_account.storageAccount
#   ]
# }

data "azurerm_storage_account_sas" "st_sas" {
  connection_string = azurerm_storage_account.storageAccount.primary_connection_string
  https_only        = var.https_only
  signed_version    = var.signed_version

  resource_types {
    service   = var.service
    container = var.container
    object    = var.object
  }

  services {
    blob  = var.blob
    queue = var.queue
    table = var.table
    file  = var.file
  }

  start  = var.sas_token_start
  expiry = var.sas_token_expiry

  permissions {
    read    = var.read
    write   = var.write
    delete  = var.delete
    list    = var.list
    add     = var.add
    create  = var.create
    update  = var.update
    process = var.process
    tag     = var.tag
    filter  = var.filter
  }
}
