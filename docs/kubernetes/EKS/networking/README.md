# Networking

## Network policy enforcer

1. Can See IP
2. Works on layer 3 and layer 4
3. A pod CAN see other pod even if its in another namespace, unless we use a network policy


## Install Calico

[DOCS](https://docs.aws.amazon.com/eks/latest/userguide/calico.html)

Network policies enforcers are **not enable** by default.

```
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-operator.yaml
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-crs.yaml
```


## Demo-1

Stars policy demo

This section walks through the Stars policy demo provided by the Project Calico documentation. The demo creates a frontend, backend, and client service on your Amazon EKS cluster. The demo also creates a management GUI that shows the available ingress and egress paths between each service.

Before you create any network policies, all services can communicate bidirectionally. After you apply the network policies, you can see that the client can only communicate with the frontend service, and the backend only accepts traffic from the frontend.

To run the Stars policy demo

Apply the frontend, backend, client, and management UI services:

```
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/00-namespace.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/01-management-ui.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/02-backend.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/03-frontend.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/04-client.yaml
```

Wait for all of the pods to reach the Running status:

kubectl get pods --all-namespaces --watch

To connect to the management UI, forward your local port 9001 to the management-ui service running on your cluster:

```kubectl port-forward service/management-ui -n management-ui 9001```

Open a browser on your local system and point it to http://localhost:9001/. You should see the management UI. The C node is the client service, the F node is the frontend service, and the B node is the backend service. Each node has full communication access to all other nodes (as indicated by the bold, colored lines).


Open network policy
                    
Apply the following network policies to isolate the services from each other:

```
kubectl apply -n stars -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/policies/default-deny.yaml
kubectl apply -n client -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/policies/default-deny.yaml
```

Refresh your browser. You see that the management UI can no longer reach any of the nodes, so they don't show up in the UI.

Apply the following network policies to allow the management UI to access the services:

```
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/policies/allow-ui.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/policies/allow-ui-client.yaml
```

Refresh your browser. You see that the management UI can reach the nodes again, but the nodes cannot communicate with each other.

UI access network policy
                    
Apply the following network policy to allow traffic from the frontend service to the backend service:

```
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/policies/backend-policy.yaml
```

Apply the following network policy to allow traffic from the client namespace to the frontend service:

```
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/policies/frontend-policy.yaml
```

Final network policy
                    
(Optional) When you are done with the demo, you can delete its resources with the following commands:

```
kubectl delete -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/04-client.yaml
kubectl delete -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/03-frontend.yaml
kubectl delete -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/02-backend.yaml
kubectl delete -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/01-management-ui.yaml
kubectl delete -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/tutorials/stars-policy/manifests/00-namespace.yaml
```

Even after deleting the resources, there can still be iptables rules on the nodes that might interfere in unexpected ways with networking in your cluster. The only sure way to remove Calico is to terminate all of the nodes and recycle them. To terminate all nodes, either set the Auto Scaling Group desired count to 0, then back up to the desired number, or just terminate the nodes. If you are unable to recycle the nodes, then see Disabling and removing Calico Policy in the Calico GitHub repository for a last resort procedure.

## Demo-2

```
kubectl apply -f files/demo/namespace-a.yaml
kubectl apply -f files/demo/namespace-b.yaml
kubectl apply -f files/demo/namespace-c.yaml
```

Enter in all 3 pods on different containers and ping the services

```
curl frontend-a.namespace-a.svc.cluster.local
curl frontend-b.namespace-b.svc.cluster.local
curl frontend-c.namespace-c.svc.cluster.local
```

Now apply the network policy and try again

```
kubectl  apply -f files/demo/network-policy.yaml
```

- Remove Demo

```
kubectl delete -f files/demo/network-policy.yaml
kubectl delete -f files/demo/namespace-a.yaml
kubectl delete -f files/demo/namespace-b.yaml
kubectl delete -f files/demo/namespace-c.yaml
```
