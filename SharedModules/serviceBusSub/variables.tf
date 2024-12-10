variable "topic_id" {
  type = string
}
variable "servicebus_sub" {
  type = string
}
variable "max_delivery_count" {
  type    = number
  default = 10
}
