variable "env_vars_names" {
  default = {
    rabbit_url               = "TF_RMQ_URL"
    rabbit_connection_string = "TF_RMQ_CONNECTION_STRING"
    rabbit_pass              = "TF_RMQ_PASS"
    rabbit_user              = "TF_RMQ_USER"
    rabbit_vhost             = "TF_RMQ_VHOST"
    rabbit_port              = "TF_RMQ_PORT"
    database_username = "TF_DATABASE_USERNAME"
    database_password = "TF_DATABASE_PASSWORD"
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

variable REGION_SUFFIX {
  description = "eus (East US), wus (West US), eu (Europe) or ..."
  type = string
}

variable REGION_CODE {
  description = "europe, southcentralus, eastus or ..."
  type = string
}

variable ENV {
  description = "DEV, QA, STG or PRD"
  type        = string
}

variable "global_settings_template" {
  default = {   
    resource_group_name      = "rg-%s-commoncore-001"
    data_resource_group_name = "rg-%s-commoncore-001-data"   
  }
}

variable "database_name" {
  type    = string
  default = "citus"
}