variable "rg_name" {
  type    = string
  default = "rg-mdf-dev-core"
}
variable "api_name" {
  type = string
}
variable "apim_name" {
  type = string
}
variable "revision" {
  type    = string
  default = "1"
}
variable "api_type" {
  type    = string
  default = "http"
}
variable "display_name" {
  type    = string
  default = "default display name"
}
variable "path" {
  type    = string
  default = "api"
}
variable "protocols" {
  type    = list(string)
  default = ["https"]
}
variable "service_url" {
  type    = string
  default = "https://func-mdf-dev-graphql.azurewebsites.net/api/graphql"
}
variable "product_id" {
  type = string
}
variable "product_display_name" {
  type = string
}
variable "subscription_required" {
  type    = bool
  default = true
}
variable "approval_required" {
  type    = bool
  default = true
}
variable "published" {
  type    = bool
  default = true
}
variable "authorization_server_name" {
  type    = string
  default = "AAD-Oauth2.0"
}
variable "xml_content" {
  type    = string
  default = <<XML
<policies>
    <inbound>
        <cors allow-credentials="true">
            <allowed-origins>
                <origin>http://localhost:3000</origin>
                <origin>https://apim-mdf-dev-core.developer.azure-api.net</origin>
            </allowed-origins>
            <allowed-methods preflight-result-max-age="300">
                <method>*</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
            <expose-headers>
                <header>*</header>
            </expose-headers>
        </cors>
    </inbound>
    <backend>
        <forward-request />
    </backend>
    <outbound />
    <on-error />
</policies>
XML
}

# variable "content_format" {
#   type    = string
#   default = "swagger-link-json"
# }
# variable "content_value" {
#   type    = string
#   default = "http://conferenceapi.azurewebsites.net/?format=json"
# }
