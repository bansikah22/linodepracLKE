output "main_bucket_info" {
  description = "Information about the main object storage bucket"
  value = {
    label = linode_object_storage_bucket.main_bucket.label
    hostname = linode_object_storage_bucket.main_bucket.hostname
  }
}

output "main_bucket_url" {
  description = "URL for the main bucket"
  value = "https://${linode_object_storage_bucket.main_bucket.hostname}"
}

output "backup_bucket_info" {
  description = "Information about the backup bucket (if created)"
  value = var.create_backup_bucket ? {
    label = linode_object_storage_bucket.backup_bucket[0].label
    hostname = linode_object_storage_bucket.backup_bucket[0].hostname
  } : null
}

output "backup_bucket_url" {
  description = "URL for the backup bucket (if created)"
  value = var.create_backup_bucket ? "https://${linode_object_storage_bucket.backup_bucket[0].hostname}" : null
}

output "logs_bucket_info" {
  description = "Information about the logs bucket (if created)"
  value = var.create_logs_bucket ? {
    label = linode_object_storage_bucket.logs_bucket[0].label
    hostname = linode_object_storage_bucket.logs_bucket[0].hostname
  } : null
}

output "logs_bucket_url" {
  description = "URL for the logs bucket (if created)"
  value = var.create_logs_bucket ? "https://${linode_object_storage_bucket.logs_bucket[0].hostname}" : null
}

output "main_access_key" {
  description = "Main access key information"
  value = {
    label = linode_object_storage_key.main_key.label
    access_key = linode_object_storage_key.main_key.access_key
    secret_key = linode_object_storage_key.main_key.secret_key
    limited = linode_object_storage_key.main_key.limited
  }
  sensitive = true
}

output "readonly_access_key" {
  description = "Read-only access key information (if created)"
  value = var.create_readonly_key ? {
    label = linode_object_storage_key.readonly_key[0].label
    access_key = linode_object_storage_key.readonly_key[0].access_key
    secret_key = linode_object_storage_key.readonly_key[0].secret_key
    limited = linode_object_storage_key.readonly_key[0].limited
  } : null
  sensitive = true
}

output "backup_access_key" {
  description = "Backup access key information (if created)"
  value = var.create_backup_bucket && var.create_backup_key ? {
    label = linode_object_storage_key.backup_key[0].label
    access_key = linode_object_storage_key.backup_key[0].access_key
    secret_key = linode_object_storage_key.backup_key[0].secret_key
    limited = linode_object_storage_key.backup_key[0].limited
  } : null
  sensitive = true
}

output "logs_access_key" {
  description = "Logs access key information (if created)"
  value = var.create_logs_bucket && var.create_logs_key ? {
    label = linode_object_storage_key.logs_key[0].label
    access_key = linode_object_storage_key.logs_key[0].access_key
    secret_key = linode_object_storage_key.logs_key[0].secret_key
    limited = linode_object_storage_key.logs_key[0].limited
  } : null
  sensitive = true
}

output "s3_endpoint" {
  description = "S3-compatible endpoint for the cluster"
  value = "https://${var.cluster_region}.linodeobjects.com"
}

output "connection_info" {
  description = "Connection information for the object storage"
  value = {
    s3_endpoint = "https://${var.cluster_region}.linodeobjects.com"
    main_bucket = linode_object_storage_bucket.main_bucket.label
    backup_bucket = var.create_backup_bucket ? linode_object_storage_bucket.backup_bucket[0].label : null
    logs_bucket = var.create_logs_bucket ? linode_object_storage_bucket.logs_bucket[0].label : null
    cluster_region = var.cluster_region
  }
}

output "usage_examples" {
  description = "Example commands for using the object storage"
  value = {
    aws_cli_upload = "aws s3 cp file.txt s3://${linode_object_storage_bucket.main_bucket.label}/ --endpoint-url=https://${var.cluster_region}.linodeobjects.com"
    aws_cli_download = "aws s3 cp s3://${linode_object_storage_bucket.main_bucket.label}/file.txt ./ --endpoint-url=https://${var.cluster_region}.linodeobjects.com"
    curl_upload = "curl -X PUT -T file.txt https://${linode_object_storage_bucket.main_bucket.hostname}/file.txt"
    curl_download = "curl https://${linode_object_storage_bucket.main_bucket.hostname}/file.txt"
  }
}
