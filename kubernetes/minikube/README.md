# Minikube


# Installation 
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

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

- Run (edit the 192.168.49.2 for your return of minikube ip)

```
sudo /bin/sh -c 'echo "192.168.49.2    demo-container.local" >> /etc/hosts'
```