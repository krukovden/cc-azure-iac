variable "name" {
  type = string
}
variable "location" {
  type    = string
  default = "South Central US"
}
variable "resource_group_name" {
  type    = string
  default = "rg-mdf-dev-core"
}
variable "capacity" {
  type    = number
  default = 1
}
variable "family" {
  type    = string
  default = "P"
}
variable "sku_name" {
  type    = string
  default = "Premium"
}
variable "enable_non_ssl_port" {
  type    = bool
  default = false
}
variable "minimum_tls_version" {
  type    = string
  default = "1.2"
}
variable "shard_count" {
  type    = number
  default = 1
}
variable "public_network_access_enabled" {
  type    = bool
  default = true
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
