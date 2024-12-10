resource "azurerm_key_vault" "vault" {
  name                          = var.kvname
  location                      = var.location
  resource_group_name           = var.rg_name
  sku_name                      = var.sku
  tenant_id                     = var.tenant_id
  enabled_for_disk_encryption   = var.enabled_for_disk_encryption
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  tags                          = var.tags
  public_network_access_enabled = var.public_network_access_enabled

  network_acls {
    bypass                     = var.bypass
    default_action             = var.default_action
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  lifecycle {
    ignore_changes = [
      tags["LastModifiedBy"],
      tags["LastModifiedTime"]
    ]
  }
}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id            = azurerm_key_vault.vault.id
  tenant_id               = var.tenant_id
  for_each                = var.access_policies
  object_id               = each.value.object_id #var.object_id
  certificate_permissions = each.value.certificate_permissions
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  
  depends_on = [azurerm_key_vault.vault]
}
#storage_permissions     = each.value.storage_permissions

resource "azurerm_key_vault_secret" "vault_secret" {
  name            = var.secret_name
  value           = var.secret_value
  key_vault_id    = azurerm_key_vault.vault.id
  content_type    = "password"
  expiration_date = "2025-12-31T00:00:00Z"

  depends_on = [
    azurerm_key_vault_access_policy.kv_access_policy
  ]
}