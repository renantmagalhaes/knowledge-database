# Kube promehteus stack

# TODO

- Persist data
## Add repo

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

## Edit default values (if necessary)

```
helm pull prometheus-community/kube-prometheus-stack --untar=true
```

## Deploy stack

``` 
kubectl create ns monitoring
```

If there`s changes into the default files

```
helm install monitoring-stack -n monitoring --values values.yaml prometheus-community/kube-prometheus-stack
```

Otherwise

```
helm install monitoring-stack -n monitoring prometheus-community/kube-prometheus-stack
```

# Connect to grafana

```
kubectl -n monitoring port-forward svc/monitoring-stack-grafana 3000:80
http://localhost:3000
```

```
Grafana Access

user: admin
pass: prom-operator
```


# Uninstall chart

```
helm uninstall -n monitoring monitoring-stack
```

# Container Insights

- Install agent
Edit EKS-Workshop and eu-west-1 accordingly.

```
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml | sed "s/{{cluster_name}}/EKS-Workshop/;s/{{region_name}}/eu-west-1/" | kubectl apply -f -

```

- Delete

```
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml | sed "s/{{cluster_name}}/EKS-Workshop/;s/{{region_name}}/eu-west-1/" | kubectl delete -f -
```