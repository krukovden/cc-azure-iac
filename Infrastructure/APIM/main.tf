terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
    env = {
      source  = "tcarreira/env"
      version = "~> 0.2.0"
    }
    postgresql = {
      source  = "ricochet1k/postgresql"
      version = "~> 1.20.2"
    }
  }
  required_version = ">= 1.1.0"
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "env_var" "apim_tenant_id" {
  id       = var.env_vars_names.apim_tenant_id
  required = true # (optional) plan will error if not found
}

data "env_var" "publisher_name" {
  id       = var.env_vars_names.publisher_name
  required = true # (optional) plan will error if not found
}

module "get_shared_vnet_name" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.vnet_name
  label          = local.appconf_config.label
}

module "subnet_config" {
  source      = "../Modules/subnetConfigs"
  environment = local.global_settings.tags.Environment
}

resource "azurerm_api_management" "apim" {
  name                 = local.apim_name
  location             = local.global_settings.location
  resource_group_name  = local.global_settings.resource_group_name
  publisher_name       = data.env_var.publisher_name.value
  publisher_email      = "abs-cc@eagle.com"
  sku_name             = var.apim_sku_name
  tags                 = local.global_settings.tags
  virtual_network_type = "External"
  public_ip_address_id = azurerm_public_ip.apim_public_ip.id

  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim_subnet.id
  }

  depends_on = [azurerm_subnet.apim_subnet]
}

resource "azurerm_api_management_policy" "apim_policy" {
  api_management_id = azurerm_api_management.apim.id
  xml_content       = local.apim-policy-xml-content

  depends_on = [azurerm_api_management.apim]
}

resource "azurerm_subnet" "apim_subnet" {
  resource_group_name  = local.global_settings.resource_group_name
  name                 = module.subnet_config.apim_subnet_config.name
  address_prefixes     = [module.subnet_config.apim_subnet_config.address_prefix]
  virtual_network_name = module.get_shared_vnet_name.value
  service_endpoints    = module.subnet_config.apim_subnet_config.service_endpoints

  depends_on = [
    module.get_shared_vnet_name,
    azurerm_network_security_group.apim_ns_group
  ]
}

resource "azurerm_public_ip" "apim_public_ip" {
  name                    = "apim-public-ip"
  location                = local.global_settings.location
  resource_group_name     = local.global_settings.resource_group_name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
  sku                     = "Standard"
  domain_name_label       = local.apim_public_ip_params.domain_name_label
}

resource "azurerm_network_security_group" "apim_ns_group" {
  name                 = "apim-ns-group"
  location             = local.global_settings.location
  resource_group_name  = local.global_settings.resource_group_name

  security_rule {
    name                       = "AllowTagHTTPSInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }
  security_rule {
    name                       = "AllowTagCustom3443Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_to_ns_group" {
  subnet_id                 = azurerm_subnet.apim_subnet.id
  network_security_group_id = azurerm_network_security_group.apim_ns_group.id

  depends_on = [
    azurerm_subnet.apim_subnet,
    azurerm_network_security_group.apim_ns_group
  ]
}

resource "azurerm_api_management_product" "open_api_documentation" {
  product_id            = "open-api-documentation-product"
  api_management_name   = azurerm_api_management.apim.name
  resource_group_name   = local.global_settings.resource_group_name
  display_name          = "Open API documentation"
  subscription_required = false
  approval_required     = false
  published             = true

  depends_on = [azurerm_api_management.apim]
}

module "save_apim_name" {
  source         = "../../SharedModules/appConfigKey"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.apim_name_key
  label          = local.appconf_config.label
  value          = azurerm_api_management.apim.name

  depends_on = [azurerm_api_management.apim]
}

module "save_apim_subnet_id" {
  source         = "../../SharedModules/appConfigKey"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.apim_subnet_id_key
  label          = local.appconf_config.label
  value          = azurerm_api_management.apim.id

  depends_on = [azurerm_api_management.apim]
}