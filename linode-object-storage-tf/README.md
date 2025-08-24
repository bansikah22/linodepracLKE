# Linode Object Storage (S3-Compatible) Project

A production-ready Linode Object Storage setup with multiple buckets, access keys, lifecycle policies, and CORS configuration. This project provides S3-compatible object storage similar to AWS S3.

## 🏗️ Project Overview

This project creates a complete Object Storage solution on Linode with:
- **Multiple Buckets**: Main, backup, and logs buckets with different retention policies
- **Access Management**: Multiple access keys with different permissions
- **Lifecycle Policies**: Automatic cleanup of old versions and incomplete uploads
- **CORS Configuration**: Cross-origin resource sharing for web applications
- **Versioning**: Object versioning for data protection
- **S3 Compatibility**: Full S3 API compatibility for easy integration

## 📁 Project Structure

```
linode-object-storage-tf/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output definitions
├── terraform.tfvars.example # Example configuration
├── setup.sh                # Deployment script
├── destroy.sh              # Cleanup script
└── README.md              # This file
```

## 🚀 Quick Start

### Prerequisites
- **Linode Account**: With API token
- **Terraform**: Version 1.0+
- **AWS CLI** (optional): For testing S3 compatibility
- **Bash**: For running scripts

### 1. Configure the Project
```bash
# Copy the example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit the configuration with your settings
nano terraform.tfvars
```

### 2. Deploy Object Storage
```bash
# Run the setup script
./setup.sh
```

This will:
- Initialize Terraform
- Create main bucket with versioning and lifecycle policies
- Create backup bucket (if enabled)
- Create logs bucket (if enabled)
- Create access keys with appropriate permissions
- Configure CORS for web applications

### 3. Test the Setup
```bash
# Test bucket access
aws s3 ls s3://your-bucket-name --endpoint-url=https://us-east-1.linodeobjects.com

# Upload a test file
echo "Hello World" > test.txt
aws s3 cp test.txt s3://your-bucket-name/ --endpoint-url=https://us-east-1.linodeobjects.com

# Download the file
aws s3 cp s3://your-bucket-name/test.txt ./downloaded.txt --endpoint-url=https://us-east-1.linodeobjects.com
```

## 🎯 Features

### Bucket Management
- **Main Bucket**: Primary storage with versioning and lifecycle policies
- **Backup Bucket**: Long-term backup storage (7-year retention)
- **Logs Bucket**: Application logs with shorter retention (90 days)
- **Versioning**: Object versioning for data protection
- **Lifecycle Policies**: Automatic cleanup of old versions and incomplete uploads

### Access Management
- **Main Access Key**: Full read/write access to all buckets
- **Read-Only Key**: Read-only access for applications
- **Backup Key**: Dedicated key for backup operations
- **Logs Key**: Dedicated key for log operations
- **Bucket-Specific Permissions**: Granular access control

### Security Features
- **CORS Configuration**: Cross-origin resource sharing
- **Lifecycle Policies**: Automatic data cleanup
- **Versioning**: Protection against accidental deletion
- **Access Key Rotation**: Framework for key management

### S3 Compatibility
- **Full S3 API**: Compatible with all S3 tools and libraries
- **AWS CLI**: Works with standard AWS CLI commands
- **SDK Support**: Compatible with AWS SDKs
- **Third-party Tools**: Works with S3-compatible tools

## 🔧 Configuration

### Basic Configuration
Edit `terraform.tfvars`:

```hcl
# Required
linode_token = "your-api-token"
bucket_label = "my-production-storage"
cluster_region = "us-east-1"

# Optional - leave empty to auto-generate
access_key = ""
secret_key = ""
```

### Advanced Configuration
```hcl
# Versioning and Lifecycle
enable_versioning = true
enable_lifecycle_rules = true
lifecycle_expiration_days = 365
noncurrent_version_expiration_days = 30

# CORS for web applications
cors_allowed_origins = ["https://yourdomain.com"]
cors_allowed_methods = ["GET", "PUT", "POST", "DELETE"]

# Additional buckets
create_backup_bucket = true
create_logs_bucket = true
```

