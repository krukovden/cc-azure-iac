resource "azurerm_cosmosdb_account" "cosmosdbAccount" {
  name                          = var.cosmosdbacc_name
  location                      = var.location
  resource_group_name           = var.rg_name
  offer_type                    = var.offer_type
  kind                          = var.kind
  enable_automatic_failover     = var.enable_automatic_failover
  tags                          = var.tags
  default_identity_type         = var.default_identity_type
  public_network_access_enabled = var.public_network_access_enabled

  # virtual_network_rule {
  #   id = var.subnet_id
  # }

  capabilities {
    name = var.capability_name
  }
  consistency_policy {
    consistency_level       = var.consistency_level
    max_interval_in_seconds = var.max_interval_in_seconds
    max_staleness_prefix    = var.max_staleness_prefix
  }
  geo_location {
    location          = var.location
    failover_priority = var.failover_priority
  }
  backup {
    type = var.backup_type
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy
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
  partition_key_version = var.partition_key_version

  indexing_policy {
    indexing_mode = var.indexing_mode

    included_path {
      path = var.included_path
    }
  }

  unique_key {
    paths = var.unique_key_path
  }

  depends_on = [
    azurerm_cosmosdb_sql_database.cosmosDB
  ]
}
