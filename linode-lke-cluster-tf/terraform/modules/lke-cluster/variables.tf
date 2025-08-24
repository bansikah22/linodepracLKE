variable "cluster_label" {
  description = "The unique label to assign to this cluster"
  type        = string
}

variable "k8s_version" {
  description = "The Kubernetes version to use for this cluster"
  type        = string
}

variable "region" {
  description = "The region where the cluster will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the cluster"
  type        = list(string)
  default     = []
}

variable "node_pools" {
  description = "List of node pools to create in the cluster"
  type = list(object({
    type  = string
    count = number
    tags  = list(string)
  }))
}

variable "high_availability" {
  description = "Whether to enable high availability for the control plane"
  type        = bool
  default     = true
}
