variable "env_vars_names" {
  default = {
    rabbit_url               = "TF_RMQ_URL"
    rabbit_connection_string = "TF_RMQ_CONNECTION_STRING"
    rabbit_pass              = "TF_RMQ_PASS"
    rabbit_user              = "TF_RMQ_USER"
    rabbit_vhost             = "TF_RMQ_VHOST"
    rabbit_port              = "TF_RMQ_PORT"
  }
}

variable "client_id" {
  type = string
}

variable "skip_if_onboarding_ui"{
  type = bool
  default = false
}

variable "erp_import_reports_request_exchange_name" {
  type = string
  default = "et.cccp.er.request"
}