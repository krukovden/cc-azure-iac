resource "azurerm_postgresql_flexible_server" "server" {
  name                   = local.server_name
  resource_group_name    = local.global_settings.data_resource_group_name
  location               = local.global_settings.location
  version                = "16"
  administrator_login    = "citus"
  administrator_password = data.env_var.db_pass.value
  zone                   = local.server_avalability_zone
  storage_mb             = 1048576
  sku_name               = "B_Standard_B2s"

  depends_on = [ azurerm_resource_group.default ]
}

resource "azurerm_postgresql_flexible_server_configuration" "azure_extensions" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.server.id
  value     = "UUID-OSSP"

  depends_on = [ azurerm_postgresql_flexible_server.server ]
}

resource "azurerm_postgresql_flexible_server_database" "citus_database" {
  name      = "citus"
  server_id = azurerm_postgresql_flexible_server.server.id

  depends_on = [ azurerm_postgresql_flexible_server.server ]
}

resource "azurerm_private_endpoint" "postgresql_private_endpoint" {
  name                = local.postgresql_private_endpoint.name
  resource_group_name = local.global_settings.data_resource_group_name
  location            = local.global_settings.location
  subnet_id           = azurerm_subnet.endpoint_subnet.id
  tags                = local.global_settings.tags

  private_service_connection {
    name                           = local.postgresql_private_endpoint.name
    private_connection_resource_id = azurerm_postgresql_flexible_server.server.id
    is_manual_connection           = local.postgresql_private_endpoint.is_manual_connection
    subresource_names              = local.postgresql_private_endpoint.subresource
  }

  depends_on = [ 
    azurerm_postgresql_flexible_server.server,
    azurerm_resource_group.default 
  ]
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "allow_all"
  server_id        = azurerm_postgresql_flexible_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"

  depends_on = [ azurerm_postgresql_flexible_server.server ]
}
