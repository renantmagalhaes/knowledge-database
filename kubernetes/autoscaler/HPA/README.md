# POD HPA

Will work out of the box (only need metrics server installed)

## Demo
- Apply manifest

```
kubectl apply -f pod/hpa-php-apache.yaml
```

- Verify HPA

```
kubectl get hpa
watch -n 5 "kubectl get hpa"
```

- Apply load on service
```
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
```


Default value for Downscaling is 5 minutes

# Node HPA

Download latest manifest file
```
curl -o node/cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```

Modify the YAML file and replace <YOUR CLUSTER NAME> with your cluster name and apply the file

```
kubectl apply -f node/cluster-autoscaler-autodiscover.yaml
```

## Demo

```
kubectl apply -f node/hpa-php-apache.yaml
watch -n 5 "kubectl get nodes"
```