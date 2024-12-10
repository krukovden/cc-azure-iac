data "azurerm_cosmosdb_account" "cosmosdbAccount" {
  name                = var.cosmosdbacc_name
  resource_group_name = var.rg_name
}
data "azurerm_cosmosdb_sql_database" "cosmosDB" {
  name                = var.cosmosdb_name
  resource_group_name = var.rg_name
  account_name        = var.cosmosdbacc_name
}

resource "azurerm_cosmosdb_sql_container" "cosmosdbContainer" {
  name                  = var.cosmosdb_container
  resource_group_name   = var.rg_name
  account_name          = data.azurerm_cosmosdb_account.cosmosdbAccount.name
  database_name         = data.azurerm_cosmosdb_sql_database.cosmosDB.name
  partition_key_path    = var.partition_key_path
  partition_key_version = var.partition_key_version

  indexing_policy {
    indexing_mode = var.indexing_mode

    dynamic "included_path" {
      for_each = var.included_paths
      content {
        path = included_path.value
      }
    }

    dynamic "excluded_path" {
      for_each = var.excluded_paths
      content {
        path = excluded_path.value
      }
    }

    dynamic "composite_index" {
      for_each = var.composite_indexes != [] ? var.composite_indexes : []
      content {
        dynamic "index" {
          for_each = composite_index.value
          content {
            path  = index.value.path
            order = index.value.order
          }
        }
      }
    }
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  depends_on = [
    data.azurerm_cosmosdb_sql_database.cosmosDB,
    data.azurerm_cosmosdb_account.cosmosdbAccount
  ]
}

