variable "saccname" {
  type = string
}
variable "location" {
  type = string
}
variable "rgname" {
  type = string
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
variable "scontname" {
  type = string
}