output "cluster_id" {
  description = "The ID of the LKE cluster"
  value       = linode_lke_cluster.cluster.id
}

output "cluster_label" {
  description = "The label of the LKE cluster"
  value       = linode_lke_cluster.cluster.label
}

output "cluster_region" {
  description = "The region of the LKE cluster"
  value       = linode_lke_cluster.cluster.region
}

output "cluster_k8s_version" {
  description = "The Kubernetes version of the LKE cluster"
  value       = linode_lke_cluster.cluster.k8s_version
}

output "cluster_status" {
  description = "The status of the LKE cluster"
  value       = linode_lke_cluster.cluster.status
}

output "cluster_api_endpoints" {
  description = "The API endpoints of the LKE cluster"
  value       = linode_lke_cluster.cluster.api_endpoints
}

output "cluster_pools" {
  description = "The node pools of the LKE cluster"
  value       = linode_lke_cluster.cluster.pool
}

output "kubeconfig" {
  description = "Base64 encoded kubeconfig for the LKE cluster"
  value       = linode_lke_cluster.cluster.kubeconfig
  sensitive   = true
}

output "dashboard_url" {
  description = "The URL for the Kubernetes dashboard"
  value       = "https://${linode_lke_cluster.cluster.api_endpoints[0]}"
}
