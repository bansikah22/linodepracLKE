# Monitoring Module
# This module sets up monitoring using community modules

# Use the community cert-manager module for SSL certificates
module "cert_manager" {
  count  = var.enable_cert_manager ? 1 : 0
  source = "terraform-iaac/cert-manager/kubernetes"
  version = "~> 2.0"

  cluster_issuer_email = var.cert_manager_email
  cluster_issuer_name = "letsencrypt-prod"
}

# Note: For Prometheus and Grafana, we'll use Helm charts directly
# as the Terraform modules are not available in the registry
# These can be deployed using kubectl and helm after cluster creation

# Create namespace for monitoring
resource "kubernetes_namespace" "monitoring" {
  count = var.enable_monitoring ? 1 : 0
  
  metadata {
    name = "monitoring"
    labels = {
      name = "monitoring"
    }
  }
}

# Create namespace for ingress-nginx
resource "kubernetes_namespace" "ingress_nginx" {
  count = var.enable_ingress ? 1 : 0
  
  metadata {
    name = "ingress-nginx"
    labels = {
      name = "ingress-nginx"
    }
  }
}
