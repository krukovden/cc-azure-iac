resource "azurerm_storage_container" "storageContainer" {
  name                  = var.scontname
  storage_account_name  = var.saccname
  container_access_type = "private"
}
