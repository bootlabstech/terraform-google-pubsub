variable "pubsub_topic_id" {
  type        = string
  description = "ID of the topic."
}

variable "topic_labels" {
  type        = map(any)
  description = "Set of labels to identify the topic"
  default     = null
}

variable "schema_name" {
  type        = string
  description = "Messege schema name."
}

variable "is_schema_required" {
  type    = bool
  default = false
}

variable "pubsub_subscription_id" {
  type        = string
  description = "The name of subscription name."
}

variable "ack_deadline_seconds" {
  type        = number
  description = "This value is the maximum time after a subscriber receives a message before the subscriber should acknowledge the message. "
  
}

variable "message_retention_duration" {
  type        = string
  description = "How long to retain unacknowledged messages in the subscription's backlog."
  
}

variable "topic_message_retention_duration" {
  type = string
  description = "(optional) describe your variable"
}
variable "sub_lables" {
  type        = map(any)
  description = "subscription lables."
  default     = null
}

variable "max_delivery_attempts" {
  type = number
  description = "Max delivery attempts."
}

variable "push_endpoint" {
  type        = string
  description = "Endpoint to push the messeges."
  
}

variable "dead_letter_topicID" {
  type        = string
  description = "The name of the topic to which dead letter messages should be published. \n Format is projects/{project}/topics/{topic}"
  
}

variable "projectID" {
  type    = string
  
}