## 📊 Available Regions

Linode Object Storage is available in these regions:

| Region | Location | Endpoint |
|--------|----------|----------|
| us-east-1 | Newark, NJ | https://us-east-1.linodeobjects.com |
| us-southeast-1 | Atlanta, GA | https://us-southeast-1.linodeobjects.com |
| us-west-1 | Fremont, CA | https://us-west-1.linodeobjects.com |
| ap-west-1 | Mumbai, India | https://ap-west-1.linodeobjects.com |
| ap-southeast-1 | Singapore | https://ap-southeast-1.linodeobjects.com |
| eu-central-1 | Frankfurt, Germany | https://eu-central-1.linodeobjects.com |
| eu-west-1 | London, UK | https://eu-west-1.linodeobjects.com |
| ca-central-1 | Toronto, Canada | https://ca-central-1.linodeobjects.com |

## 🔐 Access Management

### Access Keys Created
- **Main Key**: Full access to all buckets
- **Read-Only Key**: Read-only access for applications
- **Backup Key**: Dedicated backup operations (if enabled)
- **Logs Key**: Dedicated log operations (if enabled)

### Key Permissions
- **read_write**: Full read and write access
- **read_only**: Read-only access
- **write_only**: Write-only access

### Security Best Practices
- Store access keys securely
- Use read-only keys for applications
- Rotate keys regularly
- Use bucket-specific keys when possible

## 📈 Usage Examples

### AWS CLI
```bash
# List buckets
aws s3 ls --endpoint-url=https://us-east-1.linodeobjects.com

# List objects in bucket
aws s3 ls s3://your-bucket-name --endpoint-url=https://us-east-1.linodeobjects.com

# Upload file
aws s3 cp file.txt s3://your-bucket-name/ --endpoint-url=https://us-east-1.linodeobjects.com

# Download file
aws s3 cp s3://your-bucket-name/file.txt ./ --endpoint-url=https://us-east-1.linodeobjects.com

# Sync directory
aws s3 sync ./local-folder s3://your-bucket-name/ --endpoint-url=https://us-east-1.linodeobjects.com
```

### cURL
```bash
# Upload file
curl -X PUT -T file.txt https://your-bucket-name.us-east-1.linodeobjects.com/file.txt

# Download file
curl https://your-bucket-name.us-east-1.linodeobjects.com/file.txt

# List objects
curl https://your-bucket-name.us-east-1.linodeobjects.com/
```

### Python (boto3)
```python
import boto3

# Configure S3 client
s3 = boto3.client(
    's3',
    endpoint_url='https://us-east-1.linodeobjects.com',
    aws_access_key_id='your-access-key',
    aws_secret_access_key='your-secret-key'
)

# Upload file
s3.upload_file('file.txt', 'your-bucket-name', 'file.txt')

# Download file
s3.download_file('your-bucket-name', 'file.txt', 'downloaded.txt')

# List objects
response = s3.list_objects_v2(Bucket='your-bucket-name')
for obj in response['Contents']:
    print(obj['Key'])
```

### JavaScript (AWS SDK)
```javascript
const AWS = require('aws-sdk');

// Configure S3
const s3 = new AWS.S3({
    endpoint: 'https://us-east-1.linodeobjects.com',
    accessKeyId: 'your-access-key',
    secretAccessKey: 'your-secret-key'
});

// Upload file
const uploadParams = {
    Bucket: 'your-bucket-name',
    Key: 'file.txt',
    Body: 'Hello World'
};

s3.upload(uploadParams, (err, data) => {
    if (err) console.log(err);
    else console.log('Upload successful:', data);
});
```

## 🔄 Lifecycle Policies

