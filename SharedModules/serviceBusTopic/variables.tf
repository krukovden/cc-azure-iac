variable "servicebus_topic" {
  type = string
}
variable "namespace_id" {
  type = string
}
variable "enable_partitioning" {
  type    = bool
  default = true
}
