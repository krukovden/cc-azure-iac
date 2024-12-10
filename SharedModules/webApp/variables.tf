variable "rg_name" {
  type    = string
  default = "rg-mdf-us-dev"
}
variable "location" {
  type = string
}
variable "app_name" {
  type = string
}
variable "sku_tier" {
  type    = string
  default = "Standard"
}
variable "sku_size" {
  type    = string
  default = "Standard"
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}

