# Delete all Evicted pods at once.

```kubectl get pods -n default| grep Evicted | awk '{print $1}'  | xargs ```
```kubectl delete pod```


# Delete all Terminating pods

```kubectl get pods -n default| grep Terminating | awk '{print $1}'  | ```xargs 
```kubectl delete pod --grace-period=0```
```kubectl get pods -n default| grep Terminating | awk '{print $1}'  | ```xargs 
```kubectl delete pod --grace-period=0 --force```

# Node selector
```
kubectl get nodes
kubectl label nodes $node_name hardware=$label_name
```

# Inside deployment
    spec:
      containers:
      - name: k8s-label
        image: dockerhub_image:latest
        ports:
        - name: docker_application
          containerPort: 3000
      nodeSelector:
        hardware: label_name

kubectl get nodes --show-labelskubectl get nodes --show-labels

# Health check
```
    spec:
      containers:
      - name: k8s-heath-check
        image: dockerhub_image:latest
        ports:
        - name: port_name #optional
          containerPort: 3000
        livenessProbe:
          httpGet:
            path: /
            port: port_name # or port number
          initialDelaySeconds: 15
          timeoutSeconds: 30
        readinessProbe:
          httpGet:
            path: /
            port: port_name # or port number
          initialDelaySeconds: 15
          timeoutSeconds: 30
```
# Lifecyle
```
        lifecycle:
          postStart:
            exec:
              command: ['sh', '-c', 'echo $(date +%s): postStart >> /timing && sleep 10 && echo $(date +%s): end postStart >> /timing']
          preStop:
            exec:
              command: ['sh', '-c', 'echo $(date +%s): preStop >> /timing && sleep 10']
```

# Secrets 

## From file

```
echo -n "root" > ./username.txt
echo -n "password" > ./password.txt
kubectl create secret generic db-user-pass --from-file=./username.txt —from-file=./password.txt
secret "db-user-pass" created
```

## From ssh key or cert 
```
kubectl create secret generic ssl-certificate --from-file=ssh-privatekey=~/.ssh/id_rsa --ssl-cert-=ssl-cert=mysslcert.crt
```

## From yaml
```
echo -n "root" | base64
cm9vdA==
echo -n "password" | base64
cGFzc3dvcmQ=
```
```
apiVersion: v1
kind: Secret
metadata:
name: db-secret
type: Opaque
data:
password: cm9vdA==
username: cGFzc3dvcmQ=
```

```kubectl create -f secrets-db-secret.yml```

## Using secrets
```
env:
- name: SECRET_USERNAME
valueFrom:
secretKeyRef:
name: db-secret
key: username
- name: SECRET_PASSWORD
```

## OR 

```volumeMounts:
- name: credvolume
mountPath: /etc/creds
readOnly: true
volumes:
- name: credvolume
secret:
secretName: db-secrets
```

## The secrets will be stored in:
* /etc/creds/db-secrets/username
* /etc/creds/db-secrets/password

# DNS 
Inside the same pod, multiple containers can use localhost:port to communicate
Otherwise need to use the service type. 

## Communication between namespaces

app1-service.default
(service).(namespace name)
Or full path
app1-service.default.svc.cluster.local

# ConfigMap
Configuration parameters that are not secret, can be put in a ConfigMap
key and values pairs

```
cat <<EOF > app.properties
driver=jdbc
database=postgres
lookandfeel=1
otherparams=xyz
param.with.hierarchy=xyz
EOF
```

* kubectl create configmap app-config —from-file=app.properties
* Can use a a full configuration file, from nginx for example: kubectl //create configmap app-config —from-file=nginx.config
### Get a configmap value
```kubectl get configmap```
```kubectl get configmap $configmap_name -o yaml```

## Using configmap as volumeMounts

```
volumeMounts:
- name: config-volume
mountPath: /etc/config
volumes:
- name: config-volume
configMap:
name: app-config
```

## Using configmap as environment variables
```
env:
- name: DRIVER
valueFrom:
configMapKeyRef:
name: app-config
key: driver
- name: DATABASE
[...]
```

## Pod preset
apiVersion: settings.k8s.io/v1alpha1
kind: PodPreset
metadata:
name: share-credential
spec:
selector:
matchLabels:
app: myapp
env:
- name: MY_SECRET
value: "123456"
volumeMounts:
- mountPath: /share
name: share-volume
volumes:
- name: share-volume
emptyDir: {}


# StatefulSets
## Have stable pod hostname 
## Your podname will have a sticky identity, using an index, e.g. podname-0
podname-1 and podname-2 (and when a pod gets rescheduled, it’ll keep that
identity)

```apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: cassandra
  labels:
    app: cassandra
spec:
  serviceName: cassandra
  replicas: 3
  selector:
    matchLabels:
      app: cassandra
  template:
    metadata:
      labels:
        app: cassandra
    spec:
      terminationGracePeriodSeconds: 1800
      containers:
      - name: cassandra
        image: gcr.io/google-samples/cassandra:v13
      [...]
```


# Daemon Sets 
## Daemon Sets ensure that every single node in the Kubernetes cluster runs the same pod resource
## This is useful if you want to ensure that a certain pod is running on every single kubernetes node
## When a node is added to the cluster, a new pod will be started automatically
## Same when a node is removed, the pod will not be rescheduled on another node
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: monitoring-agent
  labels:
    app: monitoring-agent
spec:
  template:
    metadata:
      labels:
        name: monitor-agent
spec:
  containers:
  - name: k8s-demo
  image: wardviaene/k8s-demo
  ports:
  - name: nodejs-port
    containerPort: 3000

# Autoscaling
## kubectl get hpa

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hpa-example
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hpa-example
  template:
    metadata:
      labels:
        app: hpa-example
    spec:
      containers:
      - name: hpa-example
        image: gcr.io/google_containers/hpa-example
        ports:
        - name: http-port
          containerPort: 80
        resources:
          requests:
            cpu: 200m
---
apiVersion: v1
kind: Service
metadata:
  name: hpa-example
spec:
  ports:
  - port: 31001
    nodePort: 31001
    targetPort: http-port
    protocol: TCP
  selector:
    app: hpa-example
  type: NodePort
---
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-example-autoscaler
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hpa-example
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50

# affinity and anti-affinity
##There are currently 2 types you can use for node affinity:
##1) requiredDuringSchedulingIgnoredDuringExecution
##2) preferredDuringSchedulingIgnoredDuringExecution
##The first one sets a hard requirement (like the nodeSelector)
##The rules must be met before the pod can be scheduled
##The second type will try to enforce the rule, but it will not guarantee it
##Even if the rule is not met, the