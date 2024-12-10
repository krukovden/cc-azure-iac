output "default_queue_binding" {
  value = {
    destination_type = "queue"
    routing_key      = "#"
  }
}

output "default_queue_parameters" {
  value = {
    durable     = true
    auto_delete = false
  }
}

output "default_exchange_parameters" {
  value = {
    type        = "topic"
    durable     = true
    auto_delete = false
  }
}

output "default_delay_exchange_parameters" {
  value = {
    type           = "x-delayed-message"
    durable        = true
    auto_delete    = false
    x-delayed-type = "topic"
  }
}

output "default_header_exchange_parameters" {
  value = {
    type           = "headers"
    durable        = true
    auto_delete    = false
    x-delayed-type = "all"
  }
}

output "veson_rabbitmq_port_pull_request_exchange_config" {
  value = {
    name = "et.cccp.vesonports.pullrequest.delay"
  }
}

output "veson_rabbitmq_port_puller_queue_config" {
  value = {
    name = "q.cccp.vesonports.puller"
  }
}

output "veson_rabbitmq_port_parse_exchange_config" {
  value = {
    name = "et.cccp.vesonports.parse"
  }
}

output "veson_rabbitmq_port_parse_delay_exchange_config" {
  value = {
    name = "et.cccp.vesonports.parse.delay"
  }
}

output "veson_rabbitmq_port_parser_queue_config" {
  value = {
    name = "q.cccp.vesonports.parse"
  }
}

output "veson_rabbitmq_port_dlq_queue_config" {
  value = {
    name = "dlq.cccp.vesonports"
  }
}

output "veson_rabbitmq_raw_voyage_plan_exchange_config" {
  value = {
    name = "et.cccp.veson.raw.voyageplan"
  }
}

output "veson_rabbitmq_raw_voyage_plan_queue_writer_config" {
  value = {
    name = "q.cccp.veson.raw.voyageplan.blob"
  }
}

output "veson_rabbitmq_raw_voyage_plan_queue_converter_config" {
  value = {
    name = "q.cccp.veson.raw.voyageplan"
  }
}

output "veson_rabbitmq_raw_voyage_plan_delay_exchange_config" {
  value = {
    name = "et.cccp.veson.raw.voyageplan.delay"
  }
}

output "veson_rabbitmq_raw_voyage_plan_dlq_config" {
  value = {
    name = "dlq.cccp.veson.blob"
  }
}

output "veson_rabbitmq_voyage_plan_pull_request_exchange_config" {
  value = {
    name = "et.cccp.veson.voyageplan.puller"
  }
}

output "veson_rabbitmq_raw_voyage_plan_puller_queue_config" {
  value = {
    name = "q.cccp.veson.voyageplan.puller"
  }
}

output "shared_rabbitmq_norm_voyage_plan_exchange_config" {
  value = {
    name = "et.cccp.voyageplan"
  }
}

output "shared_rabbitmq_norm_voyage_plan_queue_writer_config" {
  value = {
    name = "q.cccp.persist.voyageplan"
  }
}

output "shared_rabbitmq_norm_voyage_plan_queue_writer_binding_config" {
  value = {
    destination_type = "queue"
    routing_key      = "voyageplan.#"
  }
}

output "shared_rabbitmq_voyage_plan_delay_exchange_config" {
  value = {
    name = "et.cccp.voyageplan.delay"
  }
}

output "shared_rabbitmq_veson_voyage_plan_dlq_config" {
  value = {
    name = "dlq.cccp.veson.voyageplan"
  }
}

output "disco_rabbitmq_shovel_exchange_config" {
  value = {
    name = "et.cccp.disco.receiver"
  }
}

output "disco_rabbitmq_error_test_queue_config" {
  value = {
    name = "q.cccp.disco.receive.test"
  }
}

#######################################################################
#---------------------Emission report shared--------------------------#
#######################################################################
output "er_rabbitmq_request_exchange_config" {
  value = {
    name = "et.cccp.er.request"
  }
}

output "erp_rabbitmq_request_report_handler_exchange_config" {
  value = {
    name = "et.cccp.er.report.handler"
  }
}

output "er_rabbitmq_report_response_exchange_config" {
  value = {
    name = "eh.cccp.er.report.response"
  }
}

output "er_rabbitmq_report_response_delay_exchange_config" {
  value = {
    name = "et.cccp.er.report.response.delay"
  }
}
#######################################################################
#------------------------ERP Import report----------------------------#
#######################################################################


