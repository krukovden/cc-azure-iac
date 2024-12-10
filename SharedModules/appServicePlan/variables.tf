variable "name" {
  description = "App Service Plan Name"
  type        = string
}
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "rg-mdf-us-dev"
}
variable "location" {
  description = "Azure location"
  type        = string
  default     = "South Central US"
}
variable "os_type" {
  type    = string
  default = "Linux"
}
variable "sku_name" {
  type    = string
  default = "B2"
}
variable "per_site_scaling_enabled" {
  type    = bool
  default = false
}
variable "zone_balancing_enabled" {
  type    = bool
  default = false
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "worker_count" {
  type    = number
  default = 3
}
variable "maximum_elastic_worker_count" {
  type    = number
  default = 6
}
