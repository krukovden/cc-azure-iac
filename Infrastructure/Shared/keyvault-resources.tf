resource "azurerm_key_vault" "shared_key_vault" {
  name                = local.keyvault_config.name
  resource_group_name = local.global_settings.data_resource_group_name
  location            = local.global_settings.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = local.keyvault_config.sku_name
  tags                = local.global_settings.tags
  
  purge_protection_enabled = true

  depends_on = [ azurerm_resource_group.default ]
}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id            = azurerm_key_vault.shared_key_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  for_each                = local.keyvault_config.access_policies
  object_id               = each.value.object_id #var.object_id
  certificate_permissions = each.value.certificate_permissions
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions

  depends_on = [ azurerm_key_vault.shared_key_vault ]
}

resource "azurerm_key_vault_secret" "db_conneciton_string" {
  name         = local.keyvault_config.db_connection_string_name
  value        = "Server=${azurerm_private_endpoint.postgresql_private_endpoint.private_service_connection[0].private_ip_address};Database=citus;Port=5432;User Id=citus;Password=${data.env_var.db_pass.value};Ssl Mode=Require"
  key_vault_id = azurerm_key_vault.shared_key_vault.id
  tags         = local.global_settings.tags

  depends_on = [ 
    azurerm_key_vault_access_policy.kv_access_policy,
    azurerm_private_endpoint.postgresql_private_endpoint 
  ]
}

resource "azurerm_key_vault_secret" "rmq_host_name" {
  name         = local.keyvault_config.rmq_host_name
  value        = data.env_var.rabbit_url.value
  key_vault_id = azurerm_key_vault.shared_key_vault.id
  tags         = local.global_settings.tags

  depends_on = [ azurerm_key_vault_access_policy.kv_access_policy ]
}

resource "azurerm_key_vault_secret" "rmq_user_name" {
  name         = local.keyvault_config.rmq_user_name
  value        = data.env_var.rabbit_user.value
  key_vault_id = azurerm_key_vault.shared_key_vault.id
  tags         = local.global_settings.tags

  depends_on = [ azurerm_key_vault_access_policy.kv_access_policy ]
}

resource "azurerm_key_vault_secret" "rmq_password" {
  name         = local.keyvault_config.rmq_password_name
  value        = data.env_var.rabbit_pass.value
  key_vault_id = azurerm_key_vault.shared_key_vault.id
  tags         = local.global_settings.tags

  depends_on = [ azurerm_key_vault_access_policy.kv_access_policy ]
}

resource "azurerm_key_vault_secret" "rmq_vhost" {
  name         = local.keyvault_config.rmq_vhost_name
  value        = data.env_var.rabbit_vhost.value
  key_vault_id = azurerm_key_vault.shared_key_vault.id
  tags         = local.global_settings.tags

  depends_on = [ azurerm_key_vault_access_policy.kv_access_policy ]
}

resource "azurerm_key_vault_secret" "rmq_port" {
  name         = local.keyvault_config.rmq_port_name
  value        = data.env_var.rabbit_port.value
  key_vault_id = azurerm_key_vault.shared_key_vault.id
  tags         = local.global_settings.tags

  depends_on = [ azurerm_key_vault_access_policy.kv_access_policy ]
}