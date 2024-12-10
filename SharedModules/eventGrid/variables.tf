variable "rg_name" {
  type    = string
  default = "rg-us-mdf-dev"
}
variable "location" {
  type    = string
  default = "South Central US"
}
variable "system_topic_name" {
  type    = string
  default = "egst-mdf-dev-core"
}
variable "topic_type" {
  type    = string
  default = "Microsoft.Storage.StorageAccounts"
}
variable "event_subscription_name" {
  type    = string
  default = "evgs-mdf-dev-core"
}
variable "resource_group_name" {
  type    = string
  default = "rg-mdf-dev-core"
}
variable "sb_topic_endpoint_id" {
  type    = string
  default = ""
}
variable "included_event_types" {
  type    = list(string)
  default = ["Microsoft.Storage.BlobCreated"]
}
variable "filter_key" {
  type    = string
  default = "data.url"
}
variable "filter_value" {
  type    = list(string)
  default = ["/raw/"]
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "source_arm_resource_id" {
  type = string
}
variable "identity_type" {
  type    = string
  default = "UserAssigned"
}
variable "identity_ids" {
  type = list(string)
}
