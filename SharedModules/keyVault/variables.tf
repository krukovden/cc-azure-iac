variable "kvname" {
  type = string
}
variable "location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "sku" {
  description = "The Name of the SKU used for this Key Vault. Possible values are Standard and Premium."
  default     = "standard"
}
variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}
variable "enabled_for_disk_encryption" {
  type    = bool
  default = true
}
variable "soft_delete_retention_days" {
  type    = number
  default = 30
}
variable "purge_protection_enabled" {
  type    = bool
  default = true
}
variable "public_network_access_enabled" {
  type    = bool
  default = true
}
variable "network_acl_list" {
  type    = any
  default = []
}
variable "bypass" {
  type    = string
  default = "AzureServices"
}
variable "default_action" {
  description = "Allow or Deny AzureServices"
  type        = string
  default     = "Deny"
}
variable "ip_rules" {
  type    = list(string)
  default = []
}
variable "virtual_network_subnet_ids" {
  type    = set(string)
  default = []
}
variable "secret_permissions" {
  type        = list(string)
  description = " List of secret permissions for the user group, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set."
  default     = []
}
variable "certificate_permissions" {
  type        = list(string)
  description = "List of certificate permissions, must be one or more from the following: create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, setissuers and update."
  default     = []
}
variable "key_permissions" {
  type        = list(string)
  description = "List of key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey"
  default     = []
}
variable "access_policies" {
  default = {}
}
variable "secret_name" {
  type = string
}
variable "secret_value" {
  type    = string
  default = "default secret"
}
variable "content_type" {
  type    = string
  default = "password"
}
variable "expiration_date" {
  type    = string
  default = "2030-12-31T00:00:00Z"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}

