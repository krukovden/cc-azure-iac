variable "location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "apim_name" {
  type = string
}
variable "publisher_name" {
  type = string
}
variable "publisher_email" {
  type = string
}
variable "sku_name" {
  type = string
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "workspace_name" {
  description = "Log Analytics Workspace Name"
  type        = string
  default     = ""
}
variable "appi_name" {
  description = "Application Insights Name"
  type        = string
  default     = ""
}
variable "application_type" {
  description = "Application Insights Type"
  type        = string
  default     = "web"
}
variable "retention" {
  description = "Log Analytics Workspace Retention in Days"
  type        = number
  default     = 30
}
variable "apim_logger_name" {
  type        = string
}
variable "sku" {
  type        = string
}
variable "identity_type" {
  type    = string
  default = "UserAssigned"
}
variable "identity_ids" {
  type    = list(string)
  default = [ "/subscriptions/bfb76258-b615-452e-96ce-58a34407b006/resourcegroups/rg-mdf-dev-core/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-mdf-app-dev" ]
}

variable "min_api_version" {
  type        = string
  default     = "2019-12-01"
}
