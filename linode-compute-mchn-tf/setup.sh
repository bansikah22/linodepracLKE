#!/bin/bash

# Linode Terraform Setup Script
# This script helps you set up and deploy a Linode instance using Terraform

set -e

echo "Linode Terraform Setup Script"
echo "============================="

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "ERROR: Terraform is not installed. Please install Terraform first:"
    echo "   https://www.terraform.io/downloads.html"
    exit 1
fi

echo "SUCCESS: Terraform is installed"

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo "INFO: Creating terraform.tfvars from example..."
    if [ -f "terraform.tfvars.example" ]; then
        cp terraform.tfvars.example terraform.tfvars
        echo "SUCCESS: terraform.tfvars created"
        echo ""
        echo "IMPORTANT: Please edit terraform.tfvars with your actual values:"
        echo "   - linode_token: Your Linode API token"
        echo "   - root_password: A secure password for your server"
        echo ""
        echo "   Then run this script again."
        exit 0
    else
        echo "ERROR: terraform.tfvars.example not found"
        exit 1
    fi
fi

# Check if required variables are set
if grep -q "your-linode-api-token-here" terraform.tfvars; then
    echo "ERROR: Please update terraform.tfvars with your actual Linode API token"
    exit 1
fi

if grep -q "YourSecurePassword123!" terraform.tfvars; then
    echo "ERROR: Please update terraform.tfvars with a secure root password"
    exit 1
fi

echo "SUCCESS: Configuration looks good"

# Initialize Terraform
echo ""
echo "INFO: Initializing Terraform..."
terraform init

# Show the plan
echo ""
echo "INFO: Showing Terraform plan..."
terraform plan

# Ask for confirmation
echo ""
read -p "Do you want to apply this configuration? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "INFO: Applying Terraform configuration..."
    terraform apply -auto-approve
    
    echo ""
    echo "SUCCESS: Deployment complete!"
    echo ""
    echo "Instance Information:"
    echo "===================="
    terraform output instance_summary
    
    echo ""
    echo "Next Steps:"
    echo "1. SSH into your server: $(terraform output ssh_command)"
    echo "2. Change the default root password"
    echo "3. Set up your applications"
    echo "4. Configure your domain (if applicable)"
    
else
    echo "INFO: Deployment cancelled"
fi
