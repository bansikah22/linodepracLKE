# Linode Compute Machine with Terraform

This Terraform configuration creates a Linode compute machine with the following features:

- **Linode Instance**: Ubuntu 22.04 LTS server
- **Firewall**: Pre-configured firewall rules for SSH, HTTP, and HTTPS
- **Block Storage**: Optional block storage volume
- **Firewall**: Pre-configured security rules
- **Security**: Basic security hardening with UFW firewall

## Prerequisites

1. **Terraform**: Install Terraform (version >= 1.0)
   ```bash
   # macOS with Homebrew
   brew install terraform
   
   # Or download from https://www.terraform.io/downloads.html
   ```

2. **Linode Account**: Create a Linode account at [https://www.linode.com](https://www.linode.com)

3. **API Token**: Generate a Linode API token
   - Go to [https://cloud.linode.com/profile/tokens](https://cloud.linode.com/profile/tokens)
   - Click "Create a Personal Access Token"
   - Give it a label (e.g., "Terraform")
   - Set expiration as needed
   - Copy the token (you won't see it again!)

## Quick Start

1. **Clone or download this repository**
   ```bash
   git https://github.com/bansikah22/linode-compute-mchn-tf.git
   cd linode-compute-mchn-tf
   ```

2. **Configure your variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit `terraform.tfvars` with your values**
   ```hcl
   linode_token = "your-actual-api-token-here"
   instance_label = "my-server"
   region = "us-east"
   root_password = "YourSecurePassword123!"
   ```

4. **Initialize Terraform**
   ```bash
   terraform init
   ```

5. **Review the plan**
   ```bash
   terraform plan
   ```

6. **Apply the configuration**
   ```bash
   terraform apply
   ```

7. **Access your server**
   ```bash
   # SSH into your server
   ssh root@YOUR_SERVER_IP
   
   # Or use the output command
   terraform output ssh_command
   ```

## Configuration Options

### Instance Types

Available instance types (update `instance_type` in `terraform.tfvars`):

- **Shared CPU**: `g6-standard-1` (1GB RAM, 1 CPU)
- **Shared CPU**: `g6-standard-2` (2GB RAM, 1 CPU)
- **Shared CPU**: `g6-standard-4` (4GB RAM, 2 CPU)
- **Shared CPU**: `g6-standard-6` (8GB RAM, 4 CPU)

For more options and current pricing, see [Linode Pricing](https://www.linode.com/products/compute/)

### Regions

Available regions (update `region` in `terraform.tfvars`):

- `us-east` (Newark, NJ)
- `us-central` (Dallas, TX)
- `us-west` (Fremont, CA)
- `us-southeast` (Atlanta, GA)
- `us-southwest` (Frankfurt, DE)
- `eu-west` (London, UK)
- `eu-central` (Frankfurt, DE)
- `ap-south` (Singapore)
- `ap-southeast` (Singapore)
- `ap-northeast` (Tokyo, JP)
- `ap-west` (Mumbai, IN)

### Images

Available images (update `image` in `terraform.tfvars`):

- `linode/ubuntu22.04` (Ubuntu 22.04 LTS)
- `linode/ubuntu20.04` (Ubuntu 20.04 LTS)
- `linode/debian11` (Debian 11)
- `linode/centos8` (CentOS 8)
- `linode/almalinux8` (AlmaLinux 8)

## Features

### Firewall Configuration

The firewall is pre-configured with:
- **SSH** (port 22): Allowed from anywhere
- **HTTP** (port 80): Allowed from anywhere
- **HTTPS** (port 443): Allowed from anywhere
- **Outbound**: All traffic allowed



### Block Storage (Optional)

To enable block storage:
1. Set `create_volume = true` in `terraform.tfvars`
2. Adjust `volume_size` as needed (10-10240 GB)

## Security Considerations

1. **Change the default root password** after first login
2. **Set up SSH keys** for better security
3. **Restrict firewall rules** to specific IP ranges if needed
4. **Regular security updates** are automatically configured
5. **Monitor logs** for suspicious activity

## Useful Commands

```bash
# View outputs
terraform output

# View specific output
terraform output instance_ip

# SSH into your server
terraform output ssh_command

# Destroy infrastructure
terraform destroy

# View Terraform state
terraform show

# List resources
terraform state list
```

## Troubleshooting

### Common Issues

1. **API Token Error**: Ensure your Linode API token is correct and has the necessary permissions
2. **Region Unavailable**: Some instance types may not be available in all regions
3. **Password Requirements**: Root password must be at least 6 characters and contain lowercase, uppercase, and numbers
4. **Firewall Rules**: If you need to modify firewall rules, edit the `main.tf` file

### Getting Help

- [Linode Documentation](https://www.linode.com/docs/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Linode API Documentation](https://www.linode.com/docs/api/)



## Next Steps

After your server is running:

1. **Set up a domain** and point it to your server IP
2. **Install a web server** (Nginx/Apache) if needed
3. **Set up SSL certificates** with Let's Encrypt
4. **Configure your applications**
5. **Set up monitoring** and backups
6. **Implement CI/CD** pipelines

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details. 
