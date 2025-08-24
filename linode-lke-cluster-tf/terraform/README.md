# Terraform Infrastructure for LKE Cluster

This directory contains the Terraform infrastructure code for deploying a Linode Kubernetes Engine (LKE) cluster with supporting components.

## 📁 Directory Structure

```
terraform/
├── modules/              # Reusable Terraform modules
│   ├── lke-cluster/     # LKE cluster module
│   ├── nodebalancer/    # Load balancer module
│   ├── security/        # Security configurations
│   └── monitoring/      # Monitoring framework
├── main.tf              # Main Terraform configuration
├── variables.tf         # Variable definitions
├── outputs.tf           # Output definitions
├── versions.tf          # Provider versions
├── terraform.tfvars     # Configuration values
├── setup.sh             # Infrastructure deployment script
├── destroy.sh           # Infrastructure cleanup script
└── README.md           # This file
```

## 🚀 Quick Start

### Prerequisites
- **Terraform**: Version 1.0 or higher
- **Linode Account**: With API token
- **Bash**: For running scripts

### 1. Configure Your Environment
```bash
# Copy the example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit the configuration with your values
nano terraform.tfvars
```

### 2. Deploy Infrastructure
```bash
./setup.sh
```

### 3. Access Your Cluster
```bash
# Get cluster information
terraform output

# Copy kubeconfig to kubernetes directory
cp kubeconfig.yaml ../kubernetes/
```

## 🔧 Configuration

### Required Variables

Edit `terraform.tfvars`:

```hcl
# Linode API Token (required)
linode_token = "your-api-token"

# Cluster Configuration
cluster_label = "my-lke-cluster"
k8s_version   = "1.32"
region        = "us-east"

# Node Pools
node_pools = [
  {
    type  = "g6-standard-1"
    count = 2
    tags  = ["worker"]
  }
]

# Tags
tags = ["production", "kubernetes"]
```

### Optional Variables

```hcl
# Enable additional features
enable_monitoring = true
enable_security   = true

# NodeBalancer Configuration
nodebalancer_port = 80
nodebalancer_protocol = "http"
```

## 🏗️ Modules

### LKE Cluster Module (`modules/lke-cluster/`)
- **Purpose**: Creates and manages the LKE cluster
- **Features**:
  - Configurable node pools
  - Kubernetes version selection
  - Region selection
  - Tagging support

### NodeBalancer Module (`modules/nodebalancer/`)
- **Purpose**: Creates load balancer for external access
- **Features**:
  - HTTP/HTTPS support
  - Health checks
  - Configurable algorithms
  - Node management

### Security Module (`modules/security/`)
- **Purpose**: Implements security configurations
- **Features**:
  - RBAC setup
  - Network policies
  - Service accounts
  - Namespace isolation

### Monitoring Module (`modules/monitoring/`)
- **Purpose**: Sets up monitoring framework
- **Features**:
  - Monitoring namespaces
  - Ingress namespaces
  - Ready for Prometheus/Grafana

## 📊 Outputs

After successful deployment, you'll get:

```bash
# Cluster Information
cluster_id = "12345"
cluster_label = "my-lke-cluster"
cluster_region = "us-east"
cluster_k8s_version = "1.32"
cluster_status = "ready"

# Access Information
kubeconfig = "base64-encoded-kubeconfig"
dashboard_url = "https://us-east.linode.com/..."

# NodeBalancer Information
nodebalancer_id = "67890"
nodebalancer_ip = "192.168.1.100"
nodebalancer_hostname = "nb-192-168-1-100.us-east.linode.com"
```

## 🐛 Troubleshooting

### Common Issues

1. **API Token Issues**
   ```bash
   # Verify token permissions
   curl -H "Authorization: Bearer $LINODE_TOKEN" \
        https://api.linode.com/v4/account
   ```

2. **Terraform State Issues**
   ```bash
   # Check state
   terraform state list
   
   # Refresh state
   terraform refresh
   ```

3. **Provider Issues**
   ```bash
   # Reinitialize providers
   terraform init -upgrade
   ```

### Debug Commands

```bash
# Plan deployment
terraform plan

# Apply changes
terraform apply

# Check resources
terraform state list

# View outputs
terraform output

# Destroy infrastructure
terraform destroy
```

## 🔒 Security Considerations

### API Token Security
- Store tokens securely
- Use environment variables when possible
- Rotate tokens regularly
- Limit token permissions

### Network Security
- Use private networking
- Implement firewall rules
- Configure network policies
- Monitor network traffic

## 💰 Cost Optimization

### Resource Sizing
- Choose appropriate instance types
- Use resource limits
- Monitor usage patterns
- Scale based on demand

### Best Practices
- Use tags for cost tracking
- Implement auto-scaling
- Monitor resource usage
- Clean up unused resources

## 🔄 Maintenance

### Regular Tasks
1. **Update Kubernetes Version**: Check for new LKE versions
2. **Review Security**: Update security policies
3. **Monitor Costs**: Track resource usage
4. **Backup State**: Backup Terraform state files

### Updates
```bash
# Update Terraform providers
terraform init -upgrade

# Update modules
terraform get -update

# Plan updates
terraform plan
```

## 📚 Documentation

- **Main README**: Project overview
- **Module READMEs**: Individual module documentation
- **Linode Documentation**: [LKE Documentation](https://www.linode.com/docs/products/compute/kubernetes/)
- **Terraform Documentation**: [Linode Provider](https://registry.terraform.io/providers/linode/linode/latest/docs)

## 🚀 Next Steps

After infrastructure deployment:

1. **Deploy Applications**: Navigate to `../kubernetes/`
2. **Set Up Monitoring**: Deploy Prometheus and Grafana
3. **Configure Security**: Apply additional security policies
4. **Set Up CI/CD**: Integrate with deployment pipelines
5. **Implement Backup**: Set up Velero for backup/restore

---

**Infrastructure ready for applications! 🚀**
