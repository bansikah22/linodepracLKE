variable "label" {
  description = "The label for the NodeBalancer"
  type        = string
}

variable "region" {
  description = "The region where the NodeBalancer will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the NodeBalancer"
  type        = list(string)
  default     = []
}

variable "port" {
  description = "The port to configure for the NodeBalancer"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "The protocol to use for the NodeBalancer"
  type        = string
  default     = "http"
}

variable "health_check_type" {
  description = "The type of health check to perform"
  type        = string
  default     = "http"
}

variable "health_check_path" {
  description = "The path to check for health checks"
  type        = string
  default     = "/"
}

variable "health_check_attempts" {
  description = "Number of health check attempts"
  type        = number
  default     = 3
}

variable "health_check_timeout" {
  description = "Timeout for health checks in seconds"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Interval between health checks in seconds"
  type        = number
  default     = 10
}

variable "stickiness" {
  description = "Session stickiness type"
  type        = string
  default     = "none"
}

variable "algorithm" {
  description = "Load balancing algorithm"
  type        = string
  default     = "roundrobin"
}

variable "node_count" {
  description = "Number of nodes to add to the NodeBalancer"
  type        = number
}

variable "node_addresses" {
  description = "List of node IP addresses"
  type        = list(string)
}

variable "node_mode" {
  description = "Mode for the nodes"
  type        = string
  default     = "accept"
}

variable "node_weight" {
  description = "Weight for the nodes"
  type        = number
  default     = 50
}
