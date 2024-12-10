locals {
  env = lower(var.ENV)
  region_name = lower(var.REGION_CODE)
  region_suffix = lower(var.REGION_SUFFIX)
  region_env = "${local.region_suffix}-${local.env}"
  formatted_region_env = "${local.region_suffix}${local.env}"

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

  apim_name = format(var.apim_name_template, local.region_env)

  apim_public_ip_params = merge(
    var.apim_public_ip_params_template,
    { 
      domain_name_label = format(var.apim_public_ip_params_template.domain_name_label, local.region_env), 
      fqdn              = format(var.apim_public_ip_params_template.fqdn, "${local.region_name}.${local.env}"), 
    }
  )

  apim_request_timeout_attribute = var.apim_request_timeout_seconds > 0 ? "timeout=\"${var.apim_request_timeout_seconds}\"" : ""

  # it is used in get-clients-from-database.tf
  database_server_name = "cc-cp-norm-server-${local.region_env}"

  client_ids = [ for client in data.postgresql_query.get_clients.rows : client.client_id ]
  undefined_onboarding_ui = "undefined-onboarding-ui"
  onboarding_client_id = length(data.postgresql_query.get_ui_client.rows) > 0 ? data.postgresql_query.get_ui_client.rows[0].client_id : local.undefined_onboarding_ui

  apps_ids = formatlist("<application-id>%s</application-id>", local.client_ids)

  apim_authentication = <<XML
  <validate-azure-ad-token tenant-id="${data.env_var.apim_tenant_id.value}" output-token-variable-name="jwt">
    <client-application-ids>
    ${join("", local.apps_ids)}
    </client-application-ids>
  </validate-azure-ad-token>
  XML

  apim_set_clientid_variable = <<XML
  <set-variable name="clientId" value="@(((Jwt)context.Variables["jwt"]).Claims.GetValueOrDefault("appid", "unknown"))" />
  XML
  apim_set_clientid_header = <<XML
  <set-header name="cc-clientid" exists-action="override">
    <value>@((string)context.Variables["clientId"])</value>
  </set-header>    
  XML
  rate_limit_by_key_policy = <<XML
  <rate-limit-by-key calls="20" renewal-period="1" counter-key="@((string)context.Variables["clientId"])" />
  XML

  active_client_xml_block = <<-XML
    <set-variable name="active-client" value="@(context.Request.Headers.GetValueOrDefault("cc-active-client", "unknown"))" />
    <choose>
        <when condition="@((string)context.Variables["active-client"] != null &&
                          (string)context.Variables["active-client"] != "unknown" &&
                          (string)context.Variables["clientId"] == "${local.onboarding_client_id}")">
            <!-- Set the header value with the value from another header parameter -->
            <set-header name="cc-clientid" exists-action="override">
                <value>@((string)context.Variables["active-client"])</value>
            </set-header>
        </when>
        <otherwise>
            <!-- Optionally, you can add a default action if the header does not exist -->
        </otherwise>
    </choose>
  XML

# Add cors policy only in dev environment
  apim_cors_policy = <<XML
    <cors>
      <allowed-origins>
          <origin>*</origin>
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
  XML



  replace_client_id = local.onboarding_client_id != local.undefined_onboarding_ui ? local.active_client_xml_block : "<!-- Undefined Onboarding Tool -->"

  client_validation =  join("",
    [
      local.apim_authentication, 
      local.apim_set_clientid_variable, 
      local.apim_set_clientid_header, 
      local.rate_limit_by_key_policy,
      local.replace_client_id,
      local.apim_cors_policy
    ])

  return_error = <<XML
  <return-response>
      <set-status code="401" reason="Unauthorized" />
      <set-header name="Content-Type" exists-action="override">
          <value>"application/json"</value>
      </set-header>
      <set-body>@{
          var response = new
          {
              errors = new []
              {
                  new {
                      code = new {
                          name = "MissingHeader",
                          code = "4104"
                      },
                      message = "Azure AD JWT not present"
                  }
              }
          };

          return Newtonsoft.Json.JsonConvert.SerializeObject(response);
      }</set-body>
  </return-response>  
  XML

  apim-policy-xml-content = <<XML
  <policies>
    <inbound>
      ${length(local.client_ids) > 0 ? local.client_validation : local.return_error}
    </inbound>
    <backend>
      <forward-request ${local.apim_request_timeout_attribute} />
    </backend>
    <outbound />
    <on-error />
  </policies>
  XML
}
