# Config Map

A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

A ConfigMap allows you to decouple environment-specific configuration from your container images, so that your applications are easily portable.

- Environment variables
- Container command line arguments
- Volumes
- Full configuration files

# Generate configmap

```
cat <<EOF>> app.properties
driver=jdbc
database=postgres
variable1=xxx
variable2=yyy
parameter1=par_123
EOF

kubectl create configmap app-config --from-file=./app.properties  
```

# Mount

`kubectl create configmap index.html --from-file=./index.html`

## Via Volume

```
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
          volumeMounts:
            - name: nginx-config
              mountPath: /usr/share/nginx/html
              # readOnly: true
      volumes:
        - name: nginx-config
          configMap:
            name: index.html

```

## Via env

```
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
          env:
            - name: VALUEX
              valueFrom:
                configMapKeyRef:
                  name: username.txt
                  key: usernamex
```

- Get all values from configmap

```
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: username.txt
```