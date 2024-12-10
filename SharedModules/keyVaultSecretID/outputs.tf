output "secret_id" {
  value = data.azurerm_key_vault_secret.vault_secret.id
}
