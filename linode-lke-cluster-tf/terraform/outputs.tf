# Cluster Information
output "cluster_id" {
  description = "The ID of the LKE cluster"
  value       = module.lke_cluster.cluster_id
}

output "cluster_label" {
  description = "The label of the LKE cluster"
  value       = module.lke_cluster.cluster_label
}

output "cluster_region" {
  description = "The region of the LKE cluster"
  value       = module.lke_cluster.cluster_region
}

output "cluster_k8s_version" {
  description = "The Kubernetes version of the LKE cluster"
  value       = module.lke_cluster.cluster_k8s_version
}

output "cluster_status" {
  description = "The status of the LKE cluster"
  value       = module.lke_cluster.cluster_status
}

output "cluster_api_endpoints" {
  description = "The API endpoints of the LKE cluster"
  value       = module.lke_cluster.cluster_api_endpoints
}

output "cluster_pools" {
  description = "The node pools of the LKE cluster"
  value       = module.lke_cluster.cluster_pools
}

output "kubeconfig" {
  description = "Base64 encoded kubeconfig for the LKE cluster"
  value       = module.lke_cluster.kubeconfig
  sensitive   = true
}

output "dashboard_url" {
  description = "The URL for the Kubernetes dashboard"
  value       = module.lke_cluster.dashboard_url
}

# Connection Information
output "connection_info" {
  description = "Information needed to connect to the cluster"
  value = {
    cluster_id        = module.lke_cluster.cluster_id
    cluster_label     = module.lke_cluster.cluster_label
    k8s_version       = module.lke_cluster.cluster_k8s_version
    region            = module.lke_cluster.cluster_region
    status            = module.lke_cluster.cluster_status
    node_count        = sum([for pool in var.node_pools : pool.count])
    api_endpoints     = module.lke_cluster.cluster_api_endpoints
  }
}
