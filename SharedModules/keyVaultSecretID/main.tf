# This Key Vault module grabs an ID for a secrets. 
# This is most useful for manually created secrets.
data "azurerm_key_vault_secret" "vault_secret" {
  name         = var.name
  key_vault_id = var.key_vault_id
}
