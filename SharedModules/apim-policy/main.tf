resource "azurerm_api_management_policy" "apim_policy" {
  api_management_id = var.api_management_id
  xml_content       = var.xml_content
}
