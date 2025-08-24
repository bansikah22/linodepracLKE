#!/bin/bash

# Linode Object Storage Setup Script
# This script sets up Linode Object Storage buckets and access keys

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if Terraform is installed
    if ! command_exists terraform; then
        print_error "Terraform is not installed. Please install Terraform first."
        print_status "Visit: https://www.terraform.io/downloads.html"
        exit 1
    fi
    
    print_success "Terraform found: $(terraform version | head -n1)"
    
    # Check if terraform.tfvars exists
    if [ ! -f "terraform.tfvars" ]; then
        print_error "terraform.tfvars file not found!"
        print_status "Please copy terraform.tfvars.example to terraform.tfvars and configure it:"
        echo "  cp terraform.tfvars.example terraform.tfvars"
        echo "  # Edit terraform.tfvars with your configuration"
        exit 1
    fi
    
    print_success "terraform.tfvars found"
    
    # Check if linode_token is set
    if ! grep -q "linode_token" terraform.tfvars || grep -q "your-linode-api-token-here" terraform.tfvars; then
        print_error "Please set your Linode API token in terraform.tfvars"
        print_status "Get your API token from: https://cloud.linode.com/profile/tokens"
        exit 1
    fi
    
    print_success "Linode API token configured"
}

# Function to initialize Terraform
init_terraform() {
    print_status "Initializing Terraform..."
    terraform init
    print_success "Terraform initialized"
}

# Function to plan Terraform
plan_terraform() {
    print_status "Planning Terraform deployment..."
    terraform plan
    print_success "Terraform plan completed"
}

# Function to apply Terraform
apply_terraform() {
    print_status "Applying Terraform configuration..."
    print_warning "This will create Object Storage buckets and access keys"
    print_status "Review the plan above and press Enter to continue..."
    read -r
    
    terraform apply -auto-approve
    print_success "Terraform apply completed"
}

# Function to show outputs
show_outputs() {
    print_status "Object Storage deployment completed!"
    echo
    print_status "Bucket Information:"
    terraform output main_bucket_info
    echo
    
    if terraform output backup_bucket_info | grep -q "null"; then
        print_status "Backup bucket: Not created"
    else
        print_status "Backup bucket:"
        terraform output backup_bucket_info
    fi
    echo
    
    if terraform output logs_bucket_info | grep -q "null"; then
        print_status "Logs bucket: Not created"
    else
        print_status "Logs bucket:"
        terraform output logs_bucket_info
    fi
    echo
    
    print_status "Connection Information:"
    terraform output connection_info
    echo
    
    print_status "Usage Examples:"
    terraform output usage_examples
    echo
    
    print_warning "Access keys are sensitive information. Store them securely!"
    print_status "To view access keys, run: terraform output main_access_key"
}

# Function to show next steps
show_next_steps() {
    echo
    print_status "Next Steps:"
    echo "1. Test bucket access with AWS CLI:"
    echo "   aws s3 ls s3://my-production-storage --endpoint-url=https://us-east-1.linodeobjects.com"
    echo
    echo "2. Upload a test file:"
    echo "   echo 'Hello World' > test.txt"
    echo "   aws s3 cp test.txt s3://my-production-storage/ --endpoint-url=https://us-east-1.linodeobjects.com"
    echo
    echo "3. Download the test file:"
    echo "   aws s3 cp s3://my-production-storage/test.txt ./downloaded.txt --endpoint-url=https://us-east-1.linodeobjects.com"
    echo
    echo "4. View bucket contents:"
    echo "   aws s3 ls s3://my-production-storage/ --endpoint-url=https://us-east-1.linodeobjects.com"
    echo
    print_status "For more information, see the README.md file"
}

# Main function
main() {
    echo "Linode Object Storage Setup"
    echo "=========================="
    echo
    
    check_prerequisites
    init_terraform
    plan_terraform
    apply_terraform
    show_outputs
    show_next_steps
}

# Run main function
main "$@"
