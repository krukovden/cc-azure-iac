module "subnet_config" {
  source      = "../subnetConfigs"
  environment = var.global_settings.tags.Environment
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.global_settings.resource_group_name
}

data "azurerm_subnet" "vnet_subnets" {
  for_each             = toset(data.azurerm_virtual_network.vnet.subnets)
  name                 = each.value
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

output "apim_subnet_restriction" {
  value = {
    virtual_network_subnet_id = data.azurerm_subnet.vnet_subnets[module.subnet_config.apim_subnet_config.name].id
    action                    = "Allow"
    priority                  = 1000
    name                      = "apim-subnet"
  }
}

output "func_shared_subnet_restriction" {
  value = {
    virtual_network_subnet_id = data.azurerm_subnet.vnet_subnets[module.subnet_config.shared_functions_subnet_config.name].id
    action                    = "Allow"
    priority                  = 1001
    name                      = "func-shared-subnet"
  }
}

output "veson_func_subnet_priority" {
  value = 1002
}

output "ecdis_func_subnet_priority" {
  value = 1003
}
