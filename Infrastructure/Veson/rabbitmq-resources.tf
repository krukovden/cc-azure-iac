resource "rabbitmq_exchange" "port_pull_request_exchange" {
  name  = module.veson_rmq_config.veson_rabbitmq_port_pull_request_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.veson_rmq_config.default_delay_exchange_parameters.type
    durable     = module.veson_rmq_config.default_delay_exchange_parameters.durable
    auto_delete = module.veson_rmq_config.default_delay_exchange_parameters.auto_delete
    arguments = {
      x-delayed-type = module.veson_rmq_config.default_delay_exchange_parameters.x-delayed-type
    }
  }
}

resource "rabbitmq_queue" "port_puller_queue" {
  name  = module.veson_rmq_config.veson_rabbitmq_port_puller_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.veson_rmq_config.default_queue_parameters.durable
    auto_delete = module.veson_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "port_puller_binding" {
  source           = rabbitmq_exchange.port_pull_request_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.port_puller_queue.name
  destination_type = module.veson_rmq_config.default_queue_binding.destination_type
  routing_key      = module.veson_rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.port_puller_queue,
    rabbitmq_exchange.port_pull_request_exchange
  ]
}

resource "rabbitmq_exchange" "port_parse_request_exchange" {
  name  = module.veson_rmq_config.veson_rabbitmq_port_parse_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.veson_rmq_config.default_exchange_parameters.type
    durable     = module.veson_rmq_config.default_exchange_parameters.durable
    auto_delete = module.veson_rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_exchange" "port_delay_exchange" {
  name  = module.veson_rmq_config.veson_rabbitmq_port_parse_delay_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.veson_rmq_config.default_delay_exchange_parameters.type
    durable     = module.veson_rmq_config.default_delay_exchange_parameters.durable
    auto_delete = module.veson_rmq_config.default_delay_exchange_parameters.auto_delete
    arguments = {
      x-delayed-type = module.veson_rmq_config.default_delay_exchange_parameters.x-delayed-type
    }
  }
}

resource "rabbitmq_queue" "port_writer_queue" {
  name  = module.veson_rmq_config.veson_rabbitmq_port_parser_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.veson_rmq_config.default_queue_parameters.durable
    auto_delete = module.veson_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "port_dlq_queue" {
  name  = module.veson_rmq_config.veson_rabbitmq_port_dlq_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.veson_rmq_config.default_queue_parameters.durable
    auto_delete = module.veson_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "port_writer_binding" {
  source           = rabbitmq_exchange.port_parse_request_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.port_writer_queue.name
  destination_type = module.veson_rmq_config.default_queue_binding.destination_type
  routing_key      = module.veson_rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.port_writer_queue,
    rabbitmq_exchange.port_parse_request_exchange
  ]
}

resource "rabbitmq_binding" "port_delay_writer_binding" {
  source           = rabbitmq_exchange.port_delay_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.port_writer_queue.name
  destination_type = module.veson_rmq_config.default_queue_binding.destination_type
  routing_key      = module.veson_rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.port_writer_queue,
    rabbitmq_exchange.port_delay_exchange
  ]
}

resource "rabbitmq_exchange" "raw_voyage_plan_veson_exchange" {
  name  = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.veson_rmq_config.default_exchange_parameters.type
    durable     = module.veson_rmq_config.default_exchange_parameters.durable
    auto_delete = module.veson_rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "raw_voyage_plan_writer_queue" {
  name  = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_queue_writer_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.veson_rmq_config.default_queue_parameters.durable
    auto_delete = module.veson_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "raw_voyage_plan_writer_binding" {
  source           = rabbitmq_exchange.raw_voyage_plan_veson_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.raw_voyage_plan_writer_queue.name
  destination_type = module.veson_rmq_config.default_queue_binding.destination_type
  routing_key      = module.veson_rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.raw_voyage_plan_writer_queue,
    rabbitmq_exchange.raw_voyage_plan_veson_exchange
  ]
}

resource "rabbitmq_queue" "raw_voyage_plan_converner_queue" {
  name  = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_queue_converter_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.veson_rmq_config.default_queue_parameters.durable
    auto_delete = module.veson_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "raw_voyage_plan_converner_binding" {
  source           = rabbitmq_exchange.raw_voyage_plan_veson_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.raw_voyage_plan_converner_queue.name
  destination_type = module.veson_rmq_config.default_queue_binding.destination_type
  routing_key      = module.veson_rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.raw_voyage_plan_converner_queue,
    rabbitmq_exchange.raw_voyage_plan_veson_exchange
  ]
}

resource "rabbitmq_exchange" "raw_voyage_plan_veson_delay_exchange" {
  name  = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_delay_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.veson_rmq_config.default_delay_exchange_parameters.type
    durable     = module.veson_rmq_config.default_delay_exchange_parameters.durable
    auto_delete = module.veson_rmq_config.default_delay_exchange_parameters.auto_delete
    arguments = {
      x-delayed-type = module.veson_rmq_config.default_delay_exchange_parameters.x-delayed-type
    }
  }
}

resource "rabbitmq_queue" "raw_voyage_plan_dlq" {
  name  = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_dlq_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.veson_rmq_config.default_queue_parameters.durable
    auto_delete = module.veson_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "raw_voyage_plan_retry_binding" {
  source           = rabbitmq_exchange.raw_voyage_plan_veson_delay_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.raw_voyage_plan_writer_queue.name
  destination_type = module.veson_rmq_config.default_queue_binding.destination_type
  routing_key      = module.veson_rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.raw_voyage_plan_writer_queue,
    rabbitmq_exchange.raw_voyage_plan_veson_delay_exchange
  ]
}

resource "rabbitmq_exchange" "veson_voyage_plan_pull_request_exchange" {
  name  = module.veson_rmq_config.veson_rabbitmq_voyage_plan_pull_request_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.veson_rmq_config.default_delay_exchange_parameters.type
    durable     = module.veson_rmq_config.default_delay_exchange_parameters.durable
    auto_delete = module.veson_rmq_config.default_delay_exchange_parameters.auto_delete
    arguments = {
      x-delayed-type = module.veson_rmq_config.default_delay_exchange_parameters.x-delayed-type
    }
  }
}

resource "rabbitmq_queue" "veson_voyage_plan_puller_request_queue" {
  name  = module.veson_rmq_config.veson_rabbitmq_raw_voyage_plan_puller_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.veson_rmq_config.default_queue_parameters.durable
    auto_delete = module.veson_rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "veson_voyage_plan_pull_request_binding" {
  source           = rabbitmq_exchange.veson_voyage_plan_pull_request_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.veson_voyage_plan_puller_request_queue.name
  destination_type = module.veson_rmq_config.default_queue_binding.destination_type
  routing_key      = module.veson_rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.veson_voyage_plan_puller_request_queue,
    rabbitmq_exchange.veson_voyage_plan_pull_request_exchange
  ]
}