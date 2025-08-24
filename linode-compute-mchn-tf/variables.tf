variable "linode_token" {
  description = "Your Linode API token"
  type        = string
  sensitive   = true
}

variable "instance_label" {
  description = "Label for the Linode instance"
  type        = string
  default     = "terraform-web-server"
}

variable "region" {
  description = "The region where the Linode will be created"
  type        = string
  default     = "us-east"
  
  validation {
    condition = contains([
      "ap-west", "ap-southeast", "us-central", "us-east", "us-west", "us-southeast",
      "us-southwest", "eu-west", "ap-south", "eu-central", "ap-northeast"
    ], var.region)
    error_message = "Invalid region. Please choose a valid Linode region."
  }
}

variable "instance_type" {
  description = "The type of Linode instance"
  type        = string
  default     = "g6-standard-1"
  
  validation {
    condition = contains([
      "g6-standard-1", "g6-standard-2", "g6-standard-3", "g6-standard-4", "g6-standard-6",
      "g6-standard-7", "g6-standard-8", "g6-standard-10", "g6-standard-16", "g6-standard-20",
      "g6-standard-24", "g6-standard-32", "g6-standard-48", "g6-standard-50", "g6-standard-52",
      "g6-standard-56", "g6-standard-64", "g6-standard-96", "g6-standard-128"
    ], var.instance_type)
    error_message = "Invalid instance type. Please choose a valid Linode instance type."
  }
}

variable "image" {
  description = "The image to use for the Linode instance"
  type        = string
  default     = "linode/ubuntu22.04"
}

variable "root_password" {
  description = "Root password for the Linode instance (minimum 11 characters)"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.root_password) >= 11
    error_message = "Root password must be at least 11 characters long."
  }
}

variable "tags" {
  description = "Tags to apply to the Linode instance"
  type        = list(string)
  default     = ["terraform", "web-server"]
}

variable "create_volume" {
  description = "Whether to create and attach a block storage volume"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "Size of the block storage volume in GB"
  type        = number
  default     = 20
  
  validation {
    condition     = var.volume_size >= 10 && var.volume_size <= 10240
    error_message = "Volume size must be between 10 and 10240 GB."
  }
}
