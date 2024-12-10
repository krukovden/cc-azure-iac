variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "private_connection_name" {
  type = string
}
variable "private_connection_id" {
  type = string
}
variable "is_manual_connection" {
  type    = bool
  default = false
}
variable "subresource_names" {
  type = list(string)
}
variable "dns_group_name" {
  type = string
}
variable "private_dns_zone_ids" {
  type = list(string)
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
