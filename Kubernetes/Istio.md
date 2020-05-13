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

