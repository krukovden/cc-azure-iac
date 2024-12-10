variable "resource_group_name" {
  type    = string
  default = "rg-mdf-dev-core"
}
variable "api_management_name" {
  type = string
}
variable "api_management_logger_id" {
  type = string
}
variable "identifier" {
  type    = string
  default = "applicationinsights"
}
variable "sampling_percentage" {
  type    = number
  default = 100.0
}
variable "always_log_errors" {
  type    = bool
  default = true
}
variable "log_client_ip" {
  type    = bool
  default = true
}
variable "verbosity" {
  type    = string
  default = "verbose"
}
variable "http_correlation_protocol" {
  type    = string
  default = "W3C"
}
