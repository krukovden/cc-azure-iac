variable "location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "servicebus_namespace" {
  type = string
}
variable "sku" {
  type    = string
  default = "Standard"
}
variable "local_auth_enabled" {
  type    = bool
  default = true #false
}
variable "public_network_access_enabled" {
  type    = bool
  default = true
}
variable "minimum_tls_version" {
  type    = string
  default = "1.2"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
