variable "rg_name" {
  description = "Resource Group Name"
  type        = string
  default     = ""
}
variable "location" {
  description = "Azure location"
  type        = string
  default     = "South Central US"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "func_storage_acc_name" {
  description = "Azure Storage Account for Function App"
  type        = string
  default     = ""
}
variable "account_tier" {
  description = "Blob Storage SAS Url"
  type        = string
  default     = "Standard"
}
variable "account_replication_type" {
  description = "Blob Storage SAS Url"
  type        = string
  default     = "GRS"
}
variable "min_tls_version" {
  description = "Blob Storage SAS Url"
  type        = string
  default     = "TLS1_2"
}
variable "versioning_enabled" {
  type        = bool
  default     = true
}
variable "queue_logging_delete" {
  type        = bool
  default     = true
}
variable "queue_logging_read" {
  type        = bool
  default     = true
}
variable "queue_logging_write" {
  type        = bool
  default     = true
}
variable "queue_logging_version" {
  type        = string
  default     = "1.0"
}
variable "retention_policy_days" {
  type        = number
  default     = 30
}
variable "default_action" {
  type        = string
  default     = "Deny"
}
variable "bypass" {
  type    = list(string)
  default = ["AzureServices", "Logging", "Metrics"]
}
variable "storage_virtual_network_subnet_ids" {
  description = "VNET Subnet ID"
  type        = list(string)
}
variable "service_plan_id" {
  type        = string
  default     = "asp-mdf-dev-core"
}
variable "func_asp_name" {
  description = "App Service Plan Name/ID"
  type        = string
  default     = ""
}
variable "os_type" {
  description = "Blob Storage SAS Url"
  type        = string
  default     = "Linux"
}
variable "sku_name" {
  description = "Blob Storage SAS Url"
  type        = string
  default     = "B2"
}
variable "worker_count" {
  type        = number
  default     = 3
}
variable "func_name" {
  description = "Function App Name"
  type        = string
  default     = ""
}
variable "https_only" {
  description = "Blob Storage SAS Url"
  type        = bool
  default     = true
}
variable "key_vault_reference_identity_id" {
  type    = string
  default = "/subscriptions/bfb76258-b615-452e-96ce-58a34407b006/resourcegroups/rg-mdf-dev-core/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-mdf-api-dev"
}
variable "function_virtual_network_subnet_id" {
  description = "VNET Subnet ID"
  type        = string
}
variable "ftps_state" {
  description = "Blob Storage SAS Url"
  type        = string
  default     = "FtpsOnly"
}
variable "always_on" {
  description = "Blob Storage SAS Url"
  type        = bool
  default     = true
}
variable "python_version" {
  description = "Python Version"
  type        = string
  default     = "3.9"
}
variable "identity_type" {
  type    = string
  default = "UserAssigned"
}
variable "identity_ids" {
  type = list(string)
}
variable "health_check_path" {
  description = "Health Check Path"
  type        = string
  default     = "/api/health"
}
variable "app_settings" {
  description = "Function App Settings"
  type        = map(string)
}
