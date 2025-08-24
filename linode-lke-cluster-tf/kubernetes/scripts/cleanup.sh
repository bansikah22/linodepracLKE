#!/bin/bash

# Kubernetes Application Cleanup Script
# This script removes all Kubernetes applications from the LKE cluster

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

# Function to check if kubectl is available
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed. Please install kubectl first."
        exit 1
    fi
    print_success "kubectl found: $(kubectl version --client)"
}

# Function to check if kubeconfig exists
check_kubeconfig() {
    if [ ! -f "kubeconfig.yaml" ]; then
        print_error "kubeconfig.yaml not found in current directory."
        print_error "Please ensure you have the kubeconfig file from your LKE cluster."
        exit 1
    fi
    print_success "kubeconfig.yaml found"
}

# Function to confirm cleanup
confirm_cleanup() {
    echo
    print_warning "This will remove ALL deployed applications and configurations!"
    echo
    echo "The following will be removed:"
    echo "- Ingress configurations"
    echo "- Applications (nginx, etc.)"
    echo "- Monitoring stack (Prometheus)"
    echo "- Security configurations"
    echo "- RBAC configurations"
    echo
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Cleanup cancelled."
        exit 0
    fi
}

# Function to remove ingress configurations
remove_ingress() {
    print_status "Removing ingress configurations..."
    kubectl --kubeconfig kubeconfig.yaml delete -f manifests/ingress/ --ignore-not-found=true
    print_success "Ingress configurations removed"
}

# Function to remove applications
remove_applications() {
    print_status "Removing applications..."
    kubectl --kubeconfig kubeconfig.yaml delete -f manifests/apps/ --ignore-not-found=true
    print_success "Applications removed"
}

# Function to remove monitoring stack
remove_monitoring() {
    print_status "Removing monitoring stack..."
    kubectl --kubeconfig kubeconfig.yaml delete -f manifests/monitoring/ --ignore-not-found=true
    print_success "Monitoring stack removed"
}

# Function to remove security configurations
remove_security() {
    print_status "Removing security configurations..."
    kubectl --kubeconfig kubeconfig.yaml delete -f manifests/security/ --ignore-not-found=true
    print_success "Security configurations removed"
}

# Function to remove RBAC configurations
remove_rbac() {
    print_status "Removing RBAC configurations..."
    kubectl --kubeconfig kubeconfig.yaml delete -f manifests/rbac/ --ignore-not-found=true
    print_success "RBAC configurations removed"
}

# Function to check final status
check_final_status() {
    print_status "Checking final status..."
    
    echo
    print_status "Remaining pods:"
    kubectl --kubeconfig kubeconfig.yaml get pods --all-namespaces
    
    echo
    print_status "Remaining services:"
    kubectl --kubeconfig kubeconfig.yaml get svc --all-namespaces
    
    echo
    print_status "Remaining namespaces:"
    kubectl --kubeconfig kubeconfig.yaml get namespaces
}

# Main cleanup function
main() {
    print_status "Starting Kubernetes application cleanup..."
    
    # Check prerequisites
    check_kubectl
    check_kubeconfig
    
    # Confirm cleanup
    confirm_cleanup
    
    # Remove in reverse order
    remove_ingress
    remove_applications
    remove_monitoring
    remove_security
    remove_rbac
    
    # Wait for resources to be removed
    print_status "Waiting for resources to be removed..."
    sleep 10
    
    # Check final status
    check_final_status
    
    print_success "Cleanup completed successfully!"
}

# Run main function
main "$@"
