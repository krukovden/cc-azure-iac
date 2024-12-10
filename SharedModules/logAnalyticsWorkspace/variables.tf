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
variable "workspace_name" {
  description = "Log Analytics Workspace Name"
  type        = string
  default     = ""
}
variable "sku" {
  description = "Log Analytics Workspace SKU"
  type        = string
  default     = "PerGB2018"
}
variable "retention" {
  description = "Log Analytics Workspace Retention in Days"
  type        = number
  default     = 30
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
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}