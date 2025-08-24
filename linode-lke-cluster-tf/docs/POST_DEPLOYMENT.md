# Post-Deployment Guide

Essential tasks to perform after successfully deploying your LKE cluster.

## Immediate Tasks

### 1. Verify Cluster Health
```bash
kubectl --kubeconfig kubeconfig.yaml get nodes -o wide
kubectl --kubeconfig kubeconfig.yaml get pods --all-namespaces
kubectl --kubeconfig kubeconfig.yaml cluster-info
```

### 2. Configure kubectl
```bash
cp kubeconfig.yaml ~/.kube/config
export KUBECONFIG=$(pwd)/kubeconfig.yaml
kubectl get nodes
```

### 3. Install Essential Tools
```bash
# Helm
curl https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz | tar xz
sudo mv linux-amd64/helm /usr/local/bin/

# kubectl plugins
kubectl krew install access-matrix
kubectl krew install resource-capacity
```

## Security Setup

### 1. RBAC Configuration
```bash
kubectl create serviceaccount admin-user
kubectl create clusterrolebinding admin-user-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=default:admin-user
kubectl create namespace applications
```

### 2. Network Policies
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: applications
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

## Monitoring Setup

### 1. Install Prometheus & Grafana
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace
```

### 2. Install Ingress Controller
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

## Application Deployment

### 1. Deploy Sample App
```bash
kubectl create deployment nginx --image=nginx:latest --namespace applications
kubectl expose deployment nginx --port=80 --type=ClusterIP --namespace applications
```

### 2. Test Application
```bash
kubectl get pods -n applications
kubectl get svc -n applications
kubectl port-forward svc/nginx 8080:80 -n applications
```

## Backup Strategy

### 1. Install Velero
```bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm install velero vmware-tanzu/velero \
  --namespace velero --create-namespace
```

### 2. Create Backup
```bash
velero backup create daily-backup --include-namespaces applications
```

## Performance Optimization

### 1. Resource Limits
```yaml
resources:
  requests:
    memory: "64Mi"
    cpu: "250m"
  limits:
    memory: "128Mi"
    cpu: "500m"
```

### 2. Horizontal Pod Autoscaler
```bash
kubectl autoscale deployment nginx --cpu-percent=50 --min=1 --max=10 -n applications
```

## Maintenance

### 1. Regular Updates
- Monitor Linode for LKE updates
- Update applications regularly
- Review security patches

### 2. Monitoring
- Set up alerts for resource usage
- Monitor costs with kubecost
- Regular security scans

## Troubleshooting

### Common Commands
```bash
# Check pod status
kubectl describe pod <pod-name> -n <namespace>

# View logs
kubectl logs -f deployment/nginx -n applications

# Check events
kubectl get events --sort-by='.lastTimestamp'

# Resource usage
kubectl top nodes
kubectl top pods --all-namespaces
```

## Next Steps

1. **Production Hardening**: Implement additional security
2. **CI/CD Pipeline**: Set up automated deployments
3. **Multi-Region**: Consider multi-region deployment
4. **Documentation**: Document procedures and configurations
5. **Training**: Train team on Kubernetes operations
