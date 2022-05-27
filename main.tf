resource "google_pubsub_topic" "pubsub_topic" {
  name   = var.pubsub_topic_id
  labels = var.topic_labels

  message_retention_duration = var.topic_message_retention_duration
}


resource "google_pubsub_schema" "pubsub_schema" {
  count      = var.is_schema_required ? 1 : 0
  name       = var.schema_name
  type       = "AVRO"
  definition = "{\n  \"type\" : \"record\",\n  \"name\" : \"Avro\",\n  \"fields\" : [\n    {\n      \"name\" : \"StringField\",\n      \"type\" : \"string\"\n    },\n    {\n      \"name\" : \"IntField\",\n      \"type\" : \"int\"\n    }\n  ]\n}\n"
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  name                       = var.pubsub_subscription_id
  topic                      = google_pubsub_topic.pubsub_topic.name
  ack_deadline_seconds       = var.ack_deadline_seconds
  message_retention_duration = var.message_retention_duration
  labels                     = var.sub_lables

  push_config {
    push_endpoint = var.push_endpoint
  }

  dead_letter_policy {
    dead_letter_topic     = "projects/${var.projectID}/topics/${var.dead_letter_topicID}"
    max_delivery_attempts = var.max_delivery_attempts
  }

  depends_on = [
    google_pubsub_topic.pubsub_topic
  ]
}

