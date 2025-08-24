# Kubernetes Manifests and Deployments

This directory contains Kubernetes manifests and deployment scripts for applications running on the LKE cluster.

## 📁 Directory Structure

```
kubernetes/
├── manifests/              # Kubernetes manifest files
│   ├── apps/              # Application deployments
│   │   ├── nginx-deployment.yaml
│   │   ├── nginx-service.yaml
│   │   ├── nginx-nodeport.yaml
│   │   └── nginx-loadbalancer.yaml
│   ├── monitoring/        # Monitoring stack
│   │   ├── prometheus-stack.yaml
│   │   ├── prometheus-service.yaml
│   │   ├── prometheus-nodeport.yaml
│   │   └── prometheus-loadbalancer.yaml
│   ├── security/          # Security policies
│   │   └── namespace-policy.yaml
│   ├── rbac/              # Role-Based Access Control
│   │   ├── namespace.yaml
│   │   ├── service-accounts.yaml
│   │   ├── roles.yaml
│   │   ├── role-bindings.yaml
│   │   └── cluster-admin.yaml
│   └── ingress/           # Ingress configurations
│       └── nginx-ingress.yaml
├── helm-charts/           # Helm charts (future use)
├── scripts/               # Deployment scripts
│   ├── deploy.sh          # Application deployment
│   ├── cleanup.sh         # Application cleanup
│   └── setup-kubectl.sh   # kubectl configuration
├── kubeconfig.yaml        # Cluster access configuration
└── README.md             # This file
```

## 🚀 Quick Start

### Prerequisites
- **kubectl**: Kubernetes command-line tool
- **kubeconfig.yaml**: Cluster access configuration file
- **Bash**: For running deployment scripts

### 1. Configure kubectl (Optional)
To avoid using `--kubeconfig kubeconfig.yaml` every time:

```bash
# Quick setup for current session
export KUBECONFIG=$(pwd)/kubeconfig.yaml

# Or use the setup script for permanent configuration
./scripts/setup-kubectl.sh permanent
```

### 2. Deploy All Applications
```bash
./scripts/deploy.sh
```

This will deploy:
- RBAC configurations (roles, service accounts)
- Security configurations (RBAC, network policies)
- Monitoring stack (Prometheus)
- Applications (nginx)
- Ingress configurations
- LoadBalancer services for external access

### 3. Access Applications

#### **LoadBalancer Access (Production)**
```bash
# Check LoadBalancer services
kubectl --kubeconfig kubeconfig.yaml get svc --all-namespaces | grep LoadBalancer
```

**Browser URLs:**
- **nginx**: http://143.42.179.193
- **Prometheus**: http://172.234.2.157:9090

#### **Port Forwarding (Development)**
```bash
# Access nginx locally
kubectl --kubeconfig kubeconfig.yaml port-forward svc/nginx-service 8080:80

# Access Prometheus locally
kubectl --kubeconfig kubeconfig.yaml port-forward svc/prometheus-service 9090:9090 -n monitoring
```

**Browser URLs:**
- **nginx**: http://localhost:8080
- **Prometheus**: http://localhost:9090

## 🎯 Features

### Application Deployments
- **nginx**: Web server with 2 replicas
- **Resource Management**: CPU and memory limits
- **Health Checks**: Liveness and readiness probes
- **Scaling**: Horizontal pod autoscaling ready

### Monitoring Stack
- **Prometheus**: Metrics collection and storage
- **Grafana Ready**: Framework for dashboards
- **Alertmanager Ready**: Framework for alerting
- **Service Discovery**: Automatic target discovery

### Security Features
- **RBAC**: Role-based access control with multiple roles
- **Network Policies**: Pod-to-pod communication control
- **Namespace Isolation**: Separate namespaces for applications
- **Service Accounts**: Secure application authentication

### RBAC Implementation
- **Developer Role**: Full application management permissions
- **Monitoring Role**: Read-only access for monitoring tools
- **Read-Only Role**: View-only access for auditors
- **Application Role**: Namespace-scoped application access
- **Cluster Admin**: Full cluster access (disabled by default)

### Load Balancing
- **LoadBalancer Services**: Automatic external IP assignment
- **NodePort Services**: Direct node access
- **ClusterIP Services**: Internal communication
- **Ingress Ready**: Traffic routing framework

## 🔧 Configuration

### Application Configuration
Applications are configured in `manifests/apps/`:
- **Deployments**: Pod specifications and scaling
- **Services**: Network access and load balancing
- **ConfigMaps**: Configuration data
- **Secrets**: Sensitive data (when needed)

### RBAC Configuration
RBAC is configured in `manifests/rbac/`:
- **Service Accounts**: User identities for different roles
- **ClusterRoles**: Cluster-wide permissions
- **Roles**: Namespace-scoped permissions
- **RoleBindings**: Binding roles to service accounts
- **ClusterRoleBindings**: Binding cluster roles to service accounts

### Monitoring Configuration
Monitoring is configured in `manifests/monitoring/`:
- **Prometheus**: Metrics collection configuration
- **Service Discovery**: Kubernetes service discovery
- **Alerting Rules**: Alert conditions (ready to add)
- **Dashboards**: Visualization (ready to add)

### Security Configuration
Security is configured in `manifests/security/`:
- **RBAC**: Roles and role bindings
- **Network Policies**: Traffic control rules
- **Pod Security**: Security contexts
- **Service Accounts**: Application identities

## 📊 Service Types

### LoadBalancer Services (Recommended)
- **Purpose**: External access with automatic IP assignment
- **Use Case**: Production applications
- **Example**: nginx-loadbalancer, prometheus-loadbalancer
- **Access**: Via external IP provided by Linode

### NodePort Services
- **Purpose**: Direct node access on specific ports
- **Use Case**: Development and testing
- **Example**: nginx-nodeport, prometheus-nodeport
- **Access**: Via node IP:port (e.g., 66.228.47.36:30080)

### ClusterIP Services
- **Purpose**: Internal cluster communication
- **Use Case**: Service-to-service communication
- **Example**: nginx-service, prometheus-service
- **Access**: Only from within the cluster

## 🔒 RBAC Roles and Permissions

### Developer Role
- **Permissions**: Full CRUD on applications, deployments, services
- **Use Case**: Application developers and DevOps engineers
- **Service Account**: `developer-sa`

### Monitoring Role
- **Permissions**: Read-only access to cluster resources
- **Use Case**: Monitoring tools (Prometheus, Grafana)
- **Service Account**: `monitoring-sa`

### Read-Only Role
- **Permissions**: View-only access to all resources
- **Use Case**: Auditors, stakeholders, read-only users
- **Service Account**: `readonly-sa`

### Application Role
- **Permissions**: Namespace-scoped read access
- **Use Case**: Application-specific service accounts
- **Service Account**: `application-sa`

### Cluster Admin Role
- **Permissions**: Full cluster access (disabled by default)
- **Use Case**: Emergency access only
- **Service Account**: `cluster-admin-sa` (commented out)

## 🔒 Security Best Practices

### Network Security
- **Default Deny**: Network policies block all traffic by default
- **Allow Specific**: Only allow necessary communication
- **Namespace Isolation**: Separate applications in namespaces
- **Service Mesh Ready**: Framework for advanced networking

### Access Control
- **RBAC**: Fine-grained permissions with multiple roles
- **Service Accounts**: Application-specific identities
- **Least Privilege**: Minimal required permissions
- **Audit Logging**: Track access and changes

### Resource Security
- **Resource Limits**: Prevent resource exhaustion
- **Security Contexts**: Pod-level security settings
- **Image Security**: Use trusted container images
- **Secret Management**: Secure credential handling

## 🐛 Troubleshooting

### Common Issues
1. **Service Not Accessible**: Check LoadBalancer external IP
2. **Pods Not Ready**: Check pod status and logs
3. **Network Issues**: Verify network policies
4. **Resource Issues**: Check resource limits and requests
5. **RBAC Issues**: Verify service account permissions

### Debug Commands
```bash
# Check pod status
kubectl --kubeconfig kubeconfig.yaml get pods --all-namespaces

# Check service status
kubectl --kubeconfig kubeconfig.yaml get svc --all-namespaces

# Check RBAC resources
kubectl --kubeconfig kubeconfig.yaml get serviceaccounts -n rbac
kubectl --kubeconfig kubeconfig.yaml get clusterroles | grep -E "(developer|monitoring|readonly)"
kubectl --kubeconfig kubeconfig.yaml get clusterrolebindings | grep -E "(developer|monitoring|readonly)"

# Check pod logs
kubectl --kubeconfig kubeconfig.yaml logs deployment/nginx-deployment

# Check events
kubectl --kubeconfig kubeconfig.yaml get events --all-namespaces

# Describe resources
kubectl --kubeconfig kubeconfig.yaml describe pod <pod-name>
```

## 🧹 Cleanup

### Remove Applications
```bash
./scripts/cleanup.sh
```

This will remove:
- Ingress configurations
- Applications
- Monitoring stack
- Security configurations
- RBAC configurations

### Manual Cleanup
```bash
# Remove specific resources
kubectl --kubeconfig kubeconfig.yaml delete -f manifests/apps/
kubectl --kubeconfig kubeconfig.yaml delete -f manifests/monitoring/
kubectl --kubeconfig kubeconfig.yaml delete -f manifests/security/
kubectl --kubeconfig kubeconfig.yaml delete -f manifests/rbac/
kubectl --kubeconfig kubeconfig.yaml delete -f manifests/ingress/
```

## 🔄 Best Practices

### Application Deployment
- **Use LoadBalancer Services**: For production external access
- **Implement Health Checks**: Liveness and readiness probes
- **Set Resource Limits**: Prevent resource exhaustion
- **Use Namespaces**: Organize and isolate applications

### Monitoring
- **Deploy Monitoring First**: Set up monitoring before applications
- **Use Service Discovery**: Automatic target discovery
- **Implement Alerting**: Proactive issue detection
- **Regular Maintenance**: Update and maintain monitoring stack

### Security
- **Security by Default**: Implement security policies early
- **Regular Audits**: Review and update security configurations
- **Least Privilege**: Minimal required permissions
- **Network Policies**: Control pod-to-pod communication

## 🚀 Next Steps

1. **Add More Applications**: Deploy your own applications
2. **Enhance Monitoring**: Add Grafana dashboards and Alertmanager
3. **Implement CI/CD**: Set up automated deployments
4. **Add Ingress Controller**: NGINX Ingress Controller for advanced routing
5. **Security Hardening**: Additional security policies
6. **Backup Strategy**: Implement Velero for backup/restore

## 📚 Documentation

- **Main README**: Project overview
- **Terraform README**: Infrastructure documentation
- **RBAC Documentation**: [docs/RBAC.md](../docs/RBAC.md)
- **RBAC Quick Reference**: [docs/RBAC_QUICK_REFERENCE.md](../docs/RBAC_QUICK_REFERENCE.md)
- **Kubernetes Documentation**: [Official Kubernetes Docs](https://kubernetes.io/docs/)
- **Linode LKE Documentation**: [LKE Documentation](https://www.linode.com/docs/products/compute/kubernetes/)

---

**Ready to deploy your applications! 🚀**
