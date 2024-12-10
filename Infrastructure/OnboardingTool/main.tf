terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    env = {
      source  = "tcarreira/env"
      version = "~> 0.2.0"
    }
  }
  required_version = ">= 1.1.0"
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = local.global_settings.resource_group_name
  location = local.global_settings.location
}

resource "azurerm_static_web_app" "onboardingtool_static_site" {
  name                = var.appconf_config.app_name
  resource_group_name = local.global_settings.resource_group_name
  location            = var.appconf_config.location
  sku_tier            = var.appconf_config.sku_tier
  sku_size            = var.appconf_config.sku_size
  tags                = local.tags

  depends_on = [azurerm_resource_group.default]
}

resource "azurerm_static_web_app_custom_domain" "custom_domain" {
  static_web_app_id = azurerm_static_web_app.onboardingtool_static_site.id
  domain_name       = local.web_app.domain_name
  validation_type   = var.web_app_config.validation_type

   depends_on = [azurerm_static_web_app.onboardingtool_static_site]
}