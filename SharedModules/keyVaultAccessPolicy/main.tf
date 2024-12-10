data "azurerm_key_vault" "vault" {
  name                = var.kvname
  resource_group_name = var.rg_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id            = data.azurerm_key_vault.vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = var.object_id
  certificate_permissions = var.certificate_permissions
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
}
