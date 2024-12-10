variable "rg_name" {
  type = string
}
variable "location" {
  type = string
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
