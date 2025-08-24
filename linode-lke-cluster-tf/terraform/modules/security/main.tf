# Security Module
# This module sets up security configurations for the Kubernetes cluster

# Create namespace for applications
resource "kubernetes_namespace" "applications" {
  count = var.create_applications_namespace ? 1 : 0
  
  metadata {
    name = var.applications_namespace
    labels = {
      name = var.applications_namespace
    }
  }
}

# Create admin service account
resource "kubernetes_service_account" "admin_user" {
  count = var.create_admin_user ? 1 : 0
  
  metadata {
    name      = "admin-user"
    namespace = "default"
  }
}

# Create admin cluster role binding
resource "kubernetes_cluster_role_binding" "admin_user_binding" {
  count = var.create_admin_user ? 1 : 0
  
  metadata {
    name = "admin-user-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.admin_user[0].metadata[0].name
    namespace = "default"
  }
}

# Create default deny network policy
resource "kubernetes_network_policy" "default_deny" {
  count = var.create_default_deny_policy ? 1 : 0
  
  metadata {
    name      = "default-deny"
    namespace = var.applications_namespace
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }
}

# Create allow all network policy for system namespaces
resource "kubernetes_network_policy" "allow_all_system" {
  count = var.create_allow_all_system_policy ? 1 : 0
  
  metadata {
    name      = "allow-all-system"
    namespace = "kube-system"
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
    
    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "kube-system"
          }
        }
      }
    }
    
    egress {
      to {
        namespace_selector {
          match_labels = {
            name = "kube-system"
          }
        }
      }
    }
  }
}

# Create Pod Security Standards (modern approach)
resource "kubernetes_namespace" "restricted" {
  count = var.create_pod_security_policy ? 1 : 0
  
  metadata {
    name = "restricted"
    labels = {
      "pod-security.kubernetes.io/enforce" = "restricted"
      "pod-security.kubernetes.io/audit"   = "restricted"
      "pod-security.kubernetes.io/warn"    = "restricted"
    }
  }
}
