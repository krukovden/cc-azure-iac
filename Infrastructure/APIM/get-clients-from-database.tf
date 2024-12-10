provider "postgresql" {
  host            = data.azurerm_postgresql_flexible_server.database_server.fqdn
  port            = 5432
  database        = var.database_name
  username        = data.env_var.database_username.value
  password        = data.env_var.database_password.value
  sslmode         = "require"
  connect_timeout = 15
}

data "env_var" "database_username" {
  id       = var.env_vars_names.database_username
  required = true
}

data "env_var" "database_password" {
  id       = var.env_vars_names.database_password
  required = true
}

data "postgresql_query" "get_clients" {
  database = var.database_name
  query    = <<-EOF
    SELECT client_id::text FROM public.client ORDER BY client_id
  EOF
}

data "postgresql_query" "get_ui_client" {
  database = var.database_name
  query    = <<-EOF
    SELECT c.client_id::text FROM public.client c WHERE c.tags LIKE '%ui_tool%' ORDER BY c.update_datetime DESC LIMIT 1
  EOF
}

data "azurerm_postgresql_flexible_server" "database_server" {
  name                = local.database_server_name
  resource_group_name = local.global_settings.data_resource_group_name
}