#!/bin/bash

# Kubernetes Application Deployment Script
# This script deploys all Kubernetes applications to the LKE cluster

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

# Function to deploy RBAC configurations
deploy_rbac() {
    print_status "Deploying RBAC configurations..."
    kubectl --kubeconfig kubeconfig.yaml apply -f manifests/rbac/
    print_success "RBAC configurations deployed"
}

# Function to deploy security configurations
deploy_security() {
    print_status "Deploying security configurations..."
    kubectl --kubeconfig kubeconfig.yaml apply -f manifests/security/
    print_success "Security configurations deployed"
}

# Function to deploy monitoring stack
deploy_monitoring() {
    print_status "Deploying monitoring stack..."
    kubectl --kubeconfig kubeconfig.yaml apply -f manifests/monitoring/
    print_success "Monitoring stack deployed"
}

# Function to deploy applications
deploy_applications() {
    print_status "Deploying applications..."
    kubectl --kubeconfig kubeconfig.yaml apply -f manifests/apps/
    print_success "Applications deployed"
}

# Function to deploy ingress configurations
deploy_ingress() {
    print_status "Deploying ingress configurations..."
    kubectl --kubeconfig kubeconfig.yaml apply -f manifests/ingress/
    print_success "Ingress configurations deployed"
}

# Function to check deployment status
check_status() {
    print_status "Checking deployment status..."
    
    echo
    print_status "Cluster nodes:"
    kubectl --kubeconfig kubeconfig.yaml get nodes
    
    echo
    print_status "All pods:"
    kubectl --kubeconfig kubeconfig.yaml get pods --all-namespaces
    
    echo
    print_status "Services:"
    kubectl --kubeconfig kubeconfig.yaml get svc --all-namespaces
    
    echo
    print_status "LoadBalancer services:"
    kubectl --kubeconfig kubeconfig.yaml get svc --all-namespaces | grep LoadBalancer
    
    echo
    print_status "RBAC resources:"
    kubectl --kubeconfig kubeconfig.yaml get serviceaccounts -n rbac
    kubectl --kubeconfig kubeconfig.yaml get clusterroles | grep -E "(developer|monitoring|readonly)"
    kubectl --kubeconfig kubeconfig.yaml get clusterrolebindings | grep -E "(developer|monitoring|readonly)"
}

# Function to show next steps
show_next_steps() {
    echo
    print_success "Deployment completed successfully!"
    echo
    print_status "Next steps:"
    echo "1. Check LoadBalancer services for external IPs:"
    echo "   kubectl --kubeconfig kubeconfig.yaml get svc --all-namespaces | grep LoadBalancer"
    echo
    echo "2. Access applications via LoadBalancer IPs:"
    echo "   - nginx: http://<nginx-loadbalancer-external-ip>"
    echo "   - Prometheus: http://<prometheus-loadbalancer-external-ip>:9090"
    echo
    echo "3. For local development, use port forwarding:"
    echo "   kubectl --kubeconfig kubeconfig.yaml port-forward svc/nginx-service 8080:80"
    echo "   kubectl --kubeconfig kubeconfig.yaml port-forward svc/prometheus-service 9090:9090 -n monitoring"
    echo
    echo "4. Monitor application logs:"
    echo "   kubectl --kubeconfig kubeconfig.yaml logs deployment/nginx-deployment"
    echo "   kubectl --kubeconfig kubeconfig.yaml logs deployment/prometheus -n monitoring"
    echo
    echo "5. RBAC Service Accounts created:"
    echo "   - developer-sa (developer role)"
    echo "   - monitoring-sa (monitoring role)"
    echo "   - readonly-sa (read-only role)"
    echo "   - application-sa (application role)"
    echo
    echo "6. To use RBAC service accounts:"
    echo "   kubectl --kubeconfig kubeconfig.yaml get serviceaccounts -n rbac"
    echo "   kubectl --kubeconfig kubeconfig.yaml get clusterrolebindings"
}

# Main deployment function
main() {
    print_status "Starting Kubernetes application deployment..."
    
    # Check prerequisites
    check_kubectl
    check_kubeconfig
    
    # Deploy in order
    deploy_rbac
    deploy_security
    deploy_monitoring
    deploy_applications
    deploy_ingress
    
    # Wait for deployments to be ready
    print_status "Waiting for deployments to be ready..."
    sleep 30
    
    # Check status
    check_status
    
    # Show next steps
    show_next_steps
}

# Run main function
main "$@"
