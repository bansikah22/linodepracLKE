#!/bin/bash

# LKE Cluster Destroy Script
# This script safely destroys the LKE cluster and all associated resources

set -e

echo "Starting LKE Cluster Destruction..."

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

# Check if Terraform is installed
check_terraform() {
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install Terraform first."
        exit 1
    fi
    print_success "Terraform is installed: $(terraform version | head -n1)"
}

# Check if we're in the right directory
check_directory() {
    if [ ! -f "main.tf" ] || [ ! -f "variables.tf" ]; then
        print_error "This doesn't appear to be a Terraform LKE directory."
        print_error "Please run this script from the linode-lke-cluster-tf directory."
        exit 1
    fi
}

# Show what will be destroyed
show_destroy_plan() {
    print_status "Showing what will be destroyed..."
    terraform plan -destroy
}

# Confirm destruction
confirm_destruction() {
    echo ""
    print_warning "WARNING: This will destroy ALL resources created by this Terraform configuration!"
    print_warning "This includes:"
    print_warning "  - LKE Cluster and all node pools"
    print_warning "  - NodeBalancer and associated configurations"
    print_warning "  - All data in the cluster will be lost"
    echo ""
    
    read -p "Are you absolutely sure you want to proceed? Type 'DESTROY' to confirm: " -r
    echo ""
    if [[ $REPLY != "DESTROY" ]]; then
        print_status "Destruction cancelled by user"
        exit 0
    fi
}

# Destroy resources
destroy_resources() {
    print_status "Destroying LKE cluster and associated resources..."
    terraform destroy -auto-approve
    print_success "All resources destroyed successfully!"
}

# Clean up local files
cleanup_local_files() {
    print_status "Cleaning up local files..."
    
    # Remove kubeconfig if it exists
    if [ -f "kubeconfig.yaml" ]; then
        rm kubeconfig.yaml
        print_success "Removed kubeconfig.yaml"
    fi
    
    # Remove terraform state files (optional)
    read -p "Do you want to remove Terraform state files? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f .terraform.lock.hcl
        rm -rf .terraform/
        print_success "Removed Terraform state files"
    fi
    
    # Remove terraform.tfvars (optional)
    read -p "Do you want to remove terraform.tfvars? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm terraform.tfvars
        print_success "Removed terraform.tfvars"
    fi
}

# Show final status
show_final_status() {
    echo ""
    print_success "LKE cluster destruction completed successfully!"
    echo ""
    print_status "All resources have been cleaned up."
    print_status "You can now safely delete this directory if desired."
}

# Main execution
main() {
    print_status "Starting LKE cluster destruction process..."
    
    # Check prerequisites
    check_terraform
    check_directory
    
    # Show what will be destroyed
    show_destroy_plan
    
    # Confirm destruction
    confirm_destruction
    
    # Destroy resources
    destroy_resources
    
    # Clean up local files
    cleanup_local_files
    
    # Show final status
    show_final_status
}

# Run main function
main "$@"
