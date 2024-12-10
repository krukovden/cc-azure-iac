locals {
  env = lower(var.ENV)
  region_name = lower(var.REGION_CODE)
  region_suffix = lower(var.REGION_SUFFIX)
  region_env = "${local.region_suffix}-${local.env}"
  formatted_region_env = "${local.region_suffix}${local.env}"

  apim_name = module.get_apim_name.value

  appconf_config = {
  for k, v in var.appconf_config_template :
    k => (k == "name" ? "${replace(v, "%s", local.region_env)}" : "${replace(v, "%s", local.env)}")
  }

  tags = merge(var.global_settings_template.tags, { Environment = local.env })

  global_settings = merge(var.global_settings_template, { 
    location                 = local.region_name,  
    resource_group_name      = format(var.global_settings_template.resource_group_name, local.region_suffix),
    data_resource_group_name = format(var.global_settings_template.data_resource_group_name, local.region_suffix),
    tags                     = local.tags 
  })

  portinfo_func_name = format(var.portinfo_func_name_template, local.region_env)
  portinfo_func_app_hostname = try(data.azurerm_windows_function_app.portinfo_windows_function_app.default_hostname, data.azurerm_linux_function_app.portinfo_linux_function_app.default_hostname)
  portinfo_func_app_id = try(data.azurerm_windows_function_app.portinfo_windows_function_app.id, data.azurerm_linux_function_app.portinfo_linux_function_app.id)
  portinfo_func_openapi_document_url = format("%s%s/api/openapi/v3.json", "https://", local.portinfo_func_app_hostname)

  portinfo-set-backend-service-policy = <<XML
  <set-backend-service base-url="https://${local.portinfo_func_app_hostname}/api" />
  XML

  API_BACKEND_URL_PLACEHOLDER = "<!--API BACKEND URL PLACEHOLDER-->"
  portinfo-api-policy-xml-content = replace(local.apim-api-policy-xml-content_template, local.API_BACKEND_URL_PLACEHOLDER, local.portinfo-set-backend-service-policy)

  apim-api-policy-xml-content_template = <<XML
  <policies>
    <inbound>
	  <base />  
      ${local.API_BACKEND_URL_PLACEHOLDER}
    </inbound>
    <backend>
	  <base />	      
    </backend>
    <outbound>
	  <base />	  
    </outbound>
    <on-error>	  	  
      <choose>
        <when condition="@(context.LastError != null && context.LastError.Message.Contains("Azure AD JWT not present"))">
          <return-response>
            <set-status code="401" reason="Unauthorized" />
            <set-header name="Content-Type">
			  <value>"application/json"</value>
			</set-header>
            <set-body>{
				"errors": [           
				{           
                      "code": {           
                          "name": "MissingHeader",           
                          "code": "4104"           
                      },           
                      "message": "Azure AD JWT not present"           
				}           
			]}</set-body>
          </return-response>
        </when>
        <when condition="@(context.LastError != null && (context.LastError.Message.Contains("Invalid Azure AD JWT") || context.LastError.Message.Contains("IDX12741") || context.LastError.Message.Contains("Signature is invalid")))">
          <return-response>
            <set-status code="401" reason="Unauthorized" />
            <set-header name="Content-Type">
			  <value>"application/json"</value>
			</set-header>
            <set-body>{
				"errors": [           
				{           
                      "code": {           
                          "name": "InvalidHeaderValue",           
                          "code": "4103"           
                      },           
                      "message": "Invalid Azure AD JWT"           
				}           
			]}</set-body>
          </return-response>
        </when>		
      </choose>
    </on-error>
  </policies>
  XML
}