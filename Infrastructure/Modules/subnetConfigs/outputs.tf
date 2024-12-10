output "shared_functions_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-cp-func-shared", var.environment)
    address_prefix    = "10.0.1.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]

    delegation_name            = "function delegation"
    service_delegation_name    = "Microsoft.Web/serverFarms"
    service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
}

output "endpoint_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-cp-endpoint", var.environment)
    address_prefix    = "10.0.2.0/24"
    service_endpoints = []
  }
}

output "veson_function_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-veson-function", var.environment)
    address_prefix    = "10.0.3.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]

    delegation_name            = "function delegation"
    service_delegation_name    = "Microsoft.Web/serverFarms"
    service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
}

output "ecdis_function_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-ecdis-function", var.environment)
    address_prefix    = "10.0.10.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]

    delegation_name            = "function delegation"
    service_delegation_name    = "Microsoft.Web/serverFarms"
    service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
}

output "port_info_function_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-port-info-function", var.environment)
    address_prefix    = "10.0.12.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]

    delegation_name            = "function delegation"
    service_delegation_name    = "Microsoft.Web/serverFarms"
    service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
}

output "apim_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-cp-apim", var.environment)
    address_prefix    = "10.0.7.0/24"
    service_endpoints = ["Microsoft.Web"]
  }
}

output "disco_function_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-disco-function", var.environment)
    address_prefix    = "10.0.13.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]

    delegation_name            = "function delegation"
    service_delegation_name    = "Microsoft.Web/serverFarms"
    service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
}

output "erp_function_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-erp-function", var.environment)
    address_prefix    = "10.0.14.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]

    delegation_name            = "function delegation"
    service_delegation_name    = "Microsoft.Web/serverFarms"
    service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
}

output "swagger_ui_function_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-swagger-ui-function", var.environment)
    address_prefix    = "10.0.15.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]

    delegation_name            = "function delegation"
    service_delegation_name    = "Microsoft.Web/serverFarms"
    service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
  }

  output "test_client_function_subnet_config" {
  value = {
    name              = format("%s-%s", "snet-cc-test-client-function", var.environment)
    address_prefix    = "10.0.16.0/24"
    service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]

    delegation_name            = "function delegation"
    service_delegation_name    = "Microsoft.Web/serverFarms"
    service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
}
