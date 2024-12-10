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
variable "offer_type" {
  type    = string
  default = "Standard"
}
variable "kind" {
  type    = string
  default = "GlobalDocumentDB"
}
variable "default_identity_type" {
  type    = string
  default = "FirstPartyIdentity"
}
variable "enable_automatic_failover" {
  type    = bool
  default = false
}
variable "public_network_access_enabled" {
  type    = bool
  default = true
}
variable "capability_name" {
  type    = string
  default = "EnableServerless"
}
variable "consistency_level" {
  type    = string
  default = "BoundedStaleness"
}
variable "partition_key_path" {
  type    = string
  default = "/pk"
}
variable "partition_key_version" {
  type    = number
  default = 1
}
variable "max_throughput" {
  type = number
}
variable "failover_priority" {
  type    = number
  default = 0
}
variable "max_interval_in_seconds" {
  type    = number
  default = 300
}
variable "max_staleness_prefix" {
  type    = number
  default = 100000
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "indexing_mode" {
  type    = string
  default = "consistent"
}
variable "included_path" {
  type    = string
  default = "/*"
}
variable "unique_key_path" {
  type    = list(string)
  default = ["/path"]
}

variable "backup_type" {
  type    = string
  default = "Continuous"
}

variable "prevent_destroy" {
  type    = bool
  default = true
}
