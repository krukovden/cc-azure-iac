resource "azurerm_cosmosdb_account" "cosmosdbAccount" {
  name                      = var.cosmosdbacc_name
  location                  = var.location
  resource_group_name       = var.rg_name
  offer_type                = var.offer_type
  kind                      = var.kind
  enable_automatic_failover = var.enable_automatic_failover
  tags                      = var.tags
  capabilities {
    name = var.capabilities_name
  }
  geo_location {
    location          = var.location
    failover_priority = var.failover_priority
  }
  consistency_policy {
    consistency_level       = var.consistency_level
    max_interval_in_seconds = var.max_interval_in_seconds
    max_staleness_prefix    = var.max_staleness_prefix
  }
}


resource "azurerm_cosmosdb_sql_database" "cosmosDB" {
  name                = var.cosmosdb_name
  resource_group_name = var.rg_name
  account_name        = var.cosmosdbacc_name

  depends_on = [
    azurerm_cosmosdb_account.cosmosdbAccount
  ]
}

resource "azurerm_cosmosdb_sql_container" "cosmosdbContainer" {
  name                  = var.cosmosdb_container
  resource_group_name   = var.rg_name
  account_name          = var.cosmosdbacc_name
  database_name         = var.cosmosdb_name
  partition_key_path    = var.partition_key_path
  partition_key_version = 1

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

  depends_on = [
    azurerm_cosmosdb_sql_database.cosmosDB
  ]
}

