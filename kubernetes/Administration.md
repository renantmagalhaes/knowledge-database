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