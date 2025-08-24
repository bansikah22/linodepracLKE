#!/bin/bash

# Test script for Linode Object Storage
# This script tests the Object Storage setup and shows usage examples

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "Linode Object Storage Test Script"
echo "================================="
echo

# Check if terraform outputs are available
if ! command -v terraform &> /dev/null; then
    print_warning "Terraform not found. Please install Terraform first."
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    print_warning "main.tf not found. Please run this script from the linode-object-storage-tf directory."
    exit 1
fi

print_status "Testing Object Storage setup..."

# Get bucket information
if terraform output main_bucket_info &> /dev/null; then
    print_success "Object Storage is deployed!"
    echo
    
    print_status "Bucket Information:"
    terraform output main_bucket_info
    echo
    
    print_status "S3 Endpoint:"
    terraform output s3_endpoint
    echo
    
    print_status "Usage Examples:"
    terraform output usage_examples
    echo
    
    print_status "Testing with AWS CLI (if available)..."
    
    if command -v aws &> /dev/null; then
        BUCKET_NAME="my-production-storage"
        ENDPOINT="https://us-east-1.linodeobjects.com"
        
        echo "Test commands:"
        echo "1. List buckets:"
        echo "   aws s3 ls --endpoint-url=$ENDPOINT"
        echo
        echo "2. List objects in bucket:"
        echo "   aws s3 ls s3://$BUCKET_NAME --endpoint-url=$ENDPOINT"
        echo
        echo "3. Upload test file:"
        echo "   echo 'Hello World' > test.txt"
        echo "   aws s3 cp test.txt s3://$BUCKET_NAME/ --endpoint-url=$ENDPOINT"
        echo
        echo "4. Download test file:"
        echo "   aws s3 cp s3://$BUCKET_NAME/test.txt ./downloaded.txt --endpoint-url=$ENDPOINT"
        echo
        echo "5. View bucket contents:"
        echo "   aws s3 ls s3://$BUCKET_NAME/ --endpoint-url=$ENDPOINT"
    else
        print_warning "AWS CLI not found. Install it to test S3 compatibility."
        echo "Install AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    fi
    
    echo
    print_status "Testing with cURL..."
    BUCKET_HOSTNAME="my-production-storage.us-east-1.linodeobjects.com"
    
    echo "Test commands:"
    echo "1. Upload file:"
    echo "   curl -X PUT -T test.txt https://$BUCKET_HOSTNAME/test.txt"
    echo
    echo "2. Download file:"
    echo "   curl https://$BUCKET_HOSTNAME/test.txt"
    echo
    echo "3. List objects:"
    echo "   curl https://$BUCKET_HOSTNAME/"
    
else
    print_warning "Object Storage not deployed yet."
    echo
    print_status "To deploy Object Storage:"
    echo "1. Copy terraform.tfvars.example to terraform.tfvars"
    echo "2. Edit terraform.tfvars with your configuration"
    echo "3. Run: ./setup.sh"
fi

echo
print_success "Test script completed!"
