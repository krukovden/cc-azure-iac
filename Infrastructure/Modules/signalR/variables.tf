variable "service_name" {
  description = "SignalR Service Name"
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
variable "sku_name" {
  description = "Sku name to whitch service is assigned."
  type        = string
}
variable "public_network_access_enabled" {
  description = "Public accessability to the service. Should be set to true to be able deploy the code."
  type        = bool
  default     = true
}
variable "service_mode" {
  description = "Service mode"
  type        = string
  default     = "Serverless"
}
variable "connection_timeout_in_seconds" {
  description = "Serverles connection timeout in seconds"
  type        = number
  default     = 30
}
variable "capacity" {
  description = "Capacity"
  type        = number
  default     = 1
}
variable "log_analytics_workspace_id" {
  type = string
  default = ""
}
variable "connectivity_logs_enabled" {
  type = bool
  default = true
}