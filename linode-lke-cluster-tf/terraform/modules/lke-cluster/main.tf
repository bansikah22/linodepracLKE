terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.0"
    }
  }
}

# LKE Cluster Module
# This module creates a Linode Kubernetes Engine cluster with configurable node pools

resource "linode_lke_cluster" "cluster" {
  label       = var.cluster_label
  k8s_version = var.k8s_version
  region      = var.region
  tags        = var.tags

  # Define node pools dynamically
  dynamic "pool" {
    for_each = var.node_pools
    content {
      type  = pool.value.type
      count = pool.value.count
      tags  = pool.value.tags
    }
  }

  # Note: high_availability is not supported in current Linode provider version
}
