variable "global_settings_template" {
  default = {
    location                 = ""
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"
    dotnet_version           = "8.0"

    tags = {
      Project     = "CommonCore",
      Environment = "%s",
      CreatedBy   = "Terraform"
    }
  }
}

variable "appconf_config_template" {
  default = {
    name                  = "appconf-cc-cp-%s"
    label                 = "%s"
    identity_type         = "SystemAssigned"
    postgres_ip_key       = "cc:cp:postgresql:ip:%s"
    nsg_name              = "cc:cp:nsg:name:%s"
    vnet_name             = "cc:cp:vnet:name:%s"
    apim_subnet_id_key    = "cc:cp:apim:subnet:id:%s"
    keyvault_id           = "cc:cp:kv:id:%s"
    keyvault_name         = "cc:cp:kv:name:%s"
    apim_name_key         = "cc:cp:apim:name:%s"
    public_network_access = "Enabled"
  }
}

variable "env_vars_names" {
  default = {
    publisher_name    = "GH_PUBLISHER_NAME"
    apim_tenant_id    = "TF_APIM_TENANT"
    database_username = "TF_DATABASE_USERNAME"
    database_password = "TF_DATABASE_PASSWORD"
  }
}

variable "apim_name_template" {
  type = string
  default = "apim-abs-cc-%s"
}

variable "apim_sku_name" {
  type    = string
  default = "Developer_1"
}

variable "apim_request_timeout_seconds" {
  type = number
  default = 240
}

variable "apim_public_ip_params_template" {
  default = {
    domain_name_label = "abs-cc-cp-%s-domain-name"
    fqdn              = "abs.cc.cp.%s.cloudapp.azure.com"
  }
}

variable "database_name" {
  type    = string
  default = "citus"
}

variable "CLIENT_ONBOARDING_ID" {
  description = "Flag to apply onboarding tool settings"
  type    = string
  default = ""

}

variable "APPLY_ONBOARDING_TOOL_SETTINGS" {
  description = "Flag to apply onboarding tool settings"
  type        = bool
  default     = false
}

variable ENV {
  description = "DEV, QA, STG or PRD"
  type        = string
}

variable REGION_SUFFIX {
  description = "eus (East US), wus (West US), eu (Europe) or ..."
  type = string
}

variable REGION_CODE {
  description = "europe, southcentralus, eastus or ..."
  type = string
}