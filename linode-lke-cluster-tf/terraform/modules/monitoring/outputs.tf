output "monitoring_namespace" {
  description = "Name of the monitoring namespace"
  value       = var.enable_monitoring ? kubernetes_namespace.monitoring[0].metadata[0].name : null
}

output "ingress_nginx_namespace" {
  description = "Name of the ingress-nginx namespace"
  value       = var.enable_ingress ? kubernetes_namespace.ingress_nginx[0].metadata[0].name : null
}

output "cert_manager_installed" {
  description = "Whether cert-manager is installed"
  value       = var.enable_cert_manager
}
