resource "google_pubsub_schema" "schema" {
  project    = var.project_id
  name       = var.schema_name
  type       = var.schema_type
  definition = var.schema_definition
}

resource "google_pubsub_topic" "topic" {
  count                      = var.no_of_topics
  project                    = var.project_id
  #kms_key_name               = var.kms_key_name
  name                       = var.topic_name[count.index]
  message_retention_duration = var.topic_message_retention_duration
  dynamic "schema_settings" {
    for_each = var.schema_settings ? [{}] : []
    content {
      schema   = google_pubsub_schema.schema.id
      encoding = var.encoding
    }
  }

  dynamic "message_storage_policy" {
    for_each = var.message_storage_policy ? [{}] : []
    content {
      allowed_persistence_regions = var.allowed_persistence_regions
    }
  }

  depends_on = [google_pubsub_schema.schema]
}

resource "google_pubsub_subscription" "subscription" {
  depends_on = [google_pubsub_topic.topic]
  count                      = var.no_of_subscriptions
  project                    = var.project_id
  name                       = var.subscription_name[count.index]
  topic                      = var.topic_name[count.index]
  message_retention_duration = var.message_retention_duration
  retain_acked_messages      = var.retain_acked_messages

  expiration_policy {
    ttl = "605000s"
  }
  ack_deadline_seconds         = var.ack_deadline_seconds
  #enable_exactly_once_delivery = var.enable_exactly_once_delivery
  enable_message_ordering      = var.enable_message_ordering

  # dynamic "bigquery_config" {
  #   for_each = var.bigquery_config ? [{}] : []
  #   content {
  #     table               = var.table
  #     use_topic_schema    = var.use_topic_schema
  #     write_metadata      = var.write_metadata
  #     drop_unknown_fields = var.drop_unknown_fields
  #   }
  # }

  dynamic "push_config" {
    for_each = var.push_config ? [{}] : []
    content {
      push_endpoint = var.push_endpoint
      attributes    = var.attributes
    }
  }

  dynamic "dead_letter_policy" {
    for_each = var.dead_letter_policy ? [{}] : []
    content {
      dead_letter_topic     = var.dead_letter_topic
      max_delivery_attempts = var.max_delivery_attempts
    }
  }

  dynamic "retry_policy" {
    for_each = var.retry_policy ? [{}] : []
    content {
      minimum_backoff = var.minimum_backoff
      maximum_backoff = var.maximum_backoff
    }

  }
}