variable "global_settings" {
  default = {}
}
variable "appconf_config" {
  default = {}
}

variable "media_type" {
  type    = map(string)
  default = {
    json     = "application/json"
    protobuf = "application/protobuf"
  }
}

variable "apim_api_params" {
  type = object({
    name        = string
    path        = string
    revision    = optional(string, "1")
    protocols   = optional(list(string), [ "https" ])
    displayName = optional(string)
  })
}

variable "apim_api_backend_params" {
  type = object({
    name        = string
    url         = string,
    resource_id = optional(string),
    description = optional(string)
    protocol    = optional(string, "http")
  })
}

variable "azure_function_operations" {
  type = map(object({
    displayDame        = string
    httpMethod         = string
    urlTemplate        = string
    description        = string
  }))
}

variable "azure_function_name" {
  type = string
}