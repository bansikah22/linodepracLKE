terraform {
  required_version = ">= 1.0"
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.0"
    }
  }
}

# Configure the Linode Provider
provider "linode" {
  token = var.linode_token
}

# Create Object Storage Bucket
resource "linode_object_storage_bucket" "main_bucket" {
  label = var.bucket_label
  cluster = var.cluster_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create additional buckets for different purposes
resource "linode_object_storage_bucket" "backup_bucket" {
  count = var.create_backup_bucket ? 1 : 0
  
  label = "${var.bucket_label}-backup"
  cluster = var.cluster_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "linode_object_storage_bucket" "logs_bucket" {
  count = var.create_logs_bucket ? 1 : 0
  
  label = "${var.bucket_label}-logs"
  cluster = var.cluster_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create Object Storage Key for API access
resource "linode_object_storage_key" "main_key" {
  label = "${var.bucket_label}-access-key"
  bucket_access {
    bucket_name = linode_object_storage_bucket.main_bucket.label
    cluster     = var.cluster_region
    permissions = "read_write"
  }
  
  dynamic "bucket_access" {
    for_each = var.create_backup_bucket ? [1] : []
    content {
      bucket_name = linode_object_storage_bucket.backup_bucket[0].label
      cluster     = var.cluster_region
      permissions = "read_write"
    }
  }
  
  dynamic "bucket_access" {
    for_each = var.create_logs_bucket ? [1] : []
    content {
      bucket_name = linode_object_storage_bucket.logs_bucket[0].label
      cluster     = var.cluster_region
      permissions = "read_write"
    }
  }
}

# Create a read-only key for applications
resource "linode_object_storage_key" "readonly_key" {
  count = var.create_readonly_key ? 1 : 0
  
  label = "${var.bucket_label}-readonly-key"
  bucket_access {
    bucket_name = linode_object_storage_bucket.main_bucket.label
    cluster     = var.cluster_region
    permissions = "read_only"
  }
  
  dynamic "bucket_access" {
    for_each = var.create_backup_bucket ? [1] : []
    content {
      bucket_name = linode_object_storage_bucket.backup_bucket[0].label
      cluster     = var.cluster_region
      permissions = "read_only"
    }
  }
  
  dynamic "bucket_access" {
    for_each = var.create_logs_bucket ? [1] : []
    content {
      bucket_name = linode_object_storage_bucket.logs_bucket[0].label
      cluster     = var.cluster_region
      permissions = "read_only"
    }
  }
}

# Create a key for backup operations
resource "linode_object_storage_key" "backup_key" {
  count = var.create_backup_bucket && var.create_backup_key ? 1 : 0
  
  label = "${var.bucket_label}-backup-key"
  bucket_access {
    bucket_name = linode_object_storage_bucket.backup_bucket[0].label
    cluster     = var.cluster_region
    permissions = "read_write"
  }
}

# Create a key for log operations
resource "linode_object_storage_key" "logs_key" {
  count = var.create_logs_bucket && var.create_logs_key ? 1 : 0
  
  label = "${var.bucket_label}-logs-key"
  bucket_access {
    bucket_name = linode_object_storage_bucket.logs_bucket[0].label
    cluster     = var.cluster_region
    permissions = "read_write"
  }
}
