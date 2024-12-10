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
variable "func_name" {
  description = "Function App Name"
  type        = string
  default     = ""
}
variable "func_storage_acc_name" {
  description = "Azure Storage Account for Function App"
  type        = string
  default     = ""
}
variable "func_storage_cont_name" {
  description = "Azure Storage Account for Function App"
  type        = string
  default     = ""
}
variable "func_asp_name" {
  description = "App Service Plan Name/ID"
  type        = string
  default     = ""
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
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
variable "container_access_type" {
  description = "Blob Storage SAS Url"
  type        = string
  default     = "private"
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
  type    = number
  default = 3
}
variable "https_only" {
  description = "Blob Storage SAS Url"
  type        = bool
  default     = true
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
variable "use_dotnet_isolated_runtime" {
  description = "Blob Storage SAS Url"
  type        = bool
  default     = true
}
variable "dotnet_version" {
  description = "Blob Storage SAS Url"
  type        = string
  default     = "7.0"
}
variable "app_settings" {
  description = "Function App Settings"
  type        = map(string)
}

variable "allowed_origins" {
  type    = list(string)
  default = ["https://purple-wave-0f8bd7210.3.azurestaticapps.net", "http://localhost:3000"]
}
variable "health_check_path" {
  description = "Health Check Path"
  type        = string
  default     = "/api/health"
}
variable "identity_type" {
  type    = string
  default = "UserAssigned"
}
variable "identity_ids" {
  type    = list(string)
  default = ["/subscriptions/bfb76258-b615-452e-96ce-58a34407b006/resourcegroups/rg-mdf-dev-core/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-mdf-graphql-dev"]
}
variable "key_vault_reference_identity_id" {
  type    = string
  default = "/subscriptions/bfb76258-b615-452e-96ce-58a34407b006/resourcegroups/rg-mdf-dev-core/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-mdf-graphql-dev"
}
