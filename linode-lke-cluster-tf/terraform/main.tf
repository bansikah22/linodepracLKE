# Configure the Linode Provider
provider "linode" {
  token = var.linode_token
}

# LKE Cluster Module
module "lke_cluster" {
  source = "./modules/lke-cluster"

  cluster_label      = var.cluster_label
  k8s_version        = var.k8s_version
  region             = var.region
  tags               = var.tags
  node_pools         = var.node_pools
  high_availability  = var.high_availability
}
