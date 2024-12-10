variable "location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "cosmosdb_name" {
  type = string
}
variable "cosmosdbacc_name" {
  type = string
}
variable "cosmosdb_container" {
  type = string
}
variable "partition_key_path" {
  type = string
}
variable "max_throughput" {
  type = number
}
variable "offer_type" {
  type    = string
  default = "Standard"
}
variable "kind" {
  type    = string
  default = "GlobalDocumentDB"
}
variable "enable_automatic_failover" {
  type    = bool
  default = false
}
variable "capabilities_name" {
  type    = string
  default = "EnableServerless"
}
variable "failover_priority" {
  type    = number
  default = 0
}
variable "consistency_level" {
  type    = string
  default = "BoundedStaleness"
}
variable "max_interval_in_seconds" {
  type    = number
  default = 300
}
variable "max_staleness_prefix" {
  type    = number
  default = 100000
}
variable "indexing_mode" {
  type    = string
  default = "consistent"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "included_paths" {
  type    = set(string)
  default = ["/*"]
}
variable "excluded_paths" {
  type    = set(string)
  default = ["/\"_etag\"/?"]
}
variable "composite_indexes" {
  type    = any
  default = []
}
