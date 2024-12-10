output "id" {
  value = azurerm_user_assigned_identity.user_assigned_id.id
}

output "name" {
  value = azurerm_user_assigned_identity.user_assigned_id.name
}

output "client_id" {
  value = azurerm_user_assigned_identity.user_assigned_id.client_id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.user_assigned_id.principal_id
}

output "tenant_id" {
  value = azurerm_user_assigned_identity.user_assigned_id.tenant_id
}
