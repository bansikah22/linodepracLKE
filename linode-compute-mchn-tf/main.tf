# Configure the Linode Provider
provider "linode" {
  token = var.linode_token
}

# =============================================================================
# COMPUTE INSTANCE
# =============================================================================

# Create a Linode compute instance
resource "linode_instance" "web_server" {
  label     = var.instance_label
  region    = var.region
  type      = var.instance_type
  image     = var.image
  root_pass = var.root_password

  # Optional: Add tags for better organization
  tags = var.tags

  # Optional: Add private IP
  private_ip = true

}

# =============================================================================
# NETWORK SECURITY
# =============================================================================

# Create a firewall for the instance
resource "linode_firewall" "web_firewall" {
  label = "${var.instance_label}-firewall"

  # Default policies
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  # SSH access
  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  # HTTP traffic
  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  # HTTPS traffic
  inbound {
    label    = "allow-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  # Outbound traffic
  outbound {
    label    = "allow-all-outbound"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  linodes = [linode_instance.web_server.id]
}

# =============================================================================
# BLOCK STORAGE
# =============================================================================

# Create a block storage volume (optional)
resource "linode_volume" "data_volume" {
  count  = var.create_volume ? 1 : 0
  label  = "${var.instance_label}-data"
  region = var.region
  size   = var.volume_size
  linode_id = linode_instance.web_server.id
}
