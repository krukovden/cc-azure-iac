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

data "postgresql_query" "check_client_exist" {
  database = var.database_name
  query    = <<-EOF
    SELECT EXISTS (
      SELECT 1 
      FROM public.client_settings 
      WHERE client_id = '${var.client_id}' 
    )::text AS client_exists;
  EOF
}

data "azurerm_postgresql_flexible_server" "database_server" {
  name                = local.database_server_name
  resource_group_name = local.global_settings.data_resource_group_name
}