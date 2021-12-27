# Security

Deployment Manifest -> Service Acccount -> IAM Role -> Policies

IAM OIDC Provider (Cluster Level) -> AWS Identity and IAM


- IAM Role is all about specific implementation (AWS in this case)

Pods need Kubernetes Cluster access as well

- ClusterRoles grant access to cluster-specific resources
- Create/Delete/List/etc. Nodes
- Create/Delete/List/etc. Pods
- Create/Delete/List/etc. Namespaces
- etc.

```
kubectl get clusterrole
kubectl describe clusterrole admin
kubectl describe clusterrole view
```

# Role vs ClusterRule

Both Role and ClusterRole represent set of permissions
- A Role sets permission within a particular namespace - have to specify namespace
- ClusterRole is non-namespaced

![picture 1](../images/7ce4aba568127d59c5bdb8fbda25880536489ca3fb3c0d3a9227a49b1abad0bd.png)  
![picture 2](../images/27736e540b8ed80bcb32dde1274c1dcab1a99c3e6cafe9d64f3c7237c08ee9c8.png)  

# Types of security

- For application

![picture 5](../images/a15b4a9b25e9d0d5af13d7e792e994d207e8bd5d69ee458c88d29d76157dfb15.png)  


- For users (humans)

**RBAC**

![picture 4](../images/21a52bffe07f5b904059e1be535b700848efc219859441d24f1cc2f6d4ca0976.png)  
![picture 3](../images/8f7845ce8590983854210d8f5dbb585cf05178f7090f7b12206f02b7e0837c6e.png)  


# Give access to users in EKS

##  Admin

Edit aws-auth
```
kubectl edit -n kube-system configmap/aws-auth
```

Add the config

```
  mapUsers: |
    - userarn: arn:aws:iam::123456789012:user/adminuser
      username: adminuser
      groups:
        - system:masters
```

## Granular Access 

1. apply role rule
   1. This will give access ONLY to monitoring namespace

```
kubectl apply -f files/monitoring-user-rolebinding.yaml
```

Edit aws-auth
```
kubectl edit -n kube-system configmap/aws-auth
```

Add the config

```
  mapUsers: |
    - userarn: arn:aws:iam::111111111111:user/k8s-test-user
      username: k8s-test-user
      groups:
        - monitoring-role
```

Login as k8s-test-user

```
kubectl get pods -n kube-system
kubectl get pods -n monitoring
```