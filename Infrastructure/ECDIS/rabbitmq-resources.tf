resource "rabbitmq_exchange" "ecdis_blob_exchange" {
  name  = var.ecdis_blob_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = var.ecdis_blob_exchange_config.type
    durable     = var.ecdis_blob_exchange_config.durable
    auto_delete = var.ecdis_blob_exchange_config.auto_delete
  }
}

resource "rabbitmq_queue" "ecdis_blob_queue" {
  name  = var.ecdis_blob_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.ecdis_blob_queue_config.durable
    auto_delete = var.ecdis_blob_queue_config.auto_delete
  }
}

resource "rabbitmq_queue" "ecdis_blob_dlq" {
  name  = var.ecdis_blob_dead_letter_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.ecdis_blob_dead_letter_queue_config.durable
    auto_delete = var.ecdis_blob_dead_letter_queue_config.auto_delete
  }
}

resource "rabbitmq_binding" "ecdis_blob_binding" {
  source           = var.ecdis_blob_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_blob_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_blob_queue,
    rabbitmq_exchange.ecdis_blob_exchange
  ]
}

resource "rabbitmq_exchange" "ecdis_blob_delay_exchange" {
  name  = var.ecdis_blob_delay_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type    = var.ecdis_blob_delay_exchange_config.type
    durable = var.ecdis_blob_delay_exchange_config.durable
    arguments = {
      x-delayed-type = var.ecdis_blob_exchange_config.type
    }
  }
}

resource "rabbitmq_binding" "ecdis_blob_delay_binding" {
  source           = var.ecdis_blob_delay_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_blob_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_blob_queue,
    rabbitmq_exchange.ecdis_blob_delay_exchange
  ]
}


resource "rabbitmq_exchange" "ecdis_blob_tmp_exchange" {
  name  = var.ecdis_blob_tmp_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = var.ecdis_blob_tmp_exchange_config.type
    durable     = var.ecdis_blob_tmp_exchange_config.durable
    auto_delete = var.ecdis_blob_tmp_exchange_config.auto_delete
  }
}

resource "rabbitmq_queue" "ecdis_blob_tmp_queue" {
  name  = var.ecdis_blob_tmp_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.ecdis_blob_tmp_queue_config.durable
    auto_delete = var.ecdis_blob_tmp_queue_config.auto_delete
  }
}

resource "rabbitmq_queue" "ecdis_blob_tmp_dlq" {
  name  = var.ecdis_blob_tmp_dead_letter_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.ecdis_blob_tmp_dead_letter_queue_config.durable
    auto_delete = var.ecdis_blob_tmp_dead_letter_queue_config.auto_delete
  }
}

resource "rabbitmq_binding" "ecdis_blob_tmp_binding" {
  source           = var.ecdis_blob_tmp_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_blob_tmp_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_blob_tmp_queue,
    rabbitmq_exchange.ecdis_blob_tmp_exchange
  ]
}

resource "rabbitmq_exchange" "ecdis_blob_tmp_delay_exchange" {
  name  = var.ecdis_blob_tmp_delay_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type    = var.ecdis_blob_tmp_delay_exchange_config.type
    durable = var.ecdis_blob_tmp_delay_exchange_config.durable
    arguments = {
      x-delayed-type = var.ecdis_blob_tmp_exchange_config.type
    }
  }
}

resource "rabbitmq_binding" "ecdis_blob_tmp_delay_binding" {
  source           = var.ecdis_blob_tmp_delay_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_blob_tmp_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_blob_tmp_queue,
    rabbitmq_exchange.ecdis_blob_tmp_delay_exchange
  ]
}


resource "rabbitmq_exchange" "ecdis_waypoints_exchange" {
  name  = var.ecdis_waypoints_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = var.ecdis_waypoints_exchange_config.type
    durable     = var.ecdis_waypoints_exchange_config.durable
    auto_delete = var.ecdis_waypoints_exchange_config.auto_delete
  }
}

resource "rabbitmq_queue" "ecdis_waypoints_queue" {
  name  = var.ecdis_waypoints_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.ecdis_waypoints_queue_config.durable
    auto_delete = var.ecdis_waypoints_queue_config.auto_delete
  }
}

resource "rabbitmq_queue" "ecdis_waypoints_dlq" {
  name  = var.ecdis_waypoints_dead_letter_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.ecdis_waypoints_dead_letter_queue_config.durable
    auto_delete = var.ecdis_waypoints_dead_letter_queue_config.auto_delete
  }
}

resource "rabbitmq_binding" "ecdis_waypoints_binding" {
  source           = var.ecdis_waypoints_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_waypoints_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_waypoints_queue,
    rabbitmq_exchange.ecdis_waypoints_exchange
  ]
}

resource "rabbitmq_exchange" "ecdis_waypoints_delay_exchange" {
  name  = var.ecdis_waypoints_delay_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type    = var.ecdis_waypoints_delay_exchange_config.type
    durable = var.ecdis_waypoints_delay_exchange_config.durable
    arguments = {
      x-delayed-type = var.ecdis_waypoints_exchange_config.type
    }
  }
}

resource "rabbitmq_binding" "ecdis_waypoints_delay_binding" {
  source           = var.ecdis_waypoints_delay_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_waypoints_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_waypoints_queue,
    rabbitmq_exchange.ecdis_waypoints_delay_exchange
  ]
}

resource "rabbitmq_exchange" "ecdis_status_exchange" {
  name  = var.ecdis_status_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = var.ecdis_status_exchange_config.type
    durable     = var.ecdis_status_exchange_config.durable
    auto_delete = var.ecdis_status_exchange_config.auto_delete
  }
}

resource "rabbitmq_queue" "ecdis_status_queue" {
  name  = var.ecdis_status_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.ecdis_status_queue_config.durable
    auto_delete = var.ecdis_status_queue_config.auto_delete
  }
}

resource "rabbitmq_binding" "ecdis_status_binding" {
  source           = var.ecdis_status_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_status_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_status_queue,
    rabbitmq_exchange.ecdis_status_exchange
  ]
}

resource "rabbitmq_binding" "ecdis_status_all_binding" {
  source           = var.ecdis_status_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_status_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_status_queue,
    rabbitmq_exchange.ecdis_status_exchange
  ]
}

resource "rabbitmq_queue" "ecdis_audit_queue" {
  name  = var.ecdis_audit_queue_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    durable     = var.ecdis_audit_queue_config.durable
    auto_delete = var.ecdis_audit_queue_config.auto_delete
  }
}

resource "rabbitmq_exchange" "ecdis_audit_exchange" {
  name  = var.ecdis_audit_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type        = var.ecdis_audit_exchange_config.type
    durable     = var.ecdis_audit_exchange_config.durable
    auto_delete = var.ecdis_audit_exchange_config.auto_delete
  }
}

resource "rabbitmq_binding" "ecdis_audit_binding" {
  source           = var.ecdis_audit_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_audit_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_audit_queue,
    rabbitmq_exchange.ecdis_audit_exchange
  ]
}

resource "rabbitmq_exchange" "ecdis_audit_delay_exchange" {
  name  = var.ecdis_audit_delay_exchange_config.name
  vhost = data.env_var.rabbit_vhost.value

  settings {
    type    = var.ecdis_audit_delay_exchange_config.type
    durable = var.ecdis_audit_delay_exchange_config.durable
    arguments = {
      x-delayed-type = var.ecdis_waypoints_exchange_config.type
    }
  }
}

resource "rabbitmq_binding" "ecdis_audit_delay_binding" {
  source           = var.ecdis_audit_delay_exchange_config.name
  vhost            = data.env_var.rabbit_vhost.value
  destination      = var.ecdis_audit_queue_config.name
  destination_type = "queue"
  routing_key      = module.rmq_config.default_queue_binding.routing_key

  depends_on = [
    rabbitmq_queue.ecdis_audit_queue,
    rabbitmq_exchange.ecdis_audit_delay_exchange
  ]
}