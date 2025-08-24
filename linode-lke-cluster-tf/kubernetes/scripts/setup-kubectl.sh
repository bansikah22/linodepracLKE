#!/bin/bash

# kubectl Setup Script
# This script helps configure kubectl to use the LKE cluster without --kubeconfig flag

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

# Get the absolute path to kubeconfig
KUBECONFIG_PATH="$(pwd)/kubeconfig.yaml"

# Check if kubeconfig exists
if [ ! -f "$KUBECONFIG_PATH" ]; then
    print_error "kubeconfig.yaml not found in current directory."
    print_error "Please ensure you have the kubeconfig file from your LKE cluster."
    exit 1
fi

print_success "Found kubeconfig at: $KUBECONFIG_PATH"

# Function to set environment variable for current session
setup_session() {
    print_status "Setting up kubectl for current session..."
    export KUBECONFIG="$KUBECONFIG_PATH"
    print_success "KUBECONFIG environment variable set for current session"
    print_status "You can now use kubectl without --kubeconfig flag"
    
    # Test the configuration
    if kubectl get nodes &>/dev/null; then
        print_success "kubectl is working correctly!"
        echo
        print_status "Test commands:"
        echo "  kubectl get nodes"
        echo "  kubectl get pods --all-namespaces"
        echo "  kubectl get serviceaccounts -n rbac"
    else
        print_error "kubectl configuration failed. Please check your kubeconfig file."
        exit 1
    fi
}

# Function to set environment variable permanently
setup_permanent() {
    print_status "Setting up kubectl permanently..."
    
    # Detect shell
    SHELL_PROFILE=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_PROFILE="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        SHELL_PROFILE="$HOME/.bashrc"
    else
        print_warning "Unknown shell. Please manually add to your shell profile:"
        echo "export KUBECONFIG=\"$KUBECONFIG_PATH\""
        return
    fi
    
    # Add to shell profile
    if ! grep -q "KUBECONFIG.*kubeconfig.yaml" "$SHELL_PROFILE"; then
        echo "" >> "$SHELL_PROFILE"
        echo "# LKE Cluster kubectl configuration" >> "$SHELL_PROFILE"
        echo "export KUBECONFIG=\"$KUBECONFIG_PATH\"" >> "$SHELL_PROFILE"
        print_success "Added KUBECONFIG to $SHELL_PROFILE"
    else
        print_warning "KUBECONFIG already configured in $SHELL_PROFILE"
    fi
    
    print_status "To apply changes, run: source $SHELL_PROFILE"
}

# Function to copy to default location
setup_default_location() {
    print_status "Setting up kubectl using default location..."
    
    # Create .kube directory if it doesn't exist
    mkdir -p "$HOME/.kube"
    
    # Backup existing config if it exists
    if [ -f "$HOME/.kube/config" ]; then
        cp "$HOME/.kube/config" "$HOME/.kube/config.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backed up existing kubectl config"
    fi
    
    # Copy kubeconfig to default location
    cp "$KUBECONFIG_PATH" "$HOME/.kube/config"
    print_success "Copied kubeconfig to $HOME/.kube/config"
    
    # Test the configuration
    if kubectl get nodes &>/dev/null; then
        print_success "kubectl is working correctly!"
    else
        print_error "kubectl configuration failed."
        exit 1
    fi
}

# Function to create alias
setup_alias() {
    print_status "Setting up kubectl alias..."
    
    # Detect shell
    SHELL_PROFILE=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_PROFILE="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        SHELL_PROFILE="$HOME/.bashrc"
    else
        print_warning "Unknown shell. Please manually add to your shell profile:"
        echo "alias k=\"kubectl --kubeconfig=$KUBECONFIG_PATH\""
        return
    fi
    
    # Add alias to shell profile
    if ! grep -q "alias k=" "$SHELL_PROFILE"; then
        echo "" >> "$SHELL_PROFILE"
        echo "# LKE Cluster kubectl alias" >> "$SHELL_PROFILE"
        echo "alias k=\"kubectl --kubeconfig=$KUBECONFIG_PATH\"" >> "$SHELL_PROFILE"
        print_success "Added kubectl alias to $SHELL_PROFILE"
    else
        print_warning "kubectl alias already configured in $SHELL_PROFILE"
    fi
    
    print_status "To apply changes, run: source $SHELL_PROFILE"
    print_status "Then you can use: k get nodes"
}

# Function to show current status
show_status() {
    print_status "Current kubectl configuration:"
    echo
    echo "KUBECONFIG environment variable: ${KUBECONFIG:-'Not set'}"
    echo "Default config location: $HOME/.kube/config"
    echo "Current working directory: $(pwd)"
    echo
    print_status "Available options:"
    echo "1. session    - Set up for current session only"
    echo "2. permanent  - Set up permanently (recommended)"
    echo "3. default    - Copy to default kubectl location"
    echo "4. alias      - Create 'k' alias for kubectl"
    echo "5. status     - Show current configuration"
}

# Main function
main() {
    echo "kubectl Setup Script for LKE Cluster"
    echo "===================================="
    echo
    
    if [ $# -eq 0 ]; then
        print_status "No option specified. Available options:"
        echo "  session    - Set up for current session only"
        echo "  permanent  - Set up permanently (recommended)"
        echo "  default    - Copy to default kubectl location"
        echo "  alias      - Create 'k' alias for kubectl"
        echo "  status     - Show current configuration"
        echo
        print_status "Usage: $0 [session|permanent|default|alias|status]"
        exit 1
    fi
    
    case "$1" in
        "session")
            setup_session
            ;;
        "permanent")
            setup_permanent
            ;;
        "default")
            setup_default_location
            ;;
        "alias")
            setup_alias
            ;;
        "status")
            show_status
            ;;
        *)
            print_error "Unknown option: $1"
            print_status "Available options: session, permanent, default, alias, status"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
