output "name" {
  value = azurerm_resource_group.resourceGroup.name
}
output "id" {
  value     = azurerm_resource_group.resourceGroup.id
  sensitive = true
}
