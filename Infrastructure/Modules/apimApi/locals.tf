locals {
  validate-parameters-policy = <<XML
  <validate-parameters specified-parameter-action="prevent" unspecified-parameter-action="prevent" errors-variable-name="parametersValidationErrors" />
  XML
  validate-azure-ad-token-policy = <<XML
  <validate-azure-ad-token header-name="Authorization"
      failed-validation-httpcode="401"
      failed-validation-error-message="Unauthorized" />  
  XML
  validate-jwt-policy = <<XML
  <validate-jwt header-name="Authorization" failed-validation-httpcode="401" />
  XML
  set-backend-service-policy = <<XML
  <set-backend-service id="apim-operation-backend-policy" backend-id="${azurerm_api_management_backend.apim_api_backend.name}" />
  XML
  check-accept-header-policy = <<XML
  <check-header name="accept" failed-check-httpcode="400" failed-check-error-message="Not allowed header Accept value" ignore-case="true">
    <value>${var.media_type.json}</value>
    <value>${var.media_type.protobuf}</value>
  </check-header>
  XML
  check-content-type-header-policy = <<XML
  <check-header name="content-type" failed-check-httpcode="400" failed-check-error-message="Not allowed header Content-Type value" ignore-case="true">
    <value>${var.media_type.json}</value>
    <value>${var.media_type.protobuf}</value>
  </check-header>
  XML
  quota-by-key-policy = <<XML
  <quota-by-key calls="1000" renewal-period="60" counter-key="@(context.Subscription?.Key ?? "anonymous")" />
  XML

  apim-api-policy-xml-content = <<XML
  <policies>
    <inbound>
	  <base />  
      ${local.set-backend-service-policy}
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