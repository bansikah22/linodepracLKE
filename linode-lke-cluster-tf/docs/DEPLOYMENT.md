# LKE Cluster Deployment Guide

This guide provides step-by-step instructions for deploying a Linode Kubernetes Engine (LKE) cluster using Terraform.

## Prerequisites

Before you begin, ensure you have the following:

1. **Linode Account**: A Linode account with billing information set up
2. **API Token**: A Linode API Personal Access Token with appropriate permissions
3. **Terraform**: Terraform version 1.0 or higher installed
4. **kubectl**: Kubernetes command-line tool (optional but recommended)

## Step 1: Get Your Linode API Token

1. Log in to your Linode account at [cloud.linode.com](https://cloud.linode.com)
2. Navigate to **Profile** → **API Tokens**
3. Click **Create a Personal Access Token**
4. Give it a descriptive name (e.g., "Terraform LKE")
5. Set the expiration as needed
6. Ensure the following permissions are granted:
   - **Linodes**: Read/Write
   - **NodeBalancers**: Read/Write
   - **LKE**: Read/Write
   - **Volumes**: Read/Write
7. Copy the generated token and keep it secure

## Step 2: Configure Your Deployment

1. Navigate to the LKE cluster directory:
   ```bash
   cd linode-lke-cluster-tf
   ```

2. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Edit the variables file with your configuration:
   ```bash
   nano terraform.tfvars
   ```

   **Required changes:**
   - Replace `your-linode-api-token-here` with your actual API token
   - Update `cluster_label` with a unique name for your cluster
   - Choose your preferred `region`
   - Adjust `node_pools` configuration based on your needs

## Step 3: Deploy the Cluster

### Option A: Using the Setup Script (Recommended)

1. Run the setup script:
   ```bash
   ./setup.sh
   ```

2. The script will:
   - Check prerequisites
   - Initialize Terraform
   - Show the deployment plan
   - Ask for confirmation before applying

### Option B: Manual Deployment

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the deployment plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Step 4: Access Your Cluster

After successful deployment, you can access your cluster:

1. **Save your kubeconfig**:
   ```bash
   terraform output -raw kubeconfig > kubeconfig.yaml
   ```

2. **Test the connection**:
   ```bash
   kubectl --kubeconfig kubeconfig.yaml get nodes
   ```

3. **View cluster information**:
   ```bash
   kubectl --kubeconfig kubeconfig.yaml cluster-info
   ```

## Step 5: Verify Deployment

1. **Check node status**:
   ```bash
   kubectl --kubeconfig kubeconfig.yaml get nodes -o wide
   ```

2. **Check system pods**:
   ```bash
   kubectl --kubeconfig kubeconfig.yaml get pods --all-namespaces
   ```

3. **Check NodeBalancer**:
   ```bash
   terraform output nodebalancer_ip
   terraform output nodebalancer_hostname
   ```

## Configuration Options

### Node Pools

You can configure multiple node pools for different workloads:

```hcl
node_pools = [
  {
    type  = "g6-standard-1"  # 1 CPU, 2GB RAM
    count = 3
    tags  = ["worker", "general"]
  },
  {
    type  = "g6-standard-4"  # 4 CPU, 8GB RAM
    count = 2
    tags  = ["worker", "high-performance"]
  }
]
```

### Available Linode Types

- **g6-standard-1**: 1 CPU, 2GB RAM
- **g6-standard-2**: 2 CPU, 4GB RAM
- **g6-standard-4**: 4 CPU, 8GB RAM
- **g6-standard-6**: 6 CPU, 16GB RAM
- **g6-standard-8**: 8 CPU, 32GB RAM
- **g6-standard-16**: 16 CPU, 64GB RAM

### Regions

Available regions include:
- `us-east` (Newark, NJ)
- `us-central` (Dallas, TX)
- `us-west` (Fremont, CA)
- `us-southeast` (Atlanta, GA)
- `eu-west` (London, UK)
- `eu-central` (Frankfurt, DE)
- `ap-south` (Singapore)
- `ap-northeast` (Tokyo, JP)
- `ap-southeast` (Sydney, AU)

## Troubleshooting

### Common Issues

1. **API Token Issues**:
   - Ensure your API token has the correct permissions
   - Verify the token is valid and not expired

2. **Region Availability**:
   - Some Linode types may not be available in all regions
   - Check the Linode status page for region availability

3. **Node Pool Configuration**:
   - Ensure node pool count is between 1 and 100
   - Verify the Linode type is valid

4. **Network Issues**:
   - Check your internet connection
   - Verify firewall settings

### Getting Help

- Check the [Linode LKE Documentation](https://www.linode.com/docs/products/compute/kubernetes/)
- Review [Terraform Linode Provider Documentation](https://registry.terraform.io/providers/linode/linode/latest/docs)
- Contact Linode Support for platform-specific issues

## Next Steps

After successful deployment, consider:

1. **Setting up monitoring**: Configure Prometheus and Grafana
2. **Installing applications**: Deploy your applications to the cluster
3. **Configuring ingress**: Set up ingress controllers for external access
4. **Setting up CI/CD**: Configure automated deployment pipelines
5. **Backup strategy**: Implement backup solutions for your applications

## Security Considerations

- Keep your API token secure and never commit it to version control
- Use RBAC to control access to your cluster
- Regularly update your cluster and applications
- Monitor cluster activity and logs
- Consider using private networking for internal communication
