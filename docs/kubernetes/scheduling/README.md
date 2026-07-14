# Scheduling
# Node Selector
Node affinity is a property of Pods that attracts them to a set of nodes (either as a preference or a hard requirement)

```
kubectl label nodes node1 job=ai-training
kubectl label nodes node1 job=render-3d
```

## Pod configuration

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-k8s
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 2
  selector:
    matchLabels:
      app: hello-k8s
  template:
    metadata:
      labels:
        app: hello-k8s
    spec:
      containers:
        - name: hello-k8s
          image: CONTAINER_IMAGE
          ports:
            - containerPort: 80
      nodeSelector:
        job: ai-training
```
# Taints and tolerations

**Taints** are the opposite -- they allow a **node** to repel a set of pods.

**Tolerations** are applied to **pods**, and allow (but do not require) the pods to schedule onto nodes with matching taints.

Taints and tolerations work together to ensure that pods are **not scheduled onto inappropriate nodes**. One or more taints are applied to a node; this marks that the node should not accept any pods that do not tolerate the taints.


# Affinity / Anti-Affinity

It still can schedule pods even if there`s a anti-affinity. 