# RBAC Quick Reference Guide

A quick reference guide for using RBAC in the LKE cluster.

## 🚀 Quick Start

### Deploy RBAC
```bash
cd kubernetes
kubectl --kubeconfig kubeconfig.yaml apply -f manifests/rbac/
```

### Check RBAC Status
```bash
# List service accounts
kubectl --kubeconfig kubeconfig.yaml get serviceaccounts -n rbac

# List roles
kubectl --kubeconfig kubeconfig.yaml get clusterroles | grep -E "(developer|monitoring|readonly)"

# List role bindings
kubectl --kubeconfig kubeconfig.yaml get clusterrolebindings | grep -E "(developer|monitoring|readonly)"
```

## 🔧 kubectl Configuration (Optional)

To avoid using `--kubeconfig kubeconfig.yaml` every time, you can configure kubectl:

### Quick Setup
```bash
# Set up for current session
export KUBECONFIG=$(pwd)/kubeconfig.yaml

# Now you can use kubectl without --kubeconfig
kubectl get nodes
kubectl get pods --all-namespaces
```

### Permanent Setup
```bash
# Use the setup script (recommended)
./scripts/setup-kubectl.sh permanent

# Or manually add to your shell profile
echo 'export KUBECONFIG=/path/to/your/kubeconfig.yaml' >> ~/.zshrc
source ~/.zshrc
```

### Alternative Methods
```bash
# Copy to default location
./scripts/setup-kubectl.sh default

# Create alias
./scripts/setup-kubectl.sh alias

# Check current status
./scripts/setup-kubectl.sh status
```

## 👤 Service Accounts

| Service Account | Role | Use Case |
|----------------|------|----------|
| `developer-sa` | Developer | App deployment, debugging |
| `monitoring-sa` | Monitoring | Metrics collection, logs |
| `readonly-sa` | Read-Only | Auditing, reporting |
| `application-sa` | Application | App-specific access |
| `cluster-admin-sa` | Cluster Admin | Emergency access (disabled) |

## 🔐 Using Service Accounts

### Basic Usage
```bash
# Use developer account
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:developer-sa get pods

# Use monitoring account
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:monitoring-sa get pods

# Use read-only account
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:readonly-sa get pods
```

### Test Permissions
```bash
# Test developer permissions
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:developer-sa create deployment test --image=nginx

# Test monitoring permissions (should work)
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:monitoring-sa get pods

# Test monitoring permissions (should fail)
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:monitoring-sa create deployment test --image=nginx
```

## 🔧 Common Commands

### View RBAC Resources
```bash
# Service accounts
kubectl --kubeconfig kubeconfig.yaml get serviceaccounts -n rbac

# Cluster roles
kubectl --kubeconfig kubeconfig.yaml get clusterroles | grep -E "(developer|monitoring|readonly)"

# Cluster role bindings
kubectl --kubeconfig kubeconfig.yaml get clusterrolebindings | grep -E "(developer|monitoring|readonly)"

# Namespace roles
kubectl --kubeconfig kubeconfig.yaml get roles -n applications

# Namespace role bindings
kubectl --kubeconfig kubeconfig.yaml get rolebindings -n applications
```

### Check Permissions
```bash
# Check specific permission
kubectl --kubeconfig kubeconfig.yaml auth can-i --as=system:serviceaccount:rbac:developer-sa create deployments

# List all permissions
kubectl --kubeconfig kubeconfig.yaml auth can-i --list --as=system:serviceaccount:rbac:developer-sa

# Check namespace permission
kubectl --kubeconfig kubeconfig.yaml auth can-i --as=system:serviceaccount:rbac:application-sa get pods -n applications
```

### Debug RBAC Issues
```bash
# Describe service account
kubectl --kubeconfig kubeconfig.yaml describe serviceaccount developer-sa -n rbac

# Describe cluster role
kubectl --kubeconfig kubeconfig.yaml describe clusterrole developer-role

# Describe cluster role binding
kubectl --kubeconfig kubeconfig.yaml describe clusterrolebinding developer-binding

# Check events
kubectl --kubeconfig kubeconfig.yaml get events --all-namespaces | grep -i rbac
```

## 📋 Role Permissions Summary

### Developer Role (`developer-sa`)
- ✅ Create/update/delete deployments, services, pods
- ✅ Manage ingresses and network policies
- ✅ View RBAC resources
- ✅ Access all namespaces

### Monitoring Role (`monitoring-sa`)
- ✅ Read pods, services, deployments
- ✅ Access logs
- ✅ View metrics and autoscaling
- ❌ Cannot create or modify resources

### Read-Only Role (`readonly-sa`)
- ✅ View all resources
- ✅ List RBAC resources
- ❌ Cannot create, update, or delete anything

### Application Role (`application-sa`)
- ✅ Read application resources in applications namespace
- ❌ Cannot access other namespaces
- ❌ Cannot modify resources

## 🛠️ Management Commands

### Update RBAC
```bash
# Apply changes
kubectl --kubeconfig kubeconfig.yaml apply -f manifests/rbac/

# Delete specific resource
kubectl --kubeconfig kubeconfig.yaml delete clusterrole developer-role
kubectl --kubeconfig kubeconfig.yaml delete serviceaccount developer-sa -n rbac
```

### Cleanup RBAC
```bash
# Remove all RBAC resources
kubectl --kubeconfig kubeconfig.yaml delete -f manifests/rbac/
```

## 🔍 Troubleshooting

### Permission Denied
```bash
# Check if service account exists
kubectl --kubeconfig kubeconfig.yaml get serviceaccount developer-sa -n rbac

# Check if role binding exists
kubectl --kubeconfig kubeconfig.yaml get clusterrolebinding developer-binding

# Check permissions
kubectl --kubeconfig kubeconfig.yaml auth can-i --as=system:serviceaccount:rbac:developer-sa create deployments
```

### Service Account Not Found
```bash
# Check if namespace exists
kubectl --kubeconfig kubeconfig.yaml get namespace rbac

# Check all service accounts
kubectl --kubeconfig kubeconfig.yaml get serviceaccounts --all-namespaces | grep developer
```

## 📝 Examples

### Deploy Application with Service Account
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: applications
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      serviceAccountName: application-sa  # Use application service account
      containers:
      - name: my-app
        image: my-app:latest
```

### Monitor with Service Account
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      serviceAccountName: monitoring-sa  # Use monitoring service account
      containers:
      - name: prometheus
        image: prom/prometheus:latest
```

## ⚠️ Security Notes

- **Cluster Admin**: Disabled by default for security
- **Token Security**: Store service account tokens securely
- **Regular Audits**: Review permissions regularly
- **Least Privilege**: Grant minimal required permissions

## 📚 More Information

- Full RBAC Documentation: [RBAC.md](RBAC.md)
- Kubernetes RBAC: [Official Docs](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- Service Accounts: [Official Docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)

---

**Quick Reference - Keep this handy for daily RBAC operations!**