output "er_rabbitmq_import_report_array_executor_queue_config" {
  value = {
    name = "q.cccp.er.report.import.request"
  }
}
output "er_rabbitmq_import_report_array_executor_binding_config" {
  value = {
    routing_key = "er.report.import"
  }
}

output "erp_rabbitmq_import_report_sender_queue_config" {
  value = {
    name = "q.cccp.er.erp.report.import.sender"
  }
}
output "erp_rabbitmq_import_report_sender_binding_config" {
  value = {
    routing_key = "er.erp.report.import"
  }
}

output "er_rabbitmq_import_report_request_dlq_queue_config" {
  value = {
    name = "dlq.cccp.er.report.import.request"
  }
}

output "erp_rabbitmq_import_report_response_queue_config" {
  value = {
    name = "q.cccp.er.erp.report.import.response"
  }
}

output "erp_rabbitmq_import_report_response_persist_retry_binding" {
  value = {
    routing_key = "er.erp.report.import"
  }
}

output "erp_rabbitmq_import_report_writer_binding_config" {
  value = {
    header_key   = "x.abs.topic",
    header_value = "er.erp.report.import"
  }
}

output "er_rabbitmq_import_report_response_dlq_queue_config" {
  value = {
    name = "dlq.cccp.er.report.import.response"
  }
}

output "er_rabbitmq_import_report_response_client_queue" {
  value = {
    prefix = "q.cccp.er.report.import.response"
  }
}

#######################################################################
#-------------------ERP get validation results------------------------#
#######################################################################
output "erp_rabbitmq_validation_result_sender_queue_config" {
  value = {
    name = "q.cccp.er.erp.report.validation.result.sender"
  }
}
output "erp_rabbitmq_validation_result_config" {
  value = {
    routing_key = "er.erp.report.validation.result"
  }
}

output "erp_rabbitmq_validation_response_queue_config" {
  value = {
    name = "q.cccp.er.erp.report.validation.result.response"
  }
}
output "erp_rabbitmq_validation_report_writer_binding_config" {
  value = {
    header_key   = "x.abs.topic",
    header_value = "er.erp.report.validation.result"
  }
}

output "er_rabbitmq_validation_response_dlq_queue_config" {
  value = {
    name = "dlq.cccp.er.validation.response"
  }
}

output "er_rabbitmq_validation_request_dlq_queue_config" {
  value = {
    name = "dlq.cccp.er.validation.request"
  }
}

output "er_rabbitmq_validation_response_client_queue" {
  value = {
    prefix = "q.cccp.er.report.validation.result.response"
  }
}

#######################################################################
#------------------------ERP Update report----------------------------#
#######################################################################

output "er_rabbitmq_update_report_executor_queue_config" {
  value = {
    name = "q.cccp.er.report.update.request"
  }
}
output "er_rabbitmq_update_report_executor_binding_config" {
  value = {
    routing_key = "er.report.update"
  }
}

output "erp_rabbitmq_update_report_sender_queue_config" {
  value = {
    name = "q.cccp.er.erp.report.update.sender"
  }
}
output "erp_rabbitmq_update_report_sender_binding_config" {
  value = {
    routing_key = "er.erp.report.update"
  }
}
output "er_rabbitmq_update_report_request_dlq_queue_config" {
  value = {
    name = "dlq.cccp.er.report.update.request"
  }
}

output "erp_rabbitmq_update_report_response_queue_config" {
  value = {
    name = "q.cccp.er.erp.report.update.response"
  }
}

output "erp_rabbitmq_update_report_response_persist_retry_binding" {
  value = {
    routing_key = "er.erp.report.update"
  }
}

output "erp_rabbitmq_update_report_writer_binding_config" {
  value = {
    header_key   = "x.abs.topic",
    header_value = "er.erp.report.update"
  }
}

output "er_rabbitmq_update_report_response_dlq_queue_config" {
  value = {
    name = "dlq.cccp.er.report.update.response"
  }
}

output "er_rabbitmq_update_report_response_client_queue" {
  value = {
    prefix = "q.cccp.er.report.update.response"
  }
}

#######################################################################
#------------------------ ERP Get Voyages ----------------------------#
#######################################################################

output "er_rabbitmq_get_voyages_executor_queue_config" {
  value = {
    name = "q.cccp.er.report.getvoyages.request"
  }
}

output "er_rabbitmq_get_voyages_executor_binding_config" {
  value = {
    routing_key = "er.report.getvoyages"
  }
}

output "erp_rabbitmq_get_voyages_sender_queue_config" { 
  value = {
    name = "q.cccp.er.erp.report.getvoyages.sender"
  }
}

