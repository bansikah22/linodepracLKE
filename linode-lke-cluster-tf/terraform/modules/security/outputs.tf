output "applications_namespace" {
  description = "Name of the applications namespace"
  value       = var.create_applications_namespace ? var.applications_namespace : null
}

output "admin_service_account_name" {
  description = "Name of the admin service account"
  value       = var.create_admin_user ? kubernetes_service_account.admin_user[0].metadata[0].name : null
}

output "admin_service_account_namespace" {
  description = "Namespace of the admin service account"
  value       = var.create_admin_user ? kubernetes_service_account.admin_user[0].metadata[0].namespace : null
}
