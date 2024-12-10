variable "kvname" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "object_id" {
  type = string
  description = "The User, Group, or Principal Object ID"
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
variable "secret_permissions" {
  type        = list(string)
  description = " List of secret permissions for the user group, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set."
  default     = []
}
# variable "application_id" {
#   type = string
#   description = "The Application ID"
# }
# variable "tenant_id" {
#   type        = string
#   description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
# }