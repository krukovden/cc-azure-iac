#######################################################################
#--------------------------Shared exchanges---------------------------#
#######################################################################
resource "rabbitmq_exchange" "er_request_exchange" {
  name  = module.erp_rmq_config.er_rabbitmq_request_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.erp_rmq_config.default_exchange_parameters.type
    durable     = module.erp_rmq_config.default_exchange_parameters.durable
    auto_delete = module.erp_rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_exchange" "erp_request_report_handler" {
  name  = module.erp_rmq_config.erp_rabbitmq_request_report_handler_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.erp_rmq_config.default_exchange_parameters.type
    durable     = module.erp_rmq_config.default_exchange_parameters.durable
    auto_delete = module.erp_rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_exchange" "er_report_response_delay_exchange" {
  name  = module.erp_rmq_config.er_rabbitmq_report_response_delay_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.erp_rmq_config.default_delay_exchange_parameters.type
    durable     = module.erp_rmq_config.default_delay_exchange_parameters.durable
    auto_delete = module.erp_rmq_config.default_delay_exchange_parameters.auto_delete
    arguments = {
      x-delayed-type = module.erp_rmq_config.default_delay_exchange_parameters.x-delayed-type
    }
  }
}

resource "rabbitmq_exchange" "er_report_response_exchange" {
  name  = module.erp_rmq_config.er_rabbitmq_report_response_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.erp_rmq_config.default_header_exchange_parameters.type
    durable     = module.erp_rmq_config.default_header_exchange_parameters.durable
    auto_delete = module.erp_rmq_config.default_header_exchange_parameters.auto_delete
  }
}
#######################################################################
#----------------------------Import report----------------------------#
#######################################################################

resource "rabbitmq_queue" "import_report_array_executor_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_import_report_array_executor_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}
resource "rabbitmq_binding" "import_report_array_executor_binding" {
  source           = rabbitmq_exchange.er_request_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.import_report_array_executor_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.er_rabbitmq_import_report_array_executor_binding_config.routing_key

  depends_on = [
    rabbitmq_queue.import_report_array_executor_queue,
    rabbitmq_exchange.er_request_exchange
  ]
}

resource "rabbitmq_queue" "import_report_sender_queue" {
  name  = module.erp_rmq_config.erp_rabbitmq_import_report_sender_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}
resource "rabbitmq_binding" "import_report_sender_binding" {
  source           = rabbitmq_exchange.erp_request_report_handler.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.import_report_sender_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.erp_rabbitmq_import_report_sender_binding_config.routing_key

  depends_on = [
    rabbitmq_queue.import_report_sender_queue,
    rabbitmq_exchange.erp_request_report_handler
  ]
}

resource "rabbitmq_queue" "import_report_request_dlq_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_import_report_request_dlq_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "import_report_response_persist_queue" {
  name  = module.erp_rmq_config.erp_rabbitmq_import_report_response_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}
resource "rabbitmq_binding" "import_report_response_persist_retry_binding" {
  source           = rabbitmq_exchange.er_report_response_delay_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.import_report_response_persist_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.erp_rabbitmq_import_report_response_persist_retry_binding.routing_key

  depends_on = [
    rabbitmq_queue.import_report_response_persist_queue,
    rabbitmq_exchange.er_report_response_delay_exchange
  ]
}
resource "rabbitmq_binding" "import_report_response_persist_binding" {
  source           = rabbitmq_exchange.er_report_response_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.import_report_response_persist_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  arguments = {
    "x.abs.topic" = module.erp_rmq_config.erp_rabbitmq_import_report_writer_binding_config.header_value
  }

  depends_on = [
    rabbitmq_queue.import_report_response_persist_queue,
    rabbitmq_exchange.er_report_response_exchange
  ]
}

resource "rabbitmq_queue" "import_report_response_dlq_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_import_report_response_dlq_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}
#######################################################################
#-----------------------Get validation results------------------------#
#######################################################################
resource "rabbitmq_queue" "validation_request_queue" {
  name  = module.erp_rmq_config.erp_rabbitmq_validation_result_sender_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}
resource "rabbitmq_binding" "validation_request_binding" {
  source           = rabbitmq_exchange.erp_request_report_handler.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.validation_request_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.erp_rabbitmq_validation_result_config.routing_key

  depends_on = [
    rabbitmq_queue.validation_request_queue,
    rabbitmq_exchange.erp_request_report_handler
  ]
}

resource "rabbitmq_queue" "validation_response_queue" {
  name  = module.erp_rmq_config.erp_rabbitmq_validation_response_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}
