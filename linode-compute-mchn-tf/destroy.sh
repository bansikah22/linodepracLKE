#!/bin/bash

# Linode Terraform Destroy Script
# This script helps you destroy your Linode infrastructure

set -e

echo "Linode Terraform Destroy Script"
echo "==============================="

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "ERROR: Terraform is not installed"
    exit 1
fi

# Check if terraform.tfstate exists
if [ ! -f "terraform.tfstate" ]; then
    echo "ERROR: No Terraform state found. Nothing to destroy."
    exit 1
fi

echo "WARNING: This will destroy all resources created by Terraform!"
echo "   This includes:"
echo "   - Linode instance"
echo "   - Firewall"
echo "   - Block storage volumes"
echo "   - All data will be lost!"
echo ""

read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "INFO: Destroying infrastructure..."
    terraform destroy -auto-approve
    
    echo ""
    echo "SUCCESS: Infrastructure destroyed successfully!"
    echo ""
    echo "NOTE: You may want to remove terraform.tfvars if it contains sensitive information"
else
    echo "INFO: Destruction cancelled"
fi
