# Fargate

Deploy cluster

```
eksctl create cluster --with-oidc -f cluster.yaml
```

# Fargate vs EC2


- EC2

1. Control Plane runs on EKS
2. Worker Nodes runs on EC2, user need to manage Nodes
3. Pods can be exposed using Services (Load Balancer) And Ingress
4. Daemonsets are supported and used heavily
5. Able to run stateful apps (using EFS)
6. Wide range of workload dependant EC2 selection e.g GPU)
7. Can work in public and private subnet

- Fargate

1. Control Plane runs on EKS
2. No Worker Nodes required. Much less management overhead
3. Classic and NLBs not supported. Pods can be exposed using Ingress
4. Daemonsets are not supported. Need to run as Sidecar (no standart logging solution)
5. Stateful apps not recommended
6. Can’t select workload specific underlying hardware, no GPU. Max Pod size 4 vCPU and 30 Gb memory per pod
7. Only works in private subnet


# EC2 mix with Fargate

Its possible, and its setup via namespaces