# Cost optimization

* Right Sizing

1. Utilize pod requests, limits, resource quotas
2. Use open source, third-party tools to tune pod requests, limits

* Auto Scaling

1. Once pods are optimized, enable auto scaling
2. Utilize HPA, Cluster Autoscaling, Proportional Autoscaling

* Down Scaling

1. Terminate pods unnecessary during nights, weekends
2. Utilize DevOps

* EC2 Purchase Options
  
1. Use RI, Spot, Savings Plan


# Tools

## Opensource

- rsg (Right Size guide)

- Kubecost (free with limitations)

- Kubernetes Resource Report

- Goldilocks

## Third Party

- Kubecost

- New Relic

- CloudHealth by vmware


# Demo

[DOCS](https://www.kubecost.com/install.html#show-instructions)

```
kubectl create namespace kubecost
helm repo add kubecost https://kubecost.github.io/cost-analyzer/
helm install kubecost kubecost/cost-analyzer --namespace kubecost --set kubecostToken="ZWZlZmVAZ21haWwuY29txm343yadf98"
```

```
kubectl port-forward --namespace kubecost deployment/kubecost-cost-analyzer 9090
```

http://localhost:9090