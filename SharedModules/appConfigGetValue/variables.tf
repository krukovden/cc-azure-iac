# variable "configuration_store_id" {
#   description = "App Config ID"
#   type        = string
#   default     = "/subscriptions/bfb76258-b615-452e-96ce-58a34407b006/resourceGroups/rg-mdf-dev-core/providers/Microsoft.AppConfiguration/configurationStores/appconf-mdf-dev-core"
# }
variable "appconfig_name" {
  description = "App Config Name"
  type        = string
  default     = ""
}
variable "rg_name" {
  description = "App Config Resource Group"
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
  default     = ""
}
