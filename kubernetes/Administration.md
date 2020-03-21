- [Resources Quotas](#resources-quotas)
  * [On deployment](#on-deployment)
  * [On namespaces](#on-namespaces)
    + [Hardware](#hardware)
    + [Objects](#objects)
  * [LimitRange](#limitrange)
- [Namespaces](#namespaces)
  * [Create Namespace](#create-namespace)
  * [List Namespaces](#list-namespaces)
  * [Set default namespace to k8s cli](#set-default-namespace-to-k8s-cli)
- [User Management](#user-management)
  * [Create new user](#create-new-user)
  * [add new context](#add-new-context)
- [Node Maintenance](#node-maintenance)
- [TLS on AWS ELB](#tls-on-aws-elb)
  * [Example](#example)
  
# Resources Quotas
## On deployment
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloworld-deployment
  namespace: myspace
spec:
  replicas: 3
  selector:
    matchLabels:
      app: helloworld
  template:
    metadata:
      labels:
        app: helloworld
    spec:
      containers:
      - name: k8s-demo
        image: wardviaene/k8s-demo
        ports:
        - name: nodejs-port
          containerPort: 3000
        resources:
          requests:
            cpu: 200m
            memory: 0.5Gi
          limits:
            cpu: 400m
            memory: 1Gi
```

## On namespaces
### Hardware
```
apiVersion: v1
kind: Namespace
metadata:
  name: myspace
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: myspace
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```

### Objects
```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-quota
  namespace: myspace
spec:
  hard:
    configmaps: "10"
    persistentvolumeclaims: "4"
    replicationcontrollers: "20"
    secrets: "10"
    services: "10"
    services.loadbalancers: "2"
```

## LimitRange
```
apiVersion: v1
kind: LimitRange
metadata:
  name: limits
  namespace: myspace
spec:
  limits:
  - default:
      cpu: 200m
      memory: 512Mi
    defaultRequest:
      cpu: 100m
      memory: 256Mi
    type: Container
```

# Namespaces

## Create Namespace
```
kubectl create namespace NAMESPACENAME
```

## List Namespaces
```
kubectl get namespaces
```

## Set default namespace to k8s cli
```
export CONTEXT=$(kubectl config view | awk '/current-context/ {print $2}’)
kubectl config set-context $CONTEXT —namespace=myspace
```

# User Management

For EKS (https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html)

General (https://kubernetes.io/docs/reference/access-authn-authz/authorization/)

* To limit access, you need to configure authorization
  * AlwaysAllow / AlwaysDeny
  * ABAC (Attribute-Based Access Control)
  * RBAC (Role Based Access Control)
  * Webhook (authorization by remote service)

## Create new user
```
sudo apt install openssl
openssl genrsa -out USER.pem 2048
openssl req -new -key USER.pem -out USER-csr.pem -subj "/CN=USER/O=TEAM/"
openssl x509 -req -in USER-csr.pem -CA ca.crt -CAkey ca.key -CAcreateserial -out USER.crt -days 10000
```
## add new context
```
kubectl config set-credentials USER --client-certificate=USER.crt --client-key=USER.pem
kubectl config set-context USER --cluster=kubernetes.newtech.academy --user USER
```

# Node Maintenance

```
kubectl drain nodename --grace-period=600
```
or
```
kubectl drain nodename --force
```

# TLS on AWS ELB
* service.beta.kubernetes.io/aws-load-balancer-access-log-emit-interval
* service.beta.kubernetes.io/aws-load-balancer-access-log-enabled
* service.beta.kubernetes.io/aws-load-balancer-access-log-s3-bucket-name
* service.beta.kubernetes.io/aws-load-balancer-access-log-s3-bucket-prefix
* service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags 
* service.beta.kubernetes.io/aws-load-balancer-backend-protocol
* service.beta.kubernetes.io/aws-load-balancer-ssl-cert 
* service.beta.kubernetes.io/aws-load-balancer-connection-draining-enabled
* service.beta.kubernetes.io/aws-load-balancer-connection-draining-timeout 
* service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout
* service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled
* service.beta.kubernetes.io/aws-load-balancer-extra-security-groups

## Example
```
apiVersion: v1
kind: Service
metadata:
  name: helloworld-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:region:accountid:certificate/..." #replace this value
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
    service.beta.kubernetes.io/aws-load-balancer-connection-draining-enabled: "true"
    service.beta.kubernetes.io/aws-load-balancer-connection-draining-timeout: "60"
    service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags: "environment=dev,app=helloworld"
spec:
  ports:
  - name: http
    port: 80
    targetPort: nodejs-port
    protocol: TCP
  - name: https
    port: 443
    targetPort: nodejs-port
    protocol: TCP
  selector:
    app: helloworld
  type: LoadBalancer
  ```

  