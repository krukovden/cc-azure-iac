output "api_id" {
  value = azurerm_api_management_api.apimAPI.id
}

output "api_policy_id" {
  value = azurerm_api_management_api_policy.apiPolicy.id
}

output "api_product_id" {
  value = azurerm_api_management_product.apiProduct.id
}
