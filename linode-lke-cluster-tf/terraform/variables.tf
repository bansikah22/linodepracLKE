# Linode Configuration
variable "linode_token" {
  description = "Linode API token"
  type        = string
  sensitive   = true
}

# Cluster Configuration
variable "cluster_label" {
  description = "Label for the LKE cluster"
  type        = string
  default     = "my-lke-cluster"
}

variable "k8s_version" {
  description = "Kubernetes version for the LKE cluster"
  type        = string
  default     = "1.32"
}

variable "region" {
  description = "Region for the LKE cluster"
  type        = string
  default     = "us-east"
}

variable "tags" {
  description = "Tags for the LKE cluster"
  type        = list(string)
  default     = ["kubernetes", "lke", "production", "terraform"]
}

variable "node_pools" {
  description = "Node pools for the LKE cluster"
  type = list(object({
    type  = string
    count = number
    tags  = list(string)
  }))
  default = [
    {
      type  = "g6-standard-1"
      count = 2
      tags  = ["general", "worker"]
    }
  ]
}

variable "high_availability" {
  description = "Enable high availability for the LKE cluster"
  type        = bool
  default     = false
}
