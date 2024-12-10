terraform {
  required_providers {
    rabbitmq = {
      source  = "cyrilgdn/rabbitmq"
      version = "~> 1.8.0"
    }
    env = {
      source  = "tcarreira/env"
      version = "~> 0.2.0"
    }
  }
  required_version = ">= 1.1.0"
}

data "env_var" "rabbit_url" {
  id       = var.env_vars_names.rabbit_url
  required = true
}

data "env_var" "rabbit_connection_string" {
  id       = var.env_vars_names.rabbit_connection_string
  required = true
}

data "env_var" "rabbit_pass" {
  id       = var.env_vars_names.rabbit_pass
  required = true

}
data "env_var" "rabbit_user" {
  id       = var.env_vars_names.rabbit_user
  required = true
}

data "env_var" "rabbit_vhost" {
  id       = var.env_vars_names.rabbit_vhost
  required = true
}

data "env_var" "rabbit_port" {
  id       = var.env_vars_names.rabbit_port
  required = true
}

provider "rabbitmq" {
  endpoint = "https://${data.env_var.rabbit_url.value}"
  username = data.env_var.rabbit_user.value
  password = data.env_var.rabbit_pass.value
}

module "rmq_config" {
  source = "../Modules/rmqConfig"
}

locals {
  formatted_client_id = lower(replace(var.client_id, "-", ""))
  createInstance = var.skip_if_onboarding_ui ? 0 : 1

  client_rmq_connection_string = "amqps://${ rabbitmq_user.client_user.name }:${ rabbitmq_user.client_user.password }@${ data.env_var.rabbit_url.value }/${ data.env_var.rabbit_vhost.value }"

  voaygeplan_queue_name = "q.cccp.voyageplan.${ local.formatted_client_id }"
  erp_import_report_response_queue_name = "q.cccp.er.report.import.response.${ local.formatted_client_id }"
  erp_report_validation_result_response_queue_name = "q.cccp.er.report.validation.result.response.${ local.formatted_client_id }"
  erp_update_report_response_queue_name = "q.cccp.er.report.update.response.${ local.formatted_client_id }"
  erp_getvoyages_response_queue_name = "q.cccp.er.report.getvoyages.response.${ local.formatted_client_id }"
  client_application_tenant_queue_name = "q.cccp.tenant-data.${ local.formatted_client_id }"
  client_application_port_queue_name = "q.cccp.tenant-port.${ local.formatted_client_id }"
}

resource "random_string" "password" {
  length  = 16
  special = false
}

resource "rabbitmq_user" "client_user" {
  name     = local.formatted_client_id
  password = random_string.password.result
  tags     = [ "management" ]
}

resource "rabbitmq_queue" "voyageplan" {
  name  = local.voaygeplan_queue_name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = true
    auto_delete = false
  }

  count = local.createInstance
}

resource "rabbitmq_queue" "erp_import_report_response" {
  name  = local.erp_import_report_response_queue_name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = true
    auto_delete = false
  }

  count = local.createInstance
}

resource "rabbitmq_queue" "erp_report_validation_result_response" {
  name  = local.erp_report_validation_result_response_queue_name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = true
    auto_delete = false
  }

  count = local.createInstance
}

resource "rabbitmq_queue" "erp_update_report_response" {
  name  = local.erp_update_report_response_queue_name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = true
    auto_delete = false
  }
}

resource "rabbitmq_queue" "erp_getvoyages_response" {
  name  = local.erp_getvoyages_response_queue_name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = true
    auto_delete = false
  }
}

resource "rabbitmq_queue" "client_application_tenant" {
  name  = local.client_application_tenant_queue_name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = true
    auto_delete = false
  }
}

resource "rabbitmq_queue" "client_application_port" {
  name  = local.client_application_port_queue_name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = true
    auto_delete = false
  }
}

resource "rabbitmq_permissions" "client_permissions" {
  user  = rabbitmq_user.client_user.name
  vhost = data.env_var.rabbit_vhost.value

  permissions {
    configure = ""
    write     = var.erp_import_reports_request_exchange_name
    read      = local.formatted_client_id
  }

  depends_on = [ rabbitmq_user.client_user ]
}

resource "rabbitmq_binding" "erp_import_report_response_queue" {
  source           = module.rmq_config.er_rabbitmq_report_response_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.erp_import_report_response[count.index].name
  destination_type = "queue"
  arguments = {
    "x.abs.topic" = module.rmq_config.erp_rabbitmq_import_report_writer_binding_config.header_value,
    "x.abs.app.trg.id" = "${ local.formatted_client_id }"
  }
  depends_on = [ rabbitmq_queue.erp_import_report_response ]

  count = local.createInstance
}

resource "rabbitmq_binding" "erp_report_validation_result_response_queue" {
  source           = module.rmq_config.er_rabbitmq_report_response_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.erp_report_validation_result_response[count.index].name
  destination_type = "queue"
  arguments = {
    "x.abs.topic" = module.rmq_config.erp_rabbitmq_validation_report_writer_binding_config.header_value,
    "x.abs.app.trg.id" = "${ local.formatted_client_id }"
  }
  depends_on = [ rabbitmq_queue.erp_report_validation_result_response ]

  count = local.createInstance
}

resource "rabbitmq_binding" "erp_update_report_response_queue" {
  source           = module.rmq_config.er_rabbitmq_report_response_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.erp_update_report_response.name
  destination_type = "queue"
  arguments = {
    "x.abs.topic" = module.rmq_config.erp_rabbitmq_update_report_writer_binding_config.header_value,
    "x.abs.app.trg.id" = "${ local.formatted_client_id }"
  }
  depends_on = [ rabbitmq_queue.erp_update_report_response ]
}

resource "rabbitmq_binding" "erp_getvoyages_response_queue" {
  source           = module.rmq_config.er_rabbitmq_report_response_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.erp_getvoyages_response.name
  destination_type = "queue"
  arguments = {
    "x.abs.topic" = module.rmq_config.erp_rabbitmq_get_voyages_writer_binding_config.header_value,
    "x.abs.app.trg.id" = "${ local.formatted_client_id }"
  }
  depends_on = [ rabbitmq_queue.erp_getvoyages_response ]
}

resource "rabbitmq_binding" "client_application_tenant_queue" {
  source           = module.rmq_config.ta_rabbitmq_tenent_data_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.client_application_tenant.name
  destination_type = "queue"
  routing_key      = rabbitmq_queue.client_application_tenant.name

  depends_on = [ rabbitmq_queue.client_application_tenant ]
}

resource "rabbitmq_binding" "client_application_port_queue" {
  source           = module.rmq_config.ta_rabbitmq_tenant_port_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.client_application_port.name
  destination_type = "queue"
  routing_key      = rabbitmq_queue.client_application_port.name

  depends_on = [ rabbitmq_queue.client_application_port ]
}

output "client_rmq_connection_string" {
  value     = local.client_rmq_connection_string
  sensitive = true
}