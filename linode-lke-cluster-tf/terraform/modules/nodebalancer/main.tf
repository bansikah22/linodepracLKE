terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.0"
    }
  }
}

# NodeBalancer Module
# This module creates a Linode NodeBalancer for load balancing

resource "linode_nodebalancer" "balancer" {
  label  = var.label
  region = var.region
  tags   = var.tags
}

resource "linode_nodebalancer_config" "config" {
  nodebalancer_id = linode_nodebalancer.balancer.id
  port            = var.port
  protocol        = var.protocol
  check           = var.health_check_type
  check_path      = var.health_check_path
  check_attempts  = var.health_check_attempts
  check_timeout   = var.health_check_timeout
  check_interval  = var.health_check_interval
  stickiness      = var.stickiness
  algorithm       = var.algorithm
}

# Create NodeBalancer nodes from LKE cluster nodes
resource "linode_nodebalancer_node" "nodes" {
  count           = var.node_count
  nodebalancer_id = linode_nodebalancer.balancer.id
  config_id       = linode_nodebalancer_config.config.id
  address         = var.node_addresses[count.index]
  label           = "lke-node-${count.index + 1}"
  mode            = var.node_mode
  weight          = var.node_weight
}