resource "rabbitmq_binding" "validation_response_retry_binding" {
  source           = rabbitmq_exchange.er_report_response_delay_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.validation_response_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.erp_rabbitmq_validation_result_config.routing_key

  depends_on = [
    rabbitmq_queue.validation_response_queue,
    rabbitmq_exchange.er_report_response_delay_exchange
  ]
}
resource "rabbitmq_binding" "validation_response_binding" {
  source           = rabbitmq_exchange.er_report_response_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.validation_response_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  arguments = {
    "x.abs.topic" = module.erp_rmq_config.erp_rabbitmq_validation_report_writer_binding_config.header_value
  }

  depends_on = [
    rabbitmq_queue.validation_response_queue,
    rabbitmq_exchange.er_report_response_exchange
  ]
}

resource "rabbitmq_queue" "validation_request_dlq_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_validation_request_dlq_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "validation_response_dlq_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_validation_response_dlq_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}

#######################################################################
#----------------------------Update report----------------------------#
#######################################################################

resource "rabbitmq_queue" "update_report_executor_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_update_report_executor_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}
resource "rabbitmq_binding" "update_report_executor_binding" {
  source           = rabbitmq_exchange.er_request_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.update_report_executor_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.er_rabbitmq_update_report_executor_binding_config.routing_key

  depends_on = [
    rabbitmq_queue.update_report_executor_queue,
    rabbitmq_exchange.er_request_exchange
  ]
}

resource "rabbitmq_queue" "update_report_sender_queue" {
  name  = module.erp_rmq_config.erp_rabbitmq_update_report_sender_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}
resource "rabbitmq_binding" "update_report_sender_binding" {
  source           = rabbitmq_exchange.erp_request_report_handler.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.update_report_sender_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.erp_rabbitmq_update_report_sender_binding_config.routing_key

  depends_on = [
    rabbitmq_queue.update_report_sender_queue,
    rabbitmq_exchange.erp_request_report_handler
  ]
}

resource "rabbitmq_queue" "update_report_request_dlq_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_update_report_request_dlq_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "update_report_response_persist_queue" {
  name  = module.erp_rmq_config.erp_rabbitmq_update_report_response_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}
resource "rabbitmq_binding" "update_report_response_persist_retry_binding" {
  source           = rabbitmq_exchange.er_report_response_delay_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.update_report_response_persist_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.erp_rabbitmq_update_report_response_persist_retry_binding.routing_key

  depends_on = [
    rabbitmq_queue.update_report_response_persist_queue,
    rabbitmq_exchange.er_report_response_delay_exchange
  ]
}
resource "rabbitmq_binding" "update_report_response_persist_binding" {
  source           = rabbitmq_exchange.er_report_response_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.update_report_response_persist_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  arguments = {
    "x.abs.topic" = module.erp_rmq_config.erp_rabbitmq_update_report_writer_binding_config.header_value
  }

  depends_on = [
    rabbitmq_queue.update_report_response_persist_queue,
    rabbitmq_exchange.er_report_response_exchange
  ]
}

resource "rabbitmq_queue" "update_report_response_dlq_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_update_report_response_dlq_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}

#######################################################################
#-----------------------------Get Voyages-----------------------------#
#######################################################################

resource "rabbitmq_queue" "get_voyages_executor_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_get_voyages_executor_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "get_voyages_executor_binding" {
  source           = rabbitmq_exchange.er_request_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.get_voyages_executor_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.er_rabbitmq_get_voyages_executor_binding_config.routing_key

  depends_on = [
    rabbitmq_queue.get_voyages_executor_queue,
    rabbitmq_exchange.er_request_exchange
  ]
}

resource "rabbitmq_queue" "get_voyages_sender_queue" {
  name  = module.erp_rmq_config.erp_rabbitmq_get_voyages_sender_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "get_voyages_sender_binding" {
  source           = rabbitmq_exchange.erp_request_report_handler.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.get_voyages_sender_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.erp_rabbitmq_get_voyages_sender_binding_config.routing_key

  depends_on = [
    rabbitmq_queue.get_voyages_sender_queue,
    rabbitmq_exchange.erp_request_report_handler
  ]
}

resource "rabbitmq_queue" "get_voyages_request_dlq_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_get_voyages_request_dlq_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}

#######################################################################
#-----------------------------Get Report SOF--------------------------#
#######################################################################

resource "rabbitmq_queue" "get_report_sof_sender_queue" {
  name  = module.erp_rmq_config.erp_rabbitmq_get_report_sof_sender_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "get_report_sof_sender_binding" {
  source           = rabbitmq_exchange.erp_request_report_handler.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.get_report_sof_sender_queue.name
  destination_type = module.erp_rmq_config.default_queue_binding.destination_type
  routing_key      = module.erp_rmq_config.erp_rabbitmq_get_report_sof_sender_binding_config.routing_key

  depends_on = [
    rabbitmq_queue.get_voyages_sender_queue,
    rabbitmq_exchange.erp_request_report_handler
  ]
}

resource "rabbitmq_queue" "get_report_sof_request_dlq_queue" {
  name  = module.erp_rmq_config.er_rabbitmq_get_report_sof_request_dlq_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.erp_rmq_config.default_queue_parameters.durable
    auto_delete = module.erp_rmq_config.default_queue_parameters.auto_delete
  }
}