resource "rabbitmq_exchange" "unports_parse_exchange" {
  name  = var.unports_parse_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = var.unports_parse_exchange_config.type
    durable     = var.unports_parse_exchange_config.durable
    auto_delete = var.unports_parse_exchange_config.auto_delete
  }
}

resource "rabbitmq_queue" "unports_parse_queue" {
  name  = var.unports_parse_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.unports_parse_queue_config.durable
    auto_delete = var.unports_parse_queue_config.auto_delete
  }
}

resource "rabbitmq_binding" "unports_parse_binding" {
  source           = rabbitmq_exchange.unports_parse_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.unports_parse_queue.name
  destination_type = var.unports_parse_binding_config.destination_type
  routing_key      = var.unports_parse_binding_config.routing_key

  depends_on = [
    rabbitmq_queue.unports_parse_queue,
    rabbitmq_exchange.unports_parse_exchange
  ]
}

resource "rabbitmq_exchange" "unports_parse_delay_exchange" {
  name  = var.unports_parse_delay_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = var.unports_parse_delay_exchange_config.type
    durable     = var.unports_parse_delay_exchange_config.durable
    auto_delete = var.unports_parse_delay_exchange_config.auto_delete
    arguments = {
      x-delayed-type = var.unports_parse_exchange_config.type
    }
  }
}

resource "rabbitmq_queue" "unports_dlq" {
  name  = var.unports_dlq_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.unports_dlq_config.durable
    auto_delete = var.unports_dlq_config.auto_delete
  }
}

resource "rabbitmq_binding" "unports_retry_binding" {
  source           = rabbitmq_exchange.unports_parse_delay_exchange.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = rabbitmq_queue.unports_parse_queue.name
  destination_type = var.unports_parse_binding_config.destination_type
  routing_key      = var.unports_parse_binding_config.routing_key

  depends_on = [
    rabbitmq_queue.unports_parse_queue,
    rabbitmq_exchange.unports_parse_delay_exchange
  ]
}

resource "rabbitmq_exchange" "unports_status_exchange" {
  name  = var.unports_status_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = var.unports_status_exchange_config.type
    durable     = var.unports_status_exchange_config.durable
    auto_delete = var.unports_status_exchange_config.auto_delete
  }
}