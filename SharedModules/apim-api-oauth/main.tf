resource "azurerm_api_management_api" "apimAPI" {
  name                = var.api_name
  resource_group_name = var.rg_name
  api_management_name = var.apim_name
  revision            = var.revision
  display_name        = var.display_name
  path                = var.path
  protocols           = var.protocols
  api_type            = var.api_type
  service_url         = var.service_url
  oauth2_authorization {
    authorization_server_name = var.authorization_server_name
  }
}

resource "azurerm_api_management_api_policy" "apiPolicy" {
  api_name            = var.api_name
  api_management_name = var.apim_name
  resource_group_name = var.rg_name

  xml_content = var.xml_content

  depends_on = [
    azurerm_api_management_api.apimAPI
  ]
}

resource "azurerm_api_management_product" "apiProduct" {
  product_id            = var.product_id
  api_management_name   = var.apim_name
  resource_group_name   = var.rg_name
  display_name          = var.product_display_name
  subscription_required = var.subscription_required
  approval_required     = var.approval_required
  published             = var.published
}
