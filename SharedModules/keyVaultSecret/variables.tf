variable "secret_name" {
  type = string
  default = ""
}
variable "secret_value" {
  type    = string
  default = ""
}
variable "key_vault_id" {
  type    = string
  default = ""
}
variable "content_type" {
  type    = string
  default = "connection string"
}
variable "expiration_date" {
  type    = string
  default = "2025-12-31T00:00:00Z"
}
