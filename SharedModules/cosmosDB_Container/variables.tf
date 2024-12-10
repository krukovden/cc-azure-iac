variable "rg_name" {
  type    = string
  default = "rg-mdf-us-dev"
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
variable "partition_key_version" {
  type    = number
  default = 1
}
variable "indexing_mode" {
  type    = string
  default = "consistent"
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
