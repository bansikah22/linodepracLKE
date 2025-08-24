#!/bin/bash

# LKE Cluster Setup Script
# This script automates the setup of a Linode Kubernetes Engine cluster

set -e

echo "Starting LKE Cluster Setup..."

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

# Check if kubectl is installed
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_warning "kubectl is not installed. You'll need it to interact with your cluster."
        print_status "Install kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
    else
        print_success "kubectl is installed: $(kubectl version --client --short)"
    fi
}

# Check if variables file exists
check_variables() {
    if [ ! -f "terraform.tfvars" ]; then
        print_status "Creating terraform.tfvars from example..."
        if [ -f "terraform.tfvars.example" ]; then
            cp terraform.tfvars.example terraform.tfvars
            print_warning "Please edit terraform.tfvars with your configuration before proceeding."
            print_status "Especially update the linode_token with your API token."
            exit 0
        else
            print_error "terraform.tfvars.example not found!"
            exit 1
        fi
    fi
}

# Initialize Terraform
init_terraform() {
    print_status "Initializing Terraform..."
    terraform init
    print_success "Terraform initialized successfully"
}

# Plan Terraform deployment
plan_deployment() {
    print_status "Planning Terraform deployment..."
    terraform plan
    print_success "Terraform plan completed"
}

# Apply Terraform deployment
apply_deployment() {
    print_status "Applying Terraform deployment..."
    terraform apply -auto-approve
    print_success "LKE cluster deployed successfully!"
}

# Get cluster information
get_cluster_info() {
    print_status "Getting cluster information..."
    
    echo ""
    echo "=== CLUSTER INFORMATION ==="
    terraform output -raw connection_info | jq '.' 2>/dev/null || terraform output connection_info
    
    echo ""
    echo "=== NODEBALANCER INFORMATION ==="
    echo "NodeBalancer IP: $(terraform output -raw nodebalancer_ip 2>/dev/null || echo 'Not available')"
    echo "NodeBalancer Hostname: $(terraform output -raw nodebalancer_hostname 2>/dev/null || echo 'Not available')"
    
    echo ""
    echo "=== NEXT STEPS ==="
    echo "1. Save your kubeconfig:"
    echo "   terraform output -raw kubeconfig > kubeconfig.yaml"
    echo ""
    echo "2. Test your cluster connection:"
    echo "   kubectl --kubeconfig kubeconfig.yaml get nodes"
    echo ""
    echo "3. Access the Kubernetes dashboard:"
    echo "   kubectl --kubeconfig kubeconfig.yaml proxy"
    echo "   Then visit: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
}

# Main execution
main() {
    print_status "Starting LKE cluster setup..."
    
    # Check prerequisites
    check_terraform
    check_kubectl
    check_variables
    
    # Initialize and deploy
    init_terraform
    plan_deployment
    
    echo ""
    read -p "Do you want to proceed with the deployment? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        apply_deployment
        get_cluster_info
    else
        print_status "Deployment cancelled by user"
        exit 0
    fi
}

# Run main function
main "$@"
