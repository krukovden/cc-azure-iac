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
variable "type" {
  description = "App Config Type"
  type        = string
  default     = "vault"
}
variable "vault_key_reference" {
  description = "App Config Vault Key Reference when Type = Vault"
  type        = string
  default     = ""
}
