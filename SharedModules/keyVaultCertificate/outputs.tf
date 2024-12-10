output "vault_id" {
  value = azurerm_key_vault.vault.id
}

output "key_id" {
  value = azurerm_key_vault_secret.vault_secret.id
}