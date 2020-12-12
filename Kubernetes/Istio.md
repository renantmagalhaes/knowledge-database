- [Istio](#istio)
- [Install latest version (2020-05-03)](#install-latest-version-2020-05-03)
  - [Define service account for Tiller](#define-service-account-for-tiller)
  - [Install Istio CRDs](#install-istio-crds)
  - [Install Istio](#install-istio)
- [Example App (Hello World)](#example-app-hello-world)
- [Advanced routing](#advanced-routing)
- [Canary Deployments (weight distribution)](#canary-deployments-weight-distribution)
- [Retries](#retries)
- [Security](#security)
  - [Mutual TLS](#mutual-tls)
- [RBAC](#rbac)
- [Egress traffic](#egress-traffic)
# Istio 

# Install latest version (2020-05-03)


```curl -L https://git.io/getLatestIstio | sh -```

// version can be different as istio gets upgraded
```
cd istio-*
sudo mv -v bin/istioctl /usr/local/bin/
```

## Define service account for Tiller
Helm and Tiller are required for the following examples. If you have not installed Helm yet, please first reference the Helm chapter before proceeding.

First create a service account for Tiller:

```kubectl apply -f install/kubernetes/helm/helm-service-account.yaml```

## Install Istio CRDs
The Custom Resource Definitions, also known as CRDs are API resources which allow you to define custom resources.

```helm install install/kubernetes/helm/istio-init --name istio-init --namespace istio-system ```

You can check the installation by running:

```kubectl get crds --namespace istio-system | grep 'istio.io'```

This should return around 50 CRDs.

## Install Istio
The last step installs Istio’s core components:

```helm install install/kubernetes/helm/istio --name istio --namespace istio-system --set global.configValidation=false --set sidecarInjectorWebhook.enabled=false --set grafana.enabled=true --set servicegraph.enabled=true ```

You can verify that the services have been deployed using

```kubectl get svc -n istio-system```

and check the corresponding pods with:

```kubectl get pods -n istio-system```

# Example App (Hello World)

```kubectl apply -f <(istioctl kube-inject -f helloworld.yaml)```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
        version: v1
    spec:
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: hello
        - name: NEXT
          value: "world:8080"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hello
  labels:
    app: hello
spec:
  selector:
    app: hello
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: world
spec:
  replicas: 3
  selector:
    matchLabels:
      app: world
  template:
    metadata:
      labels:
        app: world
        version: v1
    spec:
      containers:
      - name: world
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: world
        - name: NEXT
          value: "world-2:8080"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: world
  labels:
    app: world
spec:
  selector:
    app: world
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: world-2
spec:
  replicas: 3
  selector:
    matchLabels:
      app: world-2
  template:
    metadata:
      labels:
        app: world-2
        version: v1
    spec:
      containers:
      - name: world-2
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: "!!!" 
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: world-2
  labels:
    app: world-2
spec:
  selector:
    app: world-2
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
```


```kubectl apply -f helloworld-gw.yaml```


```
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: helloworld-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: helloworld
spec:
  hosts:
  - "*"
  gateways:
  - helloworld-gateway
  http:
  - match:
    - uri:
        prefix: /hello
    route:
    - destination:
        host: hello.default.svc.cluster.local
        port:
          number: 8080
```

# Advanced routing

```
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: hello
spec:
  host: hello.default.svc.cluster.local
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: helloworld
spec:
  hosts:
  - "hello.example.com"
  gateways:
  - helloworld-gateway
  http:
  - match:
    - headers:
        end-user:
          exact: john
    route:
    - destination:
        host: hello.default.svc.cluster.local
        subset: v2 # match v2 only
        port:
          number: 8080
  - route: # default route for hello.example.com
    - destination:
        host: hello.default.svc.cluster.local
        subset: v1 # match v1 only
        port:
          number: 8080
```

# Canary Deployments (weight distribution)

```
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: hello
spec:
  host: hello.default.svc.cluster.local
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: helloworld
spec:
  hosts:
  - "hello.example.com"
  gateways:
  - helloworld-gateway
  http:
  - route:
    - destination:
        host: hello.default.svc.cluster.local
        subset: v1
        port:
          number: 8080
      weight: 90
    - destination:
        host: hello.default.svc.cluster.local
        subset: v2
        port:
          number: 8080
      weight: 10
```

# Retries
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-v3
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
        version: v3
    spec:
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: TEXT
          value: hello, this is $(MY_POD_NAME)
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-v3-latency
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
        version: v3
    spec:
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: TEXT
          value: hello, this is $(MY_POD_NAME)
        - name: LATENCY
          value: "5"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: hello
spec:
  host: hello.default.svc.cluster.local
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
  - name: v3
    labels:
      version: v3
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: helloworld-v3
spec:
  hosts:
  - "hello-v3.example.com"
  gateways:
  - helloworld-gateway
  http:
  - route: # default route for hello.example.com
    - destination:
        host: hello.default.svc.cluster.local
        subset: v3 # match v3 only
        port:
          number: 8080
    timeout: 10s
    retries:
      attempts: 2
      perTryTimeout: 2s
```

# Security

## Mutual TLS

* The goals of Istio security are (source: https://istio.io/docs/concepts/security/#authentication)
  * Security by default: no changes needed for application code and infrastructure
  * Defense in depth: integrate with existing security systems to provide multiple layers of defense
  * Zero-trust network: build security solutions on untrusted networks
  
* Istio provides two types of authentication:
  * Transport authentication (service to service authentication) using Mutual TLS
  * Origin authentication (end-user authentication)
   2.1 Verifying the end-user using a JSON Web Token (JWT)

* Mutual TLS in Istio:
  Can be turned on without having to change the code of applications (because of the sidecar deployment

* It provides each service with a strong identity
  * Attacks like impersonation by rerouting DNS records will fail, because a fake application can’t prove its identity using the certificate mechanism

* Secures (encrypts) service-to-service and end-user-to-service communication

* Provides key and certificate management to manage generation, distribution,and rotation

```
apiVersion: v1
kind: Namespace
metadata:
  name: ns1
---
apiVersion: v1
kind: Namespace
metadata:
  name: ns2
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-tls
  namespace: ns1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
        version: v1-tls
    spec:
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: hello
        - name: NEXT
          value: "world.ns2:8080"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: world-tls
  namespace: ns2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: world
  template:
    metadata:
      labels:
        app: world
        version: v1-tls
    spec:
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: world
        - name: NEXT
          value: "end.legacy:8080"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: world-reverse-tls
  namespace: ns2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: world-reverse
  template:
    metadata:
      labels:
        app: world-reverse
        version: v1-tls
    spec:
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: world
        - name: NEXT
          value: "end-reverse.ns1:8080"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: end-reverse-tls
  namespace: ns1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: end-reverse
  template:
    metadata:
      labels:
        app: end-reverse
        version: v1-tls
    spec:
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: "!!!"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hello
  namespace: ns1
  labels:
    app: hello
spec:
  selector:
    app: hello
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: world
  namespace: ns2
  labels:
    app: world
spec:
  selector:
    app: world
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: world-reverse
  namespace: ns2
  labels:
    app: world-reverse
spec:
  selector:
    app: world-reverse
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: end-reverse
  namespace: ns1
  labels:
    app: end-reverse
spec:
  selector:
    app: end-reverse
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: helloworld-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: hello
spec:
  host: hello.ns1.svc.cluster.local
  # uncomment to enable mutual TLS
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
  subsets:
  - name: v1-tls
    labels:
      version: v1-tls
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: hello-reverse
spec:
  host: hello-reverse.legacy.svc.cluster.local
  # uncomment to enable mutual TLS
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
  subsets:
  - name: v1-tls
    labels:
      version: v1-tls
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: helloworld-tls
spec:
  hosts:
  - "hello-tls.example.com"
  gateways:
  - helloworld-gateway
  http:
  - route: 
    - destination:
        host: hello.ns1.svc.cluster.local
        subset: v1-tls # match v3 only
        port:
          number: 8080
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: helloworld-tls-reverse
spec:
  hosts:
  - "hello-tls-reverse.example.com"
  gateways:
  - helloworld-gateway
  http:
  - route: 
    - destination:
        host: hello-reverse.legacy.svc.cluster.local
        subset: v1-tls 
        port:
          number: 8080
```

```
apiVersion: v1
kind: Namespace
metadata:
  name: legacy
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: end-tls
  namespace: legacy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: end
  template:
    metadata:
      labels:
        app: end
        version: v1-tls
    spec:
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: "!!!"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-reverse-tls
  namespace: legacy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-reverse
  template:
    metadata:
      labels:
        app: hello-reverse
        version: v1-tls
    spec:
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: hello
        - name: NEXT
          value: "world-reverse.ns2:8080"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: end
  namespace: legacy
  labels:
    app: end
spec:
  selector:
    app: end
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hello-reverse
  namespace: legacy
  labels:
    app: hello-reverse
spec:
  selector:
    app: hello-reverse
  ports:
  - name: http
    port: 8080
    targetPort: 8080
```

```
apiVersion: authentication.istio.io/v1alpha1
kind: "MeshPolicy"
metadata:
  name: "default"
spec:
  peers:
  - mtls: {}
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: "enable-mtls"
  namespace: "default" # even though we specify a namespace, this rule applies to all namespaces
spec:
  host: "*.local"
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
 name: "api-server"
spec:
 host: "kubernetes.default.svc.cluster.local"
 trafficPolicy:
   tls:
     mode: DISABLE
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: "legacy"
spec:
  host: "end.legacy.svc.cluster.local"
  trafficPolicy:
    tls:
      mode: DISABLE
```

# RBAC 

• Now that we’re using Mutual TLS, we have strong identities
• Based on those identities, we can start to doing Role Based Access Control (RBAC)
• RBAC allows us to limit access between our services, and from end-user to services
• Istio is able to verify the identity of a service by checking the identity of the x.509 certificate (which comes with enabling mutual TLS)
• For example: service A can be contacted by B, but not by C
• Good to know: The identities capability in istio is built using the SPIFFE standard (Secure Production Identity Framework For Everyone, another CNCF project) 

• RBAC in istio (source: https://istio.io/docs/concepts/security/)
• Can provide service-to-service and end-user-to-service authorization
• Supports conditions and role-binding

• You can bind to ServiceAccounts (which can be linked to pods)
• End-user-to-service can for example let you create condition on being authenticated using JWT
It has high performance, as its natively enforced on Envoy (the sidecar proxy)

• RBAC is not enabled by default, so we have to enable it
• We can enable it globally, or on a namespace basis
• For example, in the demo, we’ll only enable it for the “default”
• We can then create a ServiceRole that specifies the rules and a ServiceRoleBinding to link a ServiceRole to a subject (for exampleKubernetes ServiceAccount)

```
apiVersion: "rbac.istio.io/v1alpha1"
kind: ServiceRole
metadata:
  name: hello-viewer
  namespace: default
spec:
  rules:
  - services: ["hello.default.svc.cluster.local"]
    methods: ["GET", "HEAD"]
---
apiVersion: "rbac.istio.io/v1alpha1"
kind: ServiceRole
metadata:
  name: world-viewer
  namespace: default
spec:
  rules:
  - services: ["world.default.svc.cluster.local"]
    methods: ["GET", "HEAD"]
---
apiVersion: "rbac.istio.io/v1alpha1"
kind: ServiceRole
metadata:
  name: world-2-viewer
  namespace: default
spec:
  rules:
  - services: ["world-2.default.svc.cluster.local"]
    methods: ["GET", "HEAD"]
---
apiVersion: "rbac.istio.io/v1alpha1"
kind: ServiceRoleBinding
metadata:
  name: istio-ingress-binding
  namespace: default
spec:
  subjects:
  - properties:
      source.namespace: "istio-system"
  roleRef:
    kind: ServiceRole
    name: "hello-viewer"
---
apiVersion: "rbac.istio.io/v1alpha1"
kind: ServiceRoleBinding
metadata:
  name: hello-user-binding
  namespace: default
spec:
  subjects:
  - user: "cluster.local/ns/default/sa/hello"
  roleRef:
    kind: ServiceRole
    name: "world-viewer"
---
apiVersion: "rbac.istio.io/v1alpha1"
kind: ServiceRoleBinding
metadata:
  name: world-user-binding
  namespace: default
spec:
  subjects:
  - user: "cluster.local/ns/default/sa/world"
  roleRef:
    kind: ServiceRole
    name: "world-2-viewer"
---
### 
### Kubernetes Service accounts
###
apiVersion: v1
kind: ServiceAccount
metadata:
  name: hello
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: world
---
### 
### helloworld.yaml deployments, including a serviceaccount
### for the hello deployment and the world deployment
###
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
        version: v1
    spec:
      serviceAccountName: hello  # service account
      containers:
      - name: hello
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: hello
        - name: NEXT
          value: "world:8080"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hello
  labels:
    app: hello
spec:
  selector:
    app: hello
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: world
spec:
  replicas: 1
  selector:
    matchLabels:
      app: world
  template:
    metadata:
      labels:
        app: world
        version: v1
    spec:
      serviceAccountName: world  # service account
      containers:
      - name: world
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: world
        - name: NEXT
          value: "world-2:8080"
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: world
  labels:
    app: world
spec:
  selector:
    app: world
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: world-2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: world-2
  template:
    metadata:
      labels:
        app: world-2
        version: v1
    spec:
      containers:
      - name: world-2
        image: wardviaene/http-echo
        env:
        - name: TEXT
          value: "!!!" 
        ports:
        - name: http
          containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: world-2
  labels:
    app: world-2
spec:
  selector:
    app: world-2
  ports:
  - name: http
    port: 8080
    targetPort: 8080
---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: helloworld-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: helloworld
spec:
  hosts:
  - "hello-rbac.example.com"
  gateways:
  - helloworld-gateway
  http:
  - route:
    - destination:
        host: hello.default.svc.cluster.local
        subset: v1
        port:
          number: 8080
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: hello
spec:
  host: hello.default.svc.cluster.local
  # uncomment to enable mutual TLS
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
  subsets:
  - name: v1
    labels:
      version: v1
```
```
apiVersion: "rbac.istio.io/v1alpha1"
kind: RbacConfig
metadata:
  name: default
spec:
  mode: 'ON_WITH_INCLUSION'
  inclusion:
    namespaces: ["default"]
---
apiVersion: authentication.istio.io/v1alpha1
kind: "MeshPolicy"
metadata:
  name: "default"
spec:
  peers:
  - mtls: {}
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: "enable-mtls"
  namespace: "default" # even though we specify a namespace, this rule applies to all namespaces
spec:
  host: "*.local"
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
 name: "api-server"
spec:
 host: "kubernetes.default.svc.cluster.local"
 trafficPolicy:
   tls:
     mode: DISABLE
```

# Egress traffic

```
#
# http
# 
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: ifconfig-co-http
spec:
  hosts:
  - ifconfig.co
  ports:
  - number: 80
    name: http
    protocol: HTTP
  resolution: DNS
  location: MESH_EXTERNAL
---
#
# https
# 
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: ifconfig-co-https
spec:
  hosts:
  - ifconfig.co
  ports:
  - number: 443
    name: https
    protocol: HTTPS
  resolution: DNS
  location: MESH_EXTERNAL
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ifconfig-co
spec:
  hosts:
  - ifconfig.co
  tls:
  - match:
    - port: 443
      sni_hosts:
      - ifconfig.co
    route:
    - destination:
        host: ifconfig.co
        port:
          number: 443
      weight: 100
```

