variable "saccname" {
  type = string
}
variable "location" {
  type = string
}
variable "rgname" {
  type = string
}
variable "account_tier" {
  type    = string
  default = "Standard"
}
variable "account_replication_type" {
  type    = string
  default = "GRS"
}
variable "min_tls_version" {
  type    = string
  default = "TLS1_2"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "queue_version" {
  type    = string
  default = "1.0"
}
variable "queue_delete" {
  type    = bool
  default = true
}
variable "queue_read" {
  type    = bool
  default = true
}
variable "queue_write" {
  type    = bool
  default = true
}
variable "retention_policy_days" {
  type    = number
  default = 30
}
variable "versioning_enabled" {
  type    = bool
  default = false
}
variable "default_action" {
  type    = string
  default = "Deny"
}
variable "bypass" {
  type    = list(string)
  default = ["AzureServices", "Logging", "Metrics"]
}
# variable "storage_virtual_network_subnet_ids" {
#   type = list(string)
# }
variable "scontname" {
  type = string
}
variable "https_only" {
  type    = bool
  default = true
}
variable "container_access_type" {
  type    = string
  default = "private"
}
variable "sas_token_start" {
  type    = string
  default = "2023-09-01" # formatdate(YYYY-MM-DD, timestamp())
}
variable "sas_token_expiry" {
  type    = string
  default = "2030-12-31" # formatdate(YYYY-MM-DD, timeadd(timestamp(), "720h"))
}
variable "cache_control" {
  type    = string
  default = "max-age=5"
}
variable "content_disposition" {
  type    = string
  default = "inline"
}
variable "content_encoding" {
  type    = string
  default = "deflate"
}
variable "content_language" {
  type    = string
  default = "en-US"
}
variable "content_type" {
  type    = string
  default = "application/json"
}
variable "signed_version" {
  type    = string
  default = "2021-12-02"
}
variable "sftp_enabled" {
  type    = bool
  default = true
}
variable "is_hns_enabled" {
  type    = bool
  default = true
}
variable "data_lake_name" {
  type = string
}

variable "read" {
  type    = bool
  default = true
}

variable "write" {
  type    = bool
  default = true
}

variable "delete" {
  type    = bool
  default = true
}

variable "list" {
  type    = bool
  default = true
}

variable "add" {
  type    = bool
  default = true
}

variable "create" {
  type    = bool
  default = true
}

variable "update" {
  type    = bool
  default = true
}

variable "process" {
  type    = bool
  default = true
}

variable "tag" {
  type    = bool
  default = true
}

variable "filter" {
  type    = bool
  default = true
}

variable "service" {
  type    = bool
  default = true
}

variable "container" {
  type    = bool
  default = true
}

variable "object" {
  type    = bool
  default = true
}

variable "blob" {
  type    = bool
  default = true
}

variable "queue" {
  type    = bool
  default = true
}

variable "table" {
  type    = bool
  default = true
}

variable "file" {
  type    = bool
  default = true
}


