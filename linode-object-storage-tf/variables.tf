variable "linode_token" {
  description = "Linode API token"
  type        = string
  sensitive   = true
}

variable "bucket_label" {
  description = "Label for the main object storage bucket"
  type        = string
  default     = "my-object-storage"
}

variable "cluster_region" {
  description = "Linode Object Storage cluster region"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition = contains([
      "us-east-1",    # Newark, NJ
      "us-southeast-1", # Atlanta, GA
      "us-west-1",    # Fremont, CA
      "ap-west-1",    # Mumbai, India
      "ap-southeast-1", # Singapore
      "eu-central-1", # Frankfurt, Germany
      "eu-west-1",    # London, UK
      "ca-central-1"  # Toronto, Canada
    ], var.cluster_region)
    error_message = "Invalid cluster region. Must be one of the supported Linode Object Storage regions."
  }
}

variable "access_key" {
  description = "Access key for object storage (leave empty to auto-generate)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "secret_key" {
  description = "Secret key for object storage (leave empty to auto-generate)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_versioning" {
  description = "Enable versioning for the main bucket"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules for the main bucket"
  type        = bool
  default     = true
}

variable "lifecycle_expiration_days" {
  description = "Number of days after which objects expire"
  type        = number
  default     = 365
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days after which noncurrent versions expire"
  type        = number
  default     = 30
}

variable "abort_incomplete_multipart_days" {
  description = "Number of days after which incomplete multipart uploads are aborted"
  type        = number
  default     = 7
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allowed_methods" {
  description = "List of allowed HTTP methods for CORS"
  type        = list(string)
  default     = ["GET", "PUT", "POST", "DELETE", "HEAD"]
}

variable "cors_allowed_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_exposed_headers" {
  description = "List of exposed headers for CORS"
  type        = list(string)
  default     = ["ETag"]
}

variable "cors_max_age_seconds" {
  description = "Maximum age in seconds for CORS preflight requests"
  type        = number
  default     = 3000
}

variable "create_backup_bucket" {
  description = "Create a separate bucket for backups"
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "Number of days to retain backup objects"
  type        = number
  default     = 2555  # 7 years
}

variable "create_logs_bucket" {
  description = "Create a separate bucket for logs"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain log objects"
  type        = number
  default     = 90
}

variable "create_readonly_key" {
  description = "Create a read-only access key for applications"
  type        = bool
  default     = true
}

variable "create_backup_key" {
  description = "Create a dedicated key for backup operations"
  type        = bool
  default     = false
}

variable "create_logs_key" {
  description = "Create a dedicated key for log operations"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the buckets"
  type        = list(string)
  default     = ["terraform", "object-storage", "production"]
}