### Main Bucket
- **Object Expiration**: 365 days
- **Noncurrent Version Expiration**: 30 days
- **Incomplete Multipart Upload**: 7 days

### Backup Bucket
- **Object Expiration**: 7 years (2555 days)
- **Versioning**: Enabled

### Logs Bucket
- **Object Expiration**: 90 days
- **Versioning**: Disabled

## 🌐 CORS Configuration

Default CORS configuration allows:
- **Origins**: All origins (`*`)
- **Methods**: GET, PUT, POST, DELETE, HEAD
- **Headers**: All headers (`*`)
- **Exposed Headers**: ETag
- **Max Age**: 3000 seconds

Customize in `terraform.tfvars`:
```hcl
cors_allowed_origins = ["https://yourdomain.com", "https://app.yourdomain.com"]
cors_allowed_methods = ["GET", "PUT", "POST"]
```

## 💰 Cost Optimization

- **Lifecycle Policies**: Automatic cleanup reduces storage costs
- **Versioning Control**: Manage versioning based on needs
- **Regional Selection**: Choose region closest to users
- **Access Key Management**: Use appropriate permissions

## 🐛 Troubleshooting

### Common Issues
1. **Access Denied**: Check access key permissions
2. **Bucket Not Found**: Verify bucket name and region
3. **CORS Errors**: Check CORS configuration
4. **Upload Failures**: Verify file permissions and size limits

### Debug Commands
```bash
# Check bucket status
terraform output main_bucket_info

# View access keys
terraform output main_access_key

# Test connectivity
curl -I https://your-bucket-name.us-east-1.linodeobjects.com

# Check AWS CLI configuration
aws configure list
```

### Terraform Commands
```bash
# Check status
terraform plan

# View outputs
terraform output

# Refresh state
terraform refresh

# Show resources
terraform state list
```

## 🧹 Cleanup

### Remove Object Storage
```bash
./destroy.sh
```

This will:
- Remove all buckets and their contents
- Delete all access keys
- Remove lifecycle policies
- Clean up CORS configurations

### Manual Cleanup
```bash
# Plan destruction
terraform plan -destroy

# Apply destruction
terraform destroy
```

## 🔄 Best Practices

### Security
- Use read-only keys for applications
- Rotate access keys regularly
- Implement proper CORS policies
- Use lifecycle policies for data cleanup

### Performance
- Choose appropriate regions
- Use multipart uploads for large files
- Implement caching strategies
- Monitor usage and costs

### Data Management
- Enable versioning for critical data
- Use lifecycle policies for cost control
- Implement backup strategies
- Monitor storage usage

## 🚀 Next Steps

1. **Application Integration**: Integrate with your applications
2. **Monitoring**: Set up usage monitoring and alerts
3. **Backup Strategy**: Implement automated backup processes
4. **CDN Integration**: Add CDN for improved performance
5. **Access Control**: Implement more granular access controls
6. **Compliance**: Add compliance and audit features

## 📚 Documentation

- **Linode Object Storage**: [Official Documentation](https://www.linode.com/docs/products/storage/object-storage/)
- **S3 API Reference**: [AWS S3 API](https://docs.aws.amazon.com/AmazonS3/latest/API/)
- **Terraform Linode Provider**: [Provider Documentation](https://registry.terraform.io/providers/linode/linode/latest/docs)
- **AWS CLI**: [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/)

## 🔗 Resources

- **Linode Object Storage**: [Product Page](https://www.linode.com/products/object-storage/)
- **S3 Compatibility**: [S3 API Compatibility](https://www.linode.com/docs/products/storage/object-storage/guides/s3-compatibility/)
- **Pricing**: [Object Storage Pricing](https://www.linode.com/docs/products/storage/object-storage/pricing/)
- **API Reference**: [Linode API v4](https://www.linode.com/docs/api/)

## 📄 License

This project is licensed under the same license as the parent repository.

---

**Ready to deploy your S3-compatible object storage! 🚀**
