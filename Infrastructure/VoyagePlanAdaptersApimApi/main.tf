terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
    env = {
      source  = "tcarreira/env"
      version = "~> 0.2.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

module "get_apim_name" {
  source         = "../../SharedModules/appConfigGetValue"
  appconfig_name = local.appconf_config.name
  rg_name        = local.global_settings.resource_group_name
  key            = local.appconf_config.apim_name_key
  label          = local.appconf_config.label
}

data "azurerm_linux_function_app" "voyageplan_linux_function_app" {
  name                = local.voyageplan_func_name
  resource_group_name = local.global_settings.resource_group_name
}

data "azurerm_windows_function_app" "voyageplan_windows_function_app" {
  name                = local.voyageplan_func_name
  resource_group_name = local.global_settings.resource_group_name
}

resource "null_resource" "always_run" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

resource "azurerm_api_management_api" "voyageplan_apim_api" {
  name                  = var.voyageplan_apim_api_params.name
  resource_group_name   = local.global_settings.resource_group_name
  api_management_name   = local.apim_name
  subscription_required = false
  revision              = var.voyageplan_apim_api_params.revision
  display_name          = var.voyageplan_apim_api_params.displayName
  path                  = var.voyageplan_apim_api_params.path
  protocols             = var.voyageplan_apim_api_params.protocols
  description           = var.voyageplan_apim_api_params.description

  import {
    content_format = "openapi+json-link"
    content_value  = local.voyageplan_func_openapi_document_url
  }

  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }
}

resource "azurerm_api_management_product_api" "voyageplan_product_api" {
  api_name            = azurerm_api_management_api.voyageplan_apim_api.name
  product_id          = "open-api-documentation-product"
  api_management_name = local.apim_name
  resource_group_name = local.global_settings.resource_group_name

  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }  
}

resource "azurerm_api_management_api_policy" "voyageplan_apim_api_policy" {
  api_name            = azurerm_api_management_product_api.voyageplan_product_api.api_name
  api_management_name = local.apim_name
  resource_group_name = local.global_settings.resource_group_name
  xml_content         = local.voyageplan-api-policy-xml-content

  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }  
}