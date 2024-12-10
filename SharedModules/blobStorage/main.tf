resource "azurerm_storage_blob" "blob_storage" {
  name                   = var.blobname
  storage_account_name   = var.saccname
  storage_container_name = var.scontname
  type                   = "Block"
}
