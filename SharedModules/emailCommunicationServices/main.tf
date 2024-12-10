resource "azurerm_email_communication_service" "emailComm" {
  name                = var.name
  resource_group_name = var.resource_group_name
  data_location       = var.data_location
  tags                = var.tags
}
