resource "azurerm_resource_group" "tfstate" {
  name     = "abs-tfstate-rg"
  location = var.location
}

resource "azurerm_storage_account" "tfstate" {
  name                          = "abstfstate"
  resource_group_name           = "abs-tfstate-rg"
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "GRS"
  allow_blob_public_access      = false
  min_tls_version               = "TLS1_2"
  local_auth_enabled            = false
  public_network_access_enabled = false

  queue_properties  {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 10
    }
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = "abstfstate"
  container_access_type = "private"
}