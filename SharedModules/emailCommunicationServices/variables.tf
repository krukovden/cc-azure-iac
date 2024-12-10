variable "name" {
  type = string
}
variable "resource_group_name" {
  type    = string
  default = "rg-mdf-dev-core"
}
variable "data_location" {
  type    = string
  default = "United States"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
