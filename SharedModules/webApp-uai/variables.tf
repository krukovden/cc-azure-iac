variable "rg_name" {
  type = string
}
variable "location" {
  type = string
}
variable "app_name" {
  type = string
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "identity_type" {
  type    = string
  default = "UserAssigned"
}
variable "identity_ids" {
  type    = list(string)
  default = [ "/subscriptions/bfb76258-b615-452e-96ce-58a34407b006/resourcegroups/rg-mdf-dev-core/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-mdf-app-dev" ]
}
