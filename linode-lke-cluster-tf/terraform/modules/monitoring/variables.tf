variable "enable_monitoring" {
  description = "Whether to enable monitoring stack"
  type        = bool
  default     = true
}

variable "enable_ingress" {
  description = "Whether to enable NGINX ingress controller"
  type        = bool
  default     = true
}

variable "enable_cert_manager" {
  description = "Whether to enable cert-manager for SSL certificates"
  type        = bool
  default     = true
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "cert_manager_email" {
  description = "Email address for Let's Encrypt certificates"
  type        = string
  default     = "admin@example.com"
}
