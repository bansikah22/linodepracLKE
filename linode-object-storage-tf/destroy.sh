#!/bin/bash

# Linode Object Storage Destroy Script
# This script safely destroys Linode Object Storage buckets and access keys

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
        exit 1
    fi
    
    print_success "Terraform found: $(terraform version | head -n1)"
    
    # Check if terraform.tfvars exists
    if [ ! -f "terraform.tfvars" ]; then
        print_error "terraform.tfvars file not found!"
        exit 1
    fi
    
    print_success "terraform.tfvars found"
}

# Function to confirm destruction
confirm_destruction() {
    echo
    print_warning "WARNING: This will destroy ALL Object Storage resources!"
    print_warning "This includes:"
    print_warning "  - All buckets and their contents"
    print_warning "  - All access keys"
    print_warning "  - All lifecycle policies"
    print_warning "  - All CORS configurations"
    echo
    print_warning "This action is IRREVERSIBLE!"
    echo
    read -p "Are you absolutely sure you want to proceed? Type 'DESTROY' to confirm: " confirmation
    
    if [ "$confirmation" != "DESTROY" ]; then
        print_status "Destruction cancelled by user"
        exit 0
    fi
    
    print_status "Destruction confirmed"
}

# Function to show what will be destroyed
show_destruction_plan() {
    print_status "Showing what will be destroyed..."
    terraform plan -destroy
    print_success "Destruction plan shown"
}

# Function to destroy resources
destroy_resources() {
    print_status "Destroying Object Storage resources..."
    terraform destroy -auto-approve
    print_success "Object Storage resources destroyed"
}

# Function to show completion
show_completion() {
    print_success "Object Storage destruction completed!"
    echo
    print_status "All buckets and access keys have been removed"
    print_status "You can now safely delete this directory if desired"
}

# Main function
main() {
    echo "Linode Object Storage Destruction"
    echo "================================="
    echo
    
    check_prerequisites
    confirm_destruction
    show_destruction_plan
    destroy_resources
    show_completion
}

# Run main function
main "$@"
