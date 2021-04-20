# Manifests

Set manifest files, ready for use

## For minikube

```
minikube start
minikube addons enable ingress
```

### Get minikube ip
```
minikube ip
192.168.49.2
```

### Get host variable in ingress

```
 spec:
   rules:
   - host: demo-container.local
     http:
```

#### Add host and ip to computer hosts file

##### Location
```
/etc/hosts
```

```
sudo /bin/sh -c 'echo "192.168.49.2    demo-container.local" >> /etc/hosts'
```