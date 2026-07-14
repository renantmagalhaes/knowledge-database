# Autoscaling

[DOCS](https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html#cluster-autoscaler)

Need metrics server to be installed on cluster.

```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

# Horizontal Pod Autoscaler (HPA)


Horizontal Scaling means modifying the compute resources of an existing cluster, for example, by adding **new nodes** to it or by **adding new pods by increasing the replica count of pods** (Horizontal Pod Autoscaler).



# Vertical Pod Autoscaler (VPA) - ONLY LOCALLY -> DONT USE ON PRODUCTION / STAGE

Vertical Scaling means to **modify the attributed resources (like CPU or RAM) of each node in the cluster**. In most cases, this means creating an entirely new node pool using machines that have different hardware configurations. Vertical scaling on pods means dynamicall**y adjusting the resource requests and limits** based on the current application requirements (Vertical Pod Autoscaler).

- Pods will go up or down in size (after restart!)
- **Used in dev to determine optimal CPU and memory for the Pod**
- VPA should not be used with HPA
