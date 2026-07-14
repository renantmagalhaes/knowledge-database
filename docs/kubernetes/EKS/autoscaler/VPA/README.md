# VPA

# Install

## Deploy VPA
```
git clone https://github.com/kubernetes/autoscaler.git /tmp/autoscaler
sh -c "/tmp/autoscaler/vertical-pod-autoscaler/hack/vpa-up.sh"
```

## Depoloy goldilocks

```
kubectl create ns goldilocks
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install goldilocks --namespace goldilocks fairwinds-stable/goldilocks
```

- Label namespaces to be monitored

```
kubectl label ns goldilocks goldilocks.fairwinds.com/enabled=true
kubectl label ns monitoring goldilocks.fairwinds.com/enabled=true
etc
```

- View Dashboard

```
kubectl -n goldilocks port-forward svc/goldilocks-dashboard 8080:80
http://localhost:8080
```