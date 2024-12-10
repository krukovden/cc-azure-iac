variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "address_space" {
  type = list(string)
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
