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
variable "user_assigned_name" {
  description = "App Config Name"
  type        = string
  default     = ""
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
