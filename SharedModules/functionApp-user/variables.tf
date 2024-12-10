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
variable "container_name" {
  description = "Cosmos Container Name"
  type        = string
  default     = "not needed"
}
variable "settings_container_name" {
  description = "Cosmos Settings Container Name"
  type        = string
  default     = "not needed"
}
variable "db_name" {
  description = "Cosmos DB Name"
  type        = string
  default     = "not needed"
}
variable "db_connection_string" {
  description = "Cosmos DB Connection String"
  type        = string
  default     = "not needed"
}
variable "st_connection_string" {
  description = "Cosmos DB Connection String"
  type        = string
  default     = "not needed"
}
variable "sas_url" {
  description = "Blob Storage SAS Url"
  type        = string
  default     = "not needed"
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
  default     = false
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
variable "functions_worker_runtime" {
  description = "Function Worker Runtime Langauge"
  type        = string
  default     = "dotnet-isolated"
}
variable "instrumentation_key" {
  description = "Application Insights Instrumentation Key"
  type        = string
  default     = "not needed"
}
variable "appi_connection_string" {
  description = "Application Insights Connection String"
  type        = string
  default     = "not needed"
}
variable "blob_connection_string" {
  description = "Storage Account Blob Connection String"
  type        = string
  default     = "not needed"
}
variable "transform_container_name" {
  description = "Transform Storage Account Container Name"
  type        = string
  default     = "not needed"
}
variable "service_bus_connection_string" {
  description = "Service Bus Connection String"
  type        = string
  default     = "not needed"
}
variable "transform_mapping_configuration" {
  description = "MDF Transform Mapping Configuration"
  type        = string
  default     = "not needed"
}
variable "transform_output_topic" {
  description = "Service Bus Transform Output Topic Name"
  type        = string
  default     = "not needed"
}
variable "transform_input_topic" {
  description = "Service Bus Transform Input Topic Name"
  type        = string
  default     = "not needed"
}
variable "transform_input_topic_subscription" {
  description = "Service Bus Transform Input Topic Subscription Name"
  type        = string
  default     = "not needed"
}
variable "alert_output_topic" {
  description = "Service Bus Alert Topic Name"
  type        = string
  default     = "not needed"
}
variable "ad_tenant" {
  description = ""
  type        = string
  default     = "not needed"
}
variable "ad_initial_password" {
  description = ""
  type        = string
  default     = "not needed"
}
variable "ad_redirect_url" {
  description = ""
  type        = string
  default     = "not needed"
}
variable "smtp_server" {
  description = ""
  type        = string
  default     = "not needed"
}
variable "smtp_port" {
  description = ""
  type        = string
  default     = "not needed"
}
variable "smtp_username" {
  description = ""
  type        = string
  default     = "not needed"
}
variable "smtp_password" {
  description = ""
  type        = string
  default     = "not needed"
}
variable "smtp_enable_ssl" {
  description = ""
  type        = string
  default     = "not needed"
}
variable "health_check_path" {
  description = "Health Check Path"
  type        = string
  default     = "/api/health"
}
