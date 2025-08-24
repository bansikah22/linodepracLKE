# Linode Infrastructure Projects

A collection of production-ready Linode infrastructure projects with Terraform and Kubernetes.

## 🏗️ Project Overview

This repository contains multiple Linode infrastructure projects:

### 1. **LKE Cluster** (`linode-lke-cluster-tf/`)
- **Modular Infrastructure**: Terraform modules for LKE cluster, security, and monitoring
- **Application Layer**: Kubernetes manifests for applications, monitoring, security, RBAC, and ingress
- **Automated Deployment**: Scripts for infrastructure and application deployment
- **Production Ready**: Security policies, monitoring, RBAC, and best practices

### 2. **Object Storage** (`linode-object-storage-tf/`)
- **S3-Compatible Storage**: Linode Object Storage with full S3 API compatibility
- **Multiple Buckets**: Main, backup, and logs buckets with different retention policies
- **Access Management**: Multiple access keys with different permissions
- **Lifecycle Policies**: Automatic cleanup of old versions and incomplete uploads
- **CORS Configuration**: Cross-origin resource sharing for web applications

## 📁 Project Structure

```
linodepracLKE/
├── linode-lke-cluster-tf/      # Kubernetes Cluster Project
│   ├── terraform/              # Infrastructure as Code
│   │   ├── modules/            # Reusable Terraform modules
│   │   │   ├── lke-cluster/    # LKE cluster module
│   │   │   ├── security/       # Security configurations
│   │   │   └── monitoring/     # Monitoring framework
│   │   ├── main.tf             # Main Terraform configuration
│   │   ├── variables.tf        # Variable definitions
│   │   ├── outputs.tf          # Output definitions
│   │   ├── versions.tf         # Provider versions
│   │   ├── terraform.tfvars    # Configuration values
│   │   ├── setup.sh            # Infrastructure deployment script
│   │   └── destroy.sh          # Infrastructure cleanup script
│   ├── kubernetes/             # Kubernetes Applications
│   │   ├── manifests/          # Kubernetes manifest files
│   │   │   ├── apps/           # Application deployments
│   │   │   ├── monitoring/     # Monitoring stack
│   │   │   ├── security/       # Security policies
│   │   │   ├── rbac/           # Role-Based Access Control
│   │   │   └── ingress/        # Ingress configurations
│   │   ├── scripts/            # Deployment scripts
│   │   │   ├── deploy.sh       # Application deployment
│   │   │   ├── cleanup.sh      # Application cleanup
│   │   │   └── setup-kubectl.sh # kubectl configuration
│   │   ├── kubeconfig.yaml     # Cluster access configuration
│   │   └── README.md           # Kubernetes documentation
│   ├── docs/                   # Project documentation
│   │   ├── README.md           # Documentation index
│   │   ├── RBAC.md             # RBAC implementation guide
│   │   ├── RBAC_QUICK_REFERENCE.md # RBAC quick reference
│   │   ├── DEPLOYMENT.md       # Deployment guide
│   │   ├── POST_DEPLOYMENT.md  # Post-deployment tasks
│   │   └── STRUCTURE.md        # Architecture documentation
│   └── README.md              # LKE Cluster documentation
├── linode-object-storage-tf/   # Object Storage Project
│   ├── main.tf                 # Main Terraform configuration
│   ├── variables.tf            # Variable definitions
│   ├── outputs.tf              # Output definitions
│   ├── terraform.tfvars.example # Example configuration
│   ├── setup.sh                # Deployment script
│   ├── destroy.sh              # Cleanup script
│   ├── test-setup.sh           # Test script
│   └── README.md              # Object Storage documentation
└── README.md                  # This file
```

## 🚀 Quick Start

### LKE Cluster Deployment
```bash
# 1. Deploy Infrastructure
cd linode-lke-cluster-tf/terraform
./setup.sh

# 2. Configure kubectl (Optional)
cd ../kubernetes
./scripts/setup-kubectl.sh permanent

# 3. Deploy Applications
./scripts/deploy.sh

# 4. Access Applications
# LoadBalancer: http://143.42.179.193 (nginx)
# Port Forward: kubectl port-forward svc/nginx-service 8080:80
```

### Object Storage Deployment
```bash
# 1. Configure
cd linode-object-storage-tf
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your settings

# 2. Deploy
./setup.sh

# 3. Test
./test-setup.sh

# 4. Use with AWS CLI
aws s3 ls --endpoint-url=https://us-east-1.linodeobjects.com
```

## 🎯 Features

### LKE Cluster Features
- **Managed Kubernetes**: Linode Kubernetes Engine with 2 nodes
- **Modular Design**: Reusable Terraform modules
- **Security Framework**: RBAC, network policies, security contexts
- **Monitoring Stack**: Prometheus for metrics collection
- **LoadBalancer Services**: Automatic external access
- **RBAC Implementation**: Multiple roles (Developer, Monitoring, Read-Only, Application)

### Object Storage Features
- **S3 Compatibility**: Full S3 API compatibility
- **Multiple Buckets**: Main, backup, and logs buckets
- **Access Management**: Multiple access keys with different permissions
- **Lifecycle Policies**: Automatic cleanup of old versions
- **CORS Configuration**: Cross-origin resource sharing
- **Versioning**: Object versioning for data protection

## 🔧 Configuration

### LKE Cluster Configuration
- **Kubernetes Version**: 1.32
- **Node Count**: 2 nodes (g6-standard-1)
- **Region**: us-east
- **Security**: RBAC, network policies, Pod Security Standards
- **Monitoring**: Prometheus with LoadBalancer access

### Object Storage Configuration
- **Regions**: 8 available regions worldwide
- **Buckets**: Main, backup (7-year retention), logs (90-day retention)
- **Access Keys**: Main, read-only, backup, logs keys
- **Lifecycle**: Automatic cleanup and version management
- **CORS**: Configurable for web applications

## 📊 Available Regions

### LKE Clusters
- us-east (Newark, NJ)
- us-central (Dallas, TX)
- us-west (Fremont, CA)
- us-southeast (Atlanta, GA)
- ap-west (Mumbai, India)
- ap-southeast (Singapore)
- eu-central (Frankfurt, Germany)
- eu-west (London, UK)
- ca-central (Toronto, Canada)

### Object Storage
- us-east-1 (Newark, NJ)
- us-southeast-1 (Atlanta, GA)
- us-west-1 (Fremont, CA)
- ap-west-1 (Mumbai, India)
- ap-southeast-1 (Singapore)
- eu-central-1 (Frankfurt, Germany)
- eu-west-1 (London, UK)
- ca-central-1 (Toronto, Canada)

## 🔐 Security Features

### LKE Cluster Security
- **RBAC**: Role-based access control with multiple roles
- **Network Policies**: Pod-to-pod communication control
- **Pod Security Standards**: Modern security policies
- **Service Accounts**: Secure application authentication
- **Namespace Isolation**: Separate namespaces for applications

### Object Storage Security
- **Access Key Management**: Multiple keys with different permissions
- **CORS Policies**: Configurable cross-origin access
- **Lifecycle Policies**: Automatic data cleanup
- **Versioning**: Protection against accidental deletion
- **Bucket Isolation**: Separate buckets for different purposes

## 💰 Cost Optimization

### LKE Cluster
- **2-Node Cluster**: Cost-effective for development/testing
- **Resource Limits**: Prevent over-provisioning
- **Auto-scaling**: Framework for future scaling
- **Monitoring**: Track resource usage

### Object Storage
- **Lifecycle Policies**: Automatic cleanup reduces storage costs
- **Versioning Control**: Manage versioning based on needs
- **Regional Selection**: Choose region closest to users
- **Access Key Management**: Use appropriate permissions

## 🐛 Troubleshooting

### LKE Cluster Issues
```bash
# Check cluster status
kubectl get nodes

# Check applications
kubectl get pods --all-namespaces

# Check RBAC
kubectl get serviceaccounts -n rbac
kubectl auth can-i --as=system:serviceaccount:rbac:developer-sa create deployments
```

### Object Storage Issues
```bash
# Check bucket status
terraform output main_bucket_info

# Test connectivity
curl -I https://your-bucket-name.us-east-1.linodeobjects.com

# Test with AWS CLI
aws s3 ls --endpoint-url=https://us-east-1.linodeobjects.com
```

## 🧹 Cleanup

### LKE Cluster Cleanup
```bash
# Remove applications
cd linode-lke-cluster-tf/kubernetes
./scripts/cleanup.sh

# Remove infrastructure
cd ../terraform
./destroy.sh
```

### Object Storage Cleanup
```bash
# Remove all resources
cd linode-object-storage-tf
./destroy.sh
```

## 🔄 Best Practices

### Infrastructure
- **Modular Design**: Separate infrastructure from applications
- **Security First**: Implement security policies early
- **Monitoring**: Set up monitoring from the start
- **Documentation**: Keep documentation updated
- **Testing**: Test deployments thoroughly

### Object Storage
- **Use read-only keys for applications**
- **Rotate access keys regularly**
- **Implement proper CORS policies**
- **Use lifecycle policies for data cleanup**
- **Choose appropriate regions**

## 🚀 Next Steps

1. **Production Hardening**: Add more security policies
2. **CI/CD Integration**: Set up automated deployments
3. **Monitoring Enhancement**: Add Grafana and Alertmanager
4. **Backup Strategy**: Implement Velero for backup/restore
5. **Multi-Region**: Deploy across multiple regions
6. **Application Scaling**: Add more applications and services
7. **CDN Integration**: Add CDN for improved performance

## 📚 Documentation

### LKE Cluster
- **README.md**: Project overview and quick start
- **terraform/README.md**: Infrastructure documentation
- **kubernetes/README.md**: Application deployment guide
- **docs/**: Detailed documentation including RBAC guides

### Object Storage
- **README.md**: Project overview and quick start
- **S3 Compatibility**: Full S3 API compatibility
- **Usage Examples**: AWS CLI, cURL, Python, JavaScript

## 🔗 Resources

- **Linode Documentation**: [LKE Documentation](https://www.linode.com/docs/products/compute/kubernetes/)
- **Object Storage**: [Object Storage Documentation](https://www.linode.com/docs/products/storage/object-storage/)
- **Terraform Provider**: [Linode Provider](https://registry.terraform.io/providers/linode/linode/latest/docs)
- **Kubernetes**: [Official Kubernetes Docs](https://kubernetes.io/docs/)
- **S3 API**: [AWS S3 API](https://docs.aws.amazon.com/AmazonS3/latest/API/)

## 📄 License

This project is licensed under the same license as the parent repository.

---

**Ready to deploy your Linode infrastructure! 🚀**
