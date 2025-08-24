output "nodebalancer_id" {
  description = "The ID of the NodeBalancer"
  value       = linode_nodebalancer.balancer.id
}

output "nodebalancer_ip" {
  description = "The IP address of the NodeBalancer"
  value       = linode_nodebalancer.balancer.ipv4
}

output "nodebalancer_hostname" {
  description = "The hostname of the NodeBalancer"
  value       = linode_nodebalancer.balancer.hostname
}

output "config_id" {
  description = "The ID of the NodeBalancer configuration"
  value       = linode_nodebalancer_config.config.id
}

output "node_ids" {
  description = "The IDs of the NodeBalancer nodes"
  value       = linode_nodebalancer_node.nodes[*].id
}
