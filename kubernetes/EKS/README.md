# Kubernetes EKS

# Kubernetes Cluster State


K8S State is nothing but a specific configuration. Kube-controller manager will jump into action and it is going to observe that the desired state is not equal to current state and it is going to bring up one more not to make the current state equal to desired


# Services

- LoadBalancer
    Automatically creates the rule to allow traffic to cluster
- Nodeport
    Need to create a security group to allow traffic to cluster (Can be called directly from the IP of any of the nodes, even if the pod is not schedule there)
- ClusterIP
    Allow traffic only inside cluster


# Declararive vs Imperative

- Declarative (Best way)
    Via manifests

- Imperative
    Via Kubectl commands

# EKS Data Plane

- Self Managed Node Groups
- Managed Node Groups
- AWS Fargate


# Ways to run

- LocalPC (using AWS config)
- AWS Cloud9 (Terminal)
- EC2 (command line)


# Kubectl Command Syntax

```
kubectl [command] [type] [name] [flags]

command -> create, get, describe, delete
type -> pods, namespaces, replicasets
name(optional) -> Name of the resource, if ommited show all
flag(optional) -> -f, --filename, --output 


kubectl get pods podname2 -o yaml
```
# Spin EKS Cluster


## Via CLI
```
eksctl create cluster \
--name EKS-Workshop \
--version 1.21 \
--region eu-west-1 \
--with-oidc \
--nodegroup-name standard-workers \
--node-type t3.xlarge \
--nodes 2 \
--nodes-min 1 \
--nodes-max 5 \
--managed
```

## Via cluster file yaml

```
eksctl create cluster --with-oidc -f cluster.yaml
```

* cluster.yaml
```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: EKS-Workshop
  region: eu-west-1
  version: 1.21

iam:
    withOIDC: true

managedNodeGroups:
  - name: standard-workers-1
    instanceType: t3.xlarge
    instancePrefix: EKS-WORKER
    instanceName: standard-workers-1
    minSize: 2
    maxSize: 5
    desiredCapacity: 2
    volumeSize: 80
    ssh:
      allow: true # will use ~/.ssh/id_rsa.pub as the default ssh key
    labels: {role: worker}
    tags:
      nodegroup-role: worker
    iam:
      withAddonPolicies:
        externalDNS: true
        certManager: true
        albIngress: true
        cloudWatch: true
        autoScaler: true
        ebs: true
        efs: true
```


# Upgrade EKS

## Cluster

```eksctl upgrade cluster --name=EKS-Workshop```
## NodeGropup
```eksctl upgrade nodegroup --name=standard-workers-1 --cluster=EKS-Workshop```


# Delete Cluster

```
eksctl get cluster
eksctl delete cluster --name=EKS-Workshop
```

# Pod Limit in a Node

There`s a limit on how many pods can run in a EC2 instance

For example a t2.micro will have less pods than an t2.2xlarge, even if the service consumes no resource 

# Helm v3

## Install Helm v3

```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > /tmp/get_helm.sh
chmod 700 /tmp/get_helm.sh
sh -c "/tmp/get_helm.sh"
```

# Login to cluster

```
aws eks --region eu-west-1 update-kubeconfig --name EKS-Workshop
```

# Utils

[AWS Container Roadmap](https://github.com/aws/containers-roadmap/projects/1)

# Guest book app Demo

[guesbook-go](https://github.com/kubernetes/examples/tree/master/guestbook-go)