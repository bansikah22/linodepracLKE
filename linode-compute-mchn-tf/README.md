# Linode Compute Machine with Terraform

This repository contains Terraform configurations to deploy and manage Linode compute machines with automated setup and security best practices.

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/bansikah22/linode-compute-mchn-tf.git
   cd linode-compute-mchn-tf
   ```

2. **Configure your deployment**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Deploy your infrastructure**
   ```bash
   ./setup.sh
   ```

## 📚 Documentation

All documentation is organized in the `docs/` directory:

- **[README.md](docs/README.md)** - Comprehensive project overview and setup guide
- **[DEPLOYMENT.md](docs/DEPLOYMENT.md)** - Professional deployment guide with best practices
- **[POST_DEPLOYMENT.md](docs/POST_DEPLOYMENT.md)** - Post-deployment setup and configuration

## 🏗️ Infrastructure Components

This Terraform configuration creates:

- **Linode Instance**: Ubuntu 22.04 LTS server
- **Firewall**: Pre-configured security rules
- **Block Storage**: Optional persistent storage
- **Firewall**: Pre-configured security rules

## 🔧 Configuration Files

- `main.tf` - Main Terraform configuration
- `variables.tf` - Variable definitions
- `outputs.tf` - Output values
- `versions.tf` - Version constraints
- `terraform.tfvars.example` - Configuration template


## 🛠️ Helper Scripts

- `setup.sh` - Automated deployment script
- `destroy.sh` - Infrastructure cleanup script

## 📋 Prerequisites

- Terraform >= 1.0
- Linode account and API token
- SSH client

## 🎯 Features

- ✅ Professional documentation structure
- ✅ Automated deployment scripts
- ✅ Security best practices
- ✅ Comprehensive troubleshooting guides
- ✅ Cost optimization recommendations
- ✅ Monitoring and maintenance procedures

## 🔗 Quick Links

- [Linode Documentation](https://www.linode.com/docs/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Linode API Documentation](https://www.linode.com/docs/api/)

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!
