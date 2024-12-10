variable "rg_name" {
  description = "Resource Group Name"
  type        = string
  default     = "rg-mdf-us-dev"
}
variable "location" {
  description = "Azure location"
  type        = string
  default     = "South Central US"
}
variable "func_name" {
  description = "Function App Name"
  type        = string
  default     = "not needed"
}
variable "func_storage_acc_name" {
  description = "Azure Storage Account for Function App"
  type        = string
  default     = "not needed"
}
variable "func_storage_cont_name" {
  description = "Azure Storage Account for Function App"
  type        = string
  default     = "not needed"
}
variable "func_asp_name" {
  description = "App Service Plan Name/ID"
  type        = string
  default     = "not needed"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "account_tier" {
  type        = string
  default     = "Standard"
}
variable "account_replication_type" {
  type        = string
  default     = "GRS"
}
variable "min_tls_version" {
  type        = string
  default     = "TLS1_2"
}
variable "container_access_type" {
  type        = string
  default     = "private"
}
variable "os_type" {
  type        = string
  default     = "Linux"
}
variable "sku_name" {
  type        = string
  default     = "B2"
}
variable "worker_count" {
  type        = number
  default     = 3
}
variable "https_only" {
  type        = bool
  default     = true
}
variable "key_vault_reference_identity_id" {
  type    = string
  default = "/subscriptions/bfb76258-b615-452e-96ce-58a34407b006/resourcegroups/rg-mdf-dev-core/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-mdf-api-dev"
}
variable "ftps_state" {
  type        = string
  default     = "FtpsOnly"
}
variable "always_on" {
  type        = bool
  default     = true
}
variable "use_dotnet_isolated_runtime" {
  type        = bool
  default     = true
}
variable "dotnet_version" {
  type        = string
  default     = "7.0"
}
variable "app_settings" {
  description = "Function App Settings"
  type        = map(string)
}
variable "identity_type" {
  type    = string
  default = "UserAssigned"
}
variable "identity_ids" {
  type    = list(string)
  default = [ "/subscriptions/bfb76258-b615-452e-96ce-58a34407b006/resourcegroups/rg-mdf-dev-core/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-mdf-api-dev" ]
}
variable "health_check_path" {
  description = "Health Check Path"
  type        = string
  default     = "/api/health"
}
