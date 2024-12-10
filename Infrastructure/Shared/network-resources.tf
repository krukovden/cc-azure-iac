module "vnet" {
  source              = "../../SharedModules/vnet"
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location
  name                = local.vnet_config.name
  address_space       = local.vnet_config.address_space
  tags                = local.global_settings.tags

  depends_on = [ azurerm_resource_group.default ]
}

resource "azurerm_subnet" "shared_functions_subnet" {
  resource_group_name  = local.global_settings.resource_group_name
  name                 = module.subnet_config.shared_functions_subnet_config.name
  address_prefixes     = [module.subnet_config.shared_functions_subnet_config.address_prefix]
  virtual_network_name = local.vnet_config.name

  depends_on = [
    azurerm_resource_group.default,
    module.vnet
  ]

  service_endpoints = module.subnet_config.shared_functions_subnet_config.service_endpoints
  delegation {
    name = module.subnet_config.shared_functions_subnet_config.delegation_name
    service_delegation {
      name    = module.subnet_config.shared_functions_subnet_config.service_delegation_name
      actions = module.subnet_config.shared_functions_subnet_config.service_delegation_actions
    }
  }
}

resource "azurerm_subnet" "endpoint_subnet" {
  resource_group_name  = local.global_settings.resource_group_name
  name                 = module.subnet_config.endpoint_subnet_config.name
  address_prefixes     = [module.subnet_config.endpoint_subnet_config.address_prefix]
  virtual_network_name = local.vnet_config.name

  depends_on = [
    azurerm_resource_group.default,
    module.vnet
  ]
}

resource "azurerm_network_security_group" "shared_nsg" {
  name                = local.shared_network_security_group_config.name
  resource_group_name = local.global_settings.resource_group_name
  location            = local.global_settings.location

  depends_on = [ azurerm_resource_group.default ]
}