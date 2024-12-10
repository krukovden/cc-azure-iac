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
variable "appconfig_name" {
  description = "App Config Name"
  type        = string
  default     = ""
}
variable "sku" {
  description = "SKU Tier"
  type        = string
  default     = "standard"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "scope" {
  description = "App Config Role Assignment Scope"
  type        = string
  default     = ""
}
variable "role_definition_name" {
  description = "App Config Role Assignment Name"
  type        = string
  default     = ""
}
variable "principal_id" {
  description = "App Config Role Assignment Principal ID"
  type        = string
  default     = ""
}
# variable "identity_client_id" {
#   description = "Key Vault ID"
#   type        = string
#   default     = "0a666bd4-4df1-45e5-81b4-dea91c423adb"
# }
variable "local_auth_enabled" {
  description = "Enable local authentication"
  type        = bool
  default     = true
}
variable "purge_protection_enabled" {
  description = "Enable purge protection"
  type        = bool
  default     = true
}
