# LKE Cluster Modules

This directory contains the modular components for the LKE cluster deployment.

## Module Structure

### 1. LKE Cluster Module (`lke-cluster/`)
**Purpose**: Core Kubernetes cluster creation and management
- Creates the LKE cluster with configurable node pools
- Manages cluster configuration and settings
- Provides cluster outputs and connection information

**Key Features**:
- Dynamic node pool configuration
- High availability support
- Multiple Kubernetes versions
- Region selection

### 2. NodeBalancer Module (`nodebalancer/`)
**Purpose**: Load balancing and traffic distribution
- Creates Linode NodeBalancer for external access
- Configures health checks and load balancing algorithms
- Manages backend node registration

**Key Features**:
- Configurable health checks
- Multiple load balancing algorithms
- Session stickiness options
- Automatic node registration

### 3. Monitoring Module (`monitoring/`)
**Purpose**: Observability and monitoring stack
- Uses community modules for proven solutions
- Deploys Prometheus, Grafana, and Alertmanager
- Includes NGINX Ingress Controller and cert-manager

**Community Modules Used**:
- `prometheus-community/kube-prometheus-stack/helm` - Complete monitoring stack
- `kubernetes-sigs/ingress-nginx/helm` - NGINX Ingress Controller
- `terraform-iaac/cert-manager/kubernetes` - SSL certificate management

**Key Features**:
- Prometheus metrics collection
- Grafana dashboards
- Alertmanager notifications
- SSL certificate automation
- Ingress traffic management

### 4. Security Module (`security/`)
**Purpose**: Security configurations and policies
- RBAC setup and admin user creation
- Network policies for pod-to-pod communication
- Pod security policies and standards

**Key Features**:
- Admin service account creation
- Default deny network policies
- Pod security standards
- Namespace isolation

## Benefits of Modular Approach

### 1. **Reusability**
- Modules can be reused across different environments
- Consistent configurations across projects
- Easy to share and maintain

### 2. **Maintainability**
- Clear separation of concerns
- Easier to update individual components
- Better code organization

### 3. **Community Integration**
- Leverages existing, tested community modules
- Reduces custom code and maintenance burden
- Benefits from community updates and improvements

### 4. **Flexibility**
- Enable/disable modules as needed
- Customize individual components
- Mix and match functionality

### 5. **Testing**
- Test modules independently
- Easier to validate individual components
- Better error isolation

## Module Dependencies

```
main.tf
├── lke-cluster (base)
├── nodebalancer (depends on lke-cluster)
├── security (depends on lke-cluster)
└── monitoring (depends on lke-cluster, security)
```

## Usage

### Basic Usage
```hcl
module "lke_cluster" {
  source = "./modules/lke-cluster"
  
  cluster_label = "my-cluster"
  k8s_version   = "1.31"
  region        = "us-east"
  node_pools    = var.node_pools
}
```

### With All Modules
```hcl
module "lke_cluster" {
  source = "./modules/lke-cluster"
  # ... configuration
}

module "nodebalancer" {
  source = "./modules/nodebalancer"
  # ... configuration
}

module "security" {
  source = "./modules/security"
  # ... configuration
}

module "monitoring" {
  source = "./modules/monitoring"
  # ... configuration
}
```

## Community Modules

This project leverages several community modules to reduce maintenance burden and ensure reliability:

### Prometheus Stack
- **Source**: `prometheus-community/kube-prometheus-stack/helm`
- **Version**: `~> 55.0`
- **Purpose**: Complete monitoring solution

### NGINX Ingress Controller
- **Source**: `kubernetes-sigs/ingress-nginx/helm`
- **Version**: `~> 4.0`
- **Purpose**: Ingress traffic management

### Cert Manager
- **Source**: `terraform-iaac/cert-manager/kubernetes`
- **Version**: `~> 2.0`
- **Purpose**: SSL certificate automation

## Best Practices

1. **Version Pinning**: All community modules use version constraints
2. **Dependency Management**: Clear dependency chain between modules
3. **Output Consistency**: Standardized output format across modules
4. **Documentation**: Each module is self-documenting
5. **Testing**: Modules can be tested independently

## Contributing

When adding new modules:
1. Follow the existing structure
2. Include comprehensive documentation
3. Use community modules when possible
4. Maintain consistent variable naming
5. Add appropriate outputs
