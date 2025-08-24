variable "create_applications_namespace" {
  description = "Whether to create the applications namespace"
  type        = bool
  default     = true
}

variable "applications_namespace" {
  description = "Name of the applications namespace"
  type        = string
  default     = "applications"
}

variable "create_admin_user" {
  description = "Whether to create an admin user"
  type        = bool
  default     = true
}

variable "create_default_deny_policy" {
  description = "Whether to create a default deny network policy"
  type        = bool
  default     = true
}

variable "create_allow_all_system_policy" {
  description = "Whether to create an allow all policy for system namespaces"
  type        = bool
  default     = true
}

variable "create_pod_security_policy" {
  description = "Whether to create Pod Security Standards namespace"
  type        = bool
  default     = true
}
