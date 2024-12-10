data "azurerm_api_management" "apim" {
  name                = var.apim_name
  resource_group_name = var.rg_name
}

data "azurerm_api_management_api" "api" {
  name                = var.api_name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_api_management.apim.resource_group_name
  revision            = var.revision
}

data "azurerm_api_management_product" "apiProduct" {
  product_id          = var.product_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_api_management.apim.resource_group_name
}

resource "azurerm_api_management_product_api" "productAPI" {
  api_name            = data.azurerm_api_management_api.api.name
  product_id          = data.azurerm_api_management_product.apiProduct.product_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_api_management.apim.resource_group_name
}