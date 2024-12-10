variable "appconfig_name" {
  description = "App Config ID"
  type        = string
  default     = ""
}
variable "rg_name" {
  description = "Resource Group associated to App Config"
  type        = string
  default     = "rg-mdf-dev-core"
}
variable "key" {
  description = "App Config Key"
  type        = string
  default     = ""
}
variable "label" {
  description = "App Config Label"
  type        = string
  default     = "dev"
}
variable "value" {
  description = "App Config Value"
  type        = string
  default     = ""
}
variable "type" {
  description = "App Config Type"
  type        = string
  default     = "kv"
}