output "erp_rabbitmq_get_voyages_sender_binding_config" {
  value = {
    routing_key = "er.report.getvoyages"
  }
}

output "er_rabbitmq_get_voyages_request_dlq_queue_config" {
  value = {
    name = "dlq.cccp.er.report.getvoyages.request"
  }
}

output "erp_rabbitmq_get_voyages_writer_binding_config" {
  value = {
    header_key   = "x.abs.topic",
    header_value = "er.erp.report.getvoyages"
  }
}

output "er_rabbitmq_get_voyages_response_client_queue" {
  value = {
    prefix = "q.cccp.er.report.getvoyages.response"
  }
}

#######################################################################
#------------------------ ERP Get Report SOF -------------------------#
#######################################################################

output "erp_rabbitmq_get_report_sof_writer_binding_config" {
  value = {
    header_key   = "x.abs.topic",
    header_value = "er.erp.report.getsof"
  }
}

output "er_rabbitmq_get_report_sof_executor_binding_config" {
  value = {
    routing_key = " er.erp.report.getsof"
  }
}

output "er_rabbitmq_get_report_sof_request_dlq_queue_config" {
  value = {
    name = "dlq.cccp.er.report.getsof.request"
  }
}

output "erp_rabbitmq_get_report_sof_sender_queue_config" { 
  value = {
    name = "q.cccp.er.erp.report.getsof.sender"
  }
}

output "erp_rabbitmq_get_report_sof_sender_binding_config" {
  value = {
    routing_key = "er.erp.report.getsof"
  }
}

output "er_rabbitmq_get_report_sof_response_client_queue" {
  value = {
    prefix = "q.cccp.er.report.getsof.response"
  }
}

#######################################################################
#--------------------- Tenant adapter --------------------------------#
#######################################################################
output "ta_rabbitmq_tenent_data_exchange_config" {
  value = {
    name = "et.cccp.tenant-data"
  }
}

output "ta_rabbitmq_tenant_port_exchange_config" {
  value = {
    name = "et.cccp.tenant-port"
  }
}
#######################################################################
#--------------------- Onboarding Middleware--------------------------#
#######################################################################
output "onboardingmiddleware_vessel_processing_blob_exchange_config" {
  value = {
    name = "et.cccp.onboarding.vessel.blob"
  }
}

output "onboardingmiddleware_vessel_processing_blob_queue_config" {
  value = {
    name = "q.cccp.onboarding.vessel.blob"
  }
}

output "onboardingmiddleware_vessel_processing_data_exchange_config" {
  value = {
    name = "et.cccp.onboarding.vessel.data"
  }
}

output "onboardingmiddleware_vessel_processing_data_queue_config" {
  value = {
    name = "q.cccp.onboarding.vessel.data"
  }
}

output "onboardingmiddleware_vessel_processing_persist_exchange_config" {
  value = {
    name = "et.cccp.onboarding.vessel.persist"
  }
}

output "onboardingmiddleware_vessel_processing_persist_queue_config" {
  value = {
    name = "q.cccp.onboarding.vessel.persist"
  }
}

output "onboardingmiddleware_vessel_processing_response_queue_config" {
  value = {
    name = "q.cccp.onboarding.vessel.response"
  }
}

output "onboardingmiddleware_vessel_processing_delay_exchange_config" {
  value = {
    name = "et.cccp.onboarding.vessel.persist.delay"
  }
}

output "onboardingmiddleware_vessel_processing_blob_dlq_config" {
  value = {
    name = "dlq.cccp.onboarding.vessel.blob"
  }
}

output "onboardingmiddleware_vessel_processing_parser_dlq_config" {
  value = {
    name = "dlq.cccp.onboarding.vessel.parser"
  }
}

output "onboardingmiddleware_vessel_processing_persist_dlq_config" {
  value = {
    name = "dlq.cccp.onboarding.vessel.persist"
  }
}

output "onboardingmiddleware_sync_tenant_request_queue_config" {
  value = {
    name = "q.cccp.onboarding.sync-tenant.request"
  }
}

output "onboardingmiddleware_vessel_catalog_processing_update_exchange_config" {
  value = {
    name = "et.cccp.onboarding.vessel.catalog.update"
  }
}

output "onboardingmiddleware_vessel_catalog_processing_update_queue_config" {
  value = {
    name = "q.cccp.onboarding.vessel.catalog.update"
  }
}

output "onboardingmiddleware_vessel_catalog_processing_update_delay_exchange_config" {
  value = {
    name = "et.cccp.onboarding.vessel.catalog.update.delay"
  }
}