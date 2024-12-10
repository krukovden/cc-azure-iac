variable "blobname" {
  type = string
}
variable "saccname" {
  type = string
}
variable "scontname" {
  type = string
}
variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}
