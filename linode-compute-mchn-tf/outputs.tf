output "instance_id" {
  description = "The ID of the Linode instance"
  value       = linode_instance.web_server.id
}

output "instance_label" {
  description = "The label of the Linode instance"
  value       = linode_instance.web_server.label
}

output "instance_ip" {
  description = "The public IP address of the Linode instance"
  value       = tolist(linode_instance.web_server.ipv4)[0]
}

output "instance_private_ip" {
  description = "The private IP address of the Linode instance"
  value       = linode_instance.web_server.private_ip_address
}

output "instance_region" {
  description = "The region where the Linode instance is located"
  value       = linode_instance.web_server.region
}

output "instance_type" {
  description = "The type of the Linode instance"
  value       = linode_instance.web_server.type
}

output "instance_status" {
  description = "The status of the Linode instance"
  value       = linode_instance.web_server.status
}

output "firewall_id" {
  description = "The ID of the firewall"
  value       = linode_firewall.web_firewall.id
}

output "firewall_label" {
  description = "The label of the firewall"
  value       = linode_firewall.web_firewall.label
}

output "volume_id" {
  description = "The ID of the block storage volume (if created)"
  value       = var.create_volume ? linode_volume.data_volume[0].id : null
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh root@${tolist(linode_instance.web_server.ipv4)[0]}"
}

output "instance_summary" {
  description = "Summary of the created Linode instance"
  value = {
    id          = linode_instance.web_server.id
    label       = linode_instance.web_server.label
    ip_address  = tolist(linode_instance.web_server.ipv4)[0]
    region      = linode_instance.web_server.region
    type        = linode_instance.web_server.type
    status      = linode_instance.web_server.status
    firewall_id = linode_firewall.web_firewall.id
    ssh_command = "ssh root@${tolist(linode_instance.web_server.ipv4)[0]}"
  }
}
