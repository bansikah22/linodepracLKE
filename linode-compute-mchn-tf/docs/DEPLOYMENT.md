# Deployment Guide

This guide provides step-by-step instructions for deploying a Linode compute machine using Terraform.

## Prerequisites

### Required Software
- Terraform >= 1.0
- Git (for version control)
- SSH client

### Required Accounts
- Linode account with billing information
- Linode API token with appropriate permissions

## Pre-Deployment Checklist

- [ ] Terraform installed and accessible
- [ ] Linode account created and verified
- [ ] API token generated with appropriate permissions
- [ ] Network connectivity to Linode services
- [ ] Sufficient Linode account credits

## Deployment Steps

### 1. Environment Setup

```bash
# Clone or download the repository
git clone <repository-url>
cd linode-compute-mchn-tf

# Verify Terraform installation
terraform version
```

### 2. Configuration

```bash
# Create configuration file from template
cp terraform.tfvars.example terraform.tfvars

# Edit configuration with your values
nano terraform.tfvars
```

**Required Configuration Values:**
- `linode_token`: Your Linode API token
- `root_password`: Secure password for server root access
- `instance_label`: Unique identifier for your instance
- `region`: Geographic location for your instance

### 3. Validation

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Preview changes
terraform plan
```

### 4. Deployment

```bash
# Apply configuration
terraform apply

# Confirm deployment when prompted
```

### 5. Verification

```bash
# Verify resources created
terraform show

# Test connectivity
terraform output ssh_command
```

## Post-Deployment Tasks

### Security Hardening

1. **Change Default Password**
   ```bash
   ssh root@<server-ip>
   passwd
   ```

2. **Configure SSH Keys** (Recommended)
   ```bash
   # Generate SSH key pair
   ssh-keygen -t rsa -b 4096
   
   # Copy public key to server
   ssh-copy-id root@<server-ip>
   ```

3. **Restrict SSH Access** (Optional)
   - Edit firewall rules to limit SSH access to specific IP ranges
   - Consider using SSH key authentication only

### Application Setup

1. **Install Required Software**
   ```bash
   # Update package lists
   apt update && apt upgrade -y
   
   # Install application dependencies
   apt install -y <required-packages>
   ```

2. **Configure Services**
   - Set up web server (Nginx/Apache)
   - Configure application-specific services
   - Set up SSL certificates

3. **Configure Monitoring**
   - Set up log monitoring
   - Configure system monitoring
   - Set up backup procedures

## Maintenance

### Regular Tasks

- **Security Updates**: Automatic updates are configured via cloud-init
- **Backup Verification**: Test backup and restore procedures
- **Performance Monitoring**: Monitor resource usage and performance
- **Log Review**: Regularly review system logs for issues

### Scaling Considerations

- **Vertical Scaling**: Upgrade instance type for more resources
- **Horizontal Scaling**: Deploy additional instances behind load balancer
- **Storage Scaling**: Add block storage volumes as needed

## Troubleshooting

### Common Issues

1. **API Token Errors**
   - Verify token is correct and not expired
   - Ensure token has appropriate permissions
   - Check account billing status

2. **Network Connectivity**
   - Verify firewall rules are correctly configured
   - Check Linode network status
   - Test connectivity from different locations

3. **Instance Boot Issues**
   - Check cloud-init logs: `journalctl -u cloud-init`
   - Verify user_data script syntax
   - Review Linode console output

### Recovery Procedures

1. **Instance Recovery**
   ```bash
   # Reboot instance if needed
   terraform apply -replace="linode_instance.web_server"
   ```

2. **Configuration Recovery**
   ```bash
   # Import existing resources
   terraform import linode_instance.web_server <instance-id>
   ```

3. **Data Recovery**
   - Use Linode backup service if enabled
   - Restore from block storage snapshots
   - Recover from external backups

## Security Best Practices

### Network Security
- Restrict SSH access to specific IP ranges
- Use SSH key authentication
- Regularly review firewall rules
- Monitor network traffic

### System Security
- Keep system packages updated
- Use strong passwords
- Implement file integrity monitoring
- Regular security audits

### Access Control
- Use least privilege principle
- Implement role-based access control
- Regular access reviews
- Secure credential management

## Cost Optimization

### Resource Optimization
- Right-size instances based on actual usage
- Use appropriate instance types for workloads
- Monitor and optimize storage usage
- Consider reserved instances for long-term deployments

### Monitoring and Alerts
- Set up cost monitoring
- Configure billing alerts
- Regular cost reviews
- Optimize based on usage patterns

## Support and Documentation

### Resources
- [Linode Documentation](https://www.linode.com/docs/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Linode API Documentation](https://www.linode.com/docs/api/)

### Support Channels
- Linode Support: [https://www.linode.com/support/](https://www.linode.com/support/)
- Terraform Community: [https://discuss.hashicorp.com/](https://discuss.hashicorp.com/)

## Compliance and Governance

### Data Protection
- Implement data encryption at rest and in transit
- Regular security assessments
- Compliance monitoring and reporting
- Data retention policies

### Audit and Logging
- Comprehensive logging configuration
- Regular audit reviews
- Compliance reporting
- Incident response procedures
