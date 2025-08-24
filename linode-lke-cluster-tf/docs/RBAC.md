# Role-Based Access Control (RBAC) Documentation

This document provides comprehensive information about the RBAC implementation in the LKE cluster, including roles, permissions, usage examples, and best practices.

## 📋 Table of Contents

1. [Overview](#overview)
2. [RBAC Architecture](#rbac-architecture)
3. [Roles and Permissions](#roles-and-permissions)
4. [Service Accounts](#service-accounts)
5. [Usage Examples](#usage-examples)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)
8. [Security Considerations](#security-considerations)

## 🎯 Overview

The RBAC system provides fine-grained access control to the Kubernetes cluster resources. It implements the principle of least privilege by granting users and applications only the permissions they need to perform their specific tasks.

### Key Features

- **Multiple Role Types**: Different roles for different use cases
- **Namespace Isolation**: Some roles are namespace-scoped
- **Service Account Based**: Uses Kubernetes service accounts for authentication
- **Audit Ready**: All access is logged and auditable
- **Security Focused**: Cluster admin role disabled by default

## 🏗️ RBAC Architecture

### Directory Structure

```
manifests/rbac/
├── namespace.yaml           # RBAC namespace
├── service-accounts.yaml    # Service accounts for different roles
├── roles.yaml              # ClusterRoles and Roles
├── role-bindings.yaml      # RoleBindings and ClusterRoleBindings
└── cluster-admin.yaml      # Cluster admin (disabled by default)
```

### Resource Hierarchy

```
Namespace: rbac
├── Service Accounts
│   ├── developer-sa
│   ├── monitoring-sa
│   ├── readonly-sa
│   ├── application-sa
│   └── cluster-admin-sa
├── ClusterRoles (cluster-wide)
│   ├── developer-role
│   ├── monitoring-role
│   └── readonly-role
├── Roles (namespace-scoped)
│   └── application-role
├── ClusterRoleBindings
│   ├── developer-binding
│   ├── monitoring-binding
│   └── readonly-binding
└── RoleBindings
    └── application-binding
```

## 🔐 Roles and Permissions

### 1. Developer Role

**Purpose**: Full application management capabilities for developers and DevOps engineers.

**Service Account**: `developer-sa`

**Permissions**:
```yaml
# Core Resources
- apiGroups: [""]
  resources: ["pods", "pods/log", "services", "configmaps", "secrets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

# Application Resources
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets", "daemonsets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

# Networking
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses", "networkpolicies"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

# RBAC Management
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["roles", "rolebindings"]
  verbs: ["get", "list", "watch"]

# Namespace Access
- apiGroups: [""]
  resources: ["namespaces"]
  verbs: ["get", "list", "watch"]
```

**Use Cases**:
- Application deployment and management
- Service configuration
- Ingress setup
- Debugging and troubleshooting

### 2. Monitoring Role

**Purpose**: Read-only access for monitoring tools and observability platforms.

**Service Account**: `monitoring-sa`

**Permissions**:
```yaml
# Cluster Resources
- apiGroups: [""]
  resources: ["pods", "services", "endpoints", "nodes", "namespaces"]
  verbs: ["get", "list", "watch"]

# Logs Access
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get", "list", "watch"]

# Application Resources
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets", "daemonsets"]
  verbs: ["get", "list", "watch"]

# Networking
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]

# Autoscaling
- apiGroups: ["autoscaling"]
  resources: ["horizontalpodautoscalers"]
  verbs: ["get", "list", "watch"]

# Batch Jobs
- apiGroups: ["batch"]
  resources: ["jobs", "cronjobs"]
  verbs: ["get", "list", "watch"]
```

**Use Cases**:
- Prometheus metrics collection
- Grafana dashboards
- Log aggregation
- Performance monitoring

### 3. Read-Only Role

**Purpose**: View-only access for auditors, stakeholders, and read-only users.

**Service Account**: `readonly-sa`

**Permissions**:
```yaml
# All Resources (Read-Only)
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets", "namespaces", "nodes"]
  verbs: ["get", "list", "watch"]

# Application Resources
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets", "daemonsets"]
  verbs: ["get", "list", "watch"]

# Networking
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses", "networkpolicies"]
  verbs: ["get", "list", "watch"]

# RBAC Resources
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["roles", "rolebindings", "clusterroles", "clusterrolebindings"]
  verbs: ["get", "list", "watch"]
```

**Use Cases**:
- Compliance auditing
- Stakeholder reporting
- Security reviews
- Documentation

### 4. Application Role

**Purpose**: Namespace-scoped access for application-specific service accounts.

**Service Account**: `application-sa`

**Permissions** (namespace-scoped):
```yaml
# Application Resources
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets"]
  verbs: ["get", "list", "watch"]

# Deployments
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch"]
```

**Use Cases**:
- Application service accounts
- Microservice authentication
- Namespace-specific operations

### 5. Cluster Admin Role

**Purpose**: Full cluster access (disabled by default for security).

**Service Account**: `cluster-admin-sa`

**Permissions**: Full cluster access (equivalent to `cluster-admin` built-in role)

**Use Cases**:
- Emergency access only
- Cluster administration
- Disaster recovery

**⚠️ Security Note**: This role is commented out by default. Only enable when absolutely necessary.

## 👤 Service Accounts

### Overview

Service accounts are Kubernetes identities that allow applications and users to authenticate with the cluster. Each role has a corresponding service account in the `rbac` namespace.

### Service Account Details

| Service Account | Role | Namespace | Purpose |
|----------------|------|-----------|---------|
| `developer-sa` | Developer | rbac | Application development and deployment |
| `monitoring-sa` | Monitoring | rbac | Monitoring and observability |
| `readonly-sa` | Read-Only | rbac | Auditing and reporting |
| `application-sa` | Application | rbac | Application-specific access |
| `cluster-admin-sa` | Cluster Admin | rbac | Emergency cluster access |

### Service Account Tokens

Each service account automatically gets a token that can be used for authentication:

```bash
# Get service account token
kubectl --kubeconfig kubeconfig.yaml get secret -n rbac <service-account-name>-token-<random> -o jsonpath='{.data.token}' | base64 -d
```

## 🚀 Usage Examples

### 1. Using Service Accounts with kubectl

```bash
# Use developer service account
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:developer-sa get pods --all-namespaces

# Use monitoring service account
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:monitoring-sa get pods --all-namespaces

# Use read-only service account
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:readonly-sa get pods --all-namespaces
```

### 2. Testing Permissions

```bash
# Test developer permissions
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:developer-sa create deployment test-deployment --image=nginx

# Test monitoring permissions (should work)
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:monitoring-sa get pods

# Test monitoring permissions (should fail)
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:monitoring-sa create deployment test-deployment --image=nginx

# Test read-only permissions
kubectl --kubeconfig kubeconfig.yaml --as=system:serviceaccount:rbac:readonly-sa get all --all-namespaces
```

### 3. Application Deployment with RBAC

```yaml
# Example: Deploy application with specific service account
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

### 4. Monitoring Configuration

```yaml
# Example: Prometheus configuration using monitoring service account
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: monitoring
---
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

## 🔧 Management Commands

### View RBAC Resources

```bash
# List all service accounts
kubectl --kubeconfig kubeconfig.yaml get serviceaccounts -n rbac

# List cluster roles
kubectl --kubeconfig kubeconfig.yaml get clusterroles | grep -E "(developer|monitoring|readonly)"

# List cluster role bindings
kubectl --kubeconfig kubeconfig.yaml get clusterrolebindings | grep -E "(developer|monitoring|readonly)"

# List roles in applications namespace
kubectl --kubeconfig kubeconfig.yaml get roles -n applications

# List role bindings in applications namespace
kubectl --kubeconfig kubeconfig.yaml get rolebindings -n applications
```

### Check Permissions

```bash
# Check what a service account can do
kubectl --kubeconfig kubeconfig.yaml auth can-i --as=system:serviceaccount:rbac:developer-sa create deployments

# Check specific permissions
kubectl --kubeconfig kubeconfig.yaml auth can-i --as=system:serviceaccount:rbac:monitoring-sa get pods --all-namespaces

# Check namespace-specific permissions
kubectl --kubeconfig kubeconfig.yaml auth can-i --as=system:serviceaccount:rbac:application-sa get pods -n applications
```

### Update RBAC

```bash
# Apply RBAC changes
kubectl --kubeconfig kubeconfig.yaml apply -f manifests/rbac/

# Delete specific role
kubectl --kubeconfig kubeconfig.yaml delete clusterrole developer-role

# Delete specific service account
kubectl --kubeconfig kubeconfig.yaml delete serviceaccount developer-sa -n rbac
```

## 🛡️ Best Practices

### 1. Principle of Least Privilege

- **Grant minimal permissions**: Only give users the permissions they absolutely need
- **Regular audits**: Review permissions regularly and remove unnecessary access
- **Role separation**: Use different roles for different purposes

### 2. Security Considerations

- **Disable cluster admin**: Keep cluster admin role disabled by default
- **Use namespaces**: Isolate applications in separate namespaces
- **Monitor access**: Log and monitor all RBAC access
- **Rotate tokens**: Regularly rotate service account tokens

### 3. Organization

- **Consistent naming**: Use consistent naming conventions for roles and service accounts
- **Documentation**: Document all roles and their purposes
- **Version control**: Keep RBAC manifests in version control
- **Testing**: Test permissions before deploying to production

### 4. Monitoring and Auditing

- **Access logs**: Monitor all access to the cluster
- **Permission changes**: Track changes to roles and permissions
- **Regular reviews**: Conduct regular security reviews
- **Compliance**: Ensure RBAC meets compliance requirements

## 🔍 Troubleshooting

### Common Issues

#### 1. Permission Denied Errors

```bash
# Error: "forbidden: User \"system:serviceaccount:rbac:developer-sa\" cannot create deployments"

# Solution: Check if the service account has the right permissions
kubectl --kubeconfig kubeconfig.yaml auth can-i --as=system:serviceaccount:rbac:developer-sa create deployments
```

#### 2. Service Account Not Found

```bash
# Error: "serviceaccount \"developer-sa\" not found"

# Solution: Check if the service account exists
kubectl --kubeconfig kubeconfig.yaml get serviceaccount developer-sa -n rbac
```

#### 3. Role Binding Issues

```bash
# Error: "clusterrolebinding \"developer-binding\" not found"

# Solution: Check if the role binding exists
kubectl --kubeconfig kubeconfig.yaml get clusterrolebinding developer-binding
```

### Debug Commands

```bash
# Check service account details
kubectl --kubeconfig kubeconfig.yaml describe serviceaccount developer-sa -n rbac

# Check role details
kubectl --kubeconfig kubeconfig.yaml describe clusterrole developer-role

# Check role binding details
kubectl --kubeconfig kubeconfig.yaml describe clusterrolebinding developer-binding

# Check what permissions a user has
kubectl --kubeconfig kubeconfig.yaml auth can-i --list --as=system:serviceaccount:rbac:developer-sa
```

### Logs and Events

```bash
# Check RBAC-related events
kubectl --kubeconfig kubeconfig.yaml get events --all-namespaces | grep -i rbac

# Check API server logs for RBAC issues
kubectl --kubeconfig kubeconfig.yaml logs -n kube-system deployment/kube-apiserver | grep -i rbac
```

## 🔒 Security Considerations

### 1. Token Security

- **Secure storage**: Store service account tokens securely
- **Token rotation**: Regularly rotate service account tokens
- **Access control**: Limit access to service account tokens
- **Monitoring**: Monitor token usage and access

### 2. Network Security

- **Network policies**: Use network policies to control pod-to-pod communication
- **TLS**: Use TLS for all API communication
- **Firewall rules**: Implement firewall rules to restrict access
- **VPN access**: Use VPN for secure cluster access

### 3. Audit and Compliance

- **Audit logging**: Enable audit logging for all API requests
- **Compliance**: Ensure RBAC meets compliance requirements
- **Regular reviews**: Conduct regular security reviews
- **Incident response**: Have incident response procedures in place

### 4. Access Management

- **User lifecycle**: Manage user access throughout their lifecycle
- **Offboarding**: Properly remove access when users leave
- **Temporary access**: Use temporary access for contractors
- **Emergency access**: Have emergency access procedures

## 📚 Additional Resources

- [Kubernetes RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [RBAC Best Practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)
- [Service Accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
- [RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/authorization/)

---

**For questions or issues with RBAC, please refer to the troubleshooting section or contact the cluster administrators.**
