resource "rabbitmq_exchange" "norm_voyage_plan" {
  name  = module.rmq_config.shared_rabbitmq_norm_voyage_plan_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.rmq_config.default_exchange_parameters.type
    durable     = module.rmq_config.default_exchange_parameters.durable
    auto_delete = module.rmq_config.default_exchange_parameters.auto_delete
  }
}

resource "rabbitmq_queue" "norm_voyage_plan_writer" {
  name  = module.rmq_config.shared_rabbitmq_norm_voyage_plan_queue_writer_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}

resource "rabbitmq_binding" "norm_voyage_plan_writer" {
  source           = rabbitmq_exchange.norm_voyage_plan.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.norm_voyage_plan_writer.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_exchange.norm_voyage_plan,
    rabbitmq_queue.norm_voyage_plan_writer
  ]
}

resource "rabbitmq_exchange" "voyage_plan_delay" {
  name  = module.rmq_config.shared_rabbitmq_voyage_plan_delay_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = module.rmq_config.default_delay_exchange_parameters.type
    durable     = module.rmq_config.default_delay_exchange_parameters.durable
    auto_delete = module.rmq_config.default_delay_exchange_parameters.auto_delete
    arguments = {
      x-delayed-type = module.rmq_config.default_delay_exchange_parameters.x-delayed-type
    }
  }
}

resource "rabbitmq_binding" "voyage_plan_delay" {
  source           = rabbitmq_exchange.voyage_plan_delay.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.norm_voyage_plan_writer.name
  destination_type = module.rmq_config.default_queue_binding.destination_type
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_exchange.voyage_plan_delay,
    rabbitmq_queue.norm_voyage_plan_writer
  ]
}

resource "rabbitmq_queue" "norm_voyage_plan_dlq" {
  name  = module.rmq_config.shared_rabbitmq_veson_voyage_plan_dlq_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = module.rmq_config.default_queue_parameters.durable
    auto_delete = module.rmq_config.default_queue_parameters.auto_delete
  }
}