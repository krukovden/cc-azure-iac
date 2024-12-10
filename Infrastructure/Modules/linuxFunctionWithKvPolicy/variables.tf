variable "funciton_name" {
  description = "Function App Name"
  type        = string
}
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}
variable "location" {
  description = "Azure location"
  type        = string
}
variable "service_plan_id" {
  description = "ID of the service plan to which the funciton is assigned."
  type        = string
}
variable "storage_account_name" {
  description = "Name of the storage accout to which the funciton is assigned."
  type        = string
}
variable "storage_account_primary_access_key" {
  description = "Primary key of the storage accout to which the funciton is assigned."
  type        = string
}
variable "public_network_access_enabled" {
  description = "Public accessability to the functions. Should be set to true to be able deploy the code."
  type        = bool
  default     = true
}
variable "subnet_id" {
  description = "Subnet id to which the funciton is assigned."
  type        = string
  # 10-12-2024 Added the default value null to update service plans.
  default     = null
}
variable "dotnet_version" {
  description = ".NET version is used in funciton."
  type        = string
  default     = "v8.0"
}
variable "app_settings" {
  description = "Application settings, storing evironment variables. Can be found in 'Configuration' tab in 'Settings' section on Azure portal."
  type        = map(string)
}
variable "identity_type" {
  description = "Type of Identity is assigned to the function (SystemAssigned|UserAssigned|SystemAssigned, UserAssigned)"
  type        = string
  default     = "SystemAssigned"
}
variable "identity_ids" {
  description = "Identity IDs assigned to this function. Available for casese when identity_type is set to 'UserAssigned' or 'SystemAssigned, UserAssigned'"
  type        = list(string)
  default     = []
}
variable "key_vault_id" {
  description = "Key vault ID for which permissions should be granted."
  type        = string
}
variable "tenant_id" {
  description = "Tennant id of account is used to deploy. Can be found as 'tenant_id' values from following source: 'data \"azurerm_client_config\" \"current\" {}'."
  type        = string
}
variable "certificate_permissions" {
  description = "Funciton's certificate permissions in key vault"
  type        = list(string)
  default     = ["Get", "GetIssuers", "List", "ListIssuers"]
}
variable "key_permissions" {
  description = "Funciton's keys permissions in key vault"
  type        = list(string)
  default     = ["Decrypt", "Encrypt", "Get", "List"]
}
variable "secret_permissions" {
  description = "Funciton's secret permissions in key vault"
  type        = list(string)
  default     = ["Get", "List"]
}

variable "use_dotnet_isolated_runtime" {
  description = "Use isolated runtime"
  type        = bool
  default     = true
}
variable "logs_quota_mb" {
  description = "Max volume to store stream logs"
  type        = number
  default     = 50
}
variable "logs_retention_period_days" {
  description = "Duration of stream logs storing"
  type        = number
  default     = 1
}
variable "vnet_route_all_enabled" {
  description = "Use routing inside virtual network"
  type        = bool
  default     = true
}
variable "tags" {
  description = "Tags of the function"
  type        = map(string)
  default     = {}
}
variable "cors_allowed_origins" {
  description = "CORS allowed origins"
  type        = list(string)
  default     = ["https://portal.azure.com"]
}
variable "cors_support_credentials" {
  description = "Are CORS creadentials supported"
  type        = bool
  default     = false
}
variable "func_connection_strings" {
  description = "List of connection strings"
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}

variable "log_analytics_workspace_id" {
  type = string
  default = ""
}

variable "func_ip_restrictions" {
  description = "List of network restriction rules"
  type = list(object({
    virtual_network_subnet_id = string
    action                    = string
    priority                  = number
    name                      = string
  }))
  default = []
}