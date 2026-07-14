# Secrets

- Can be used as environment variables
- Can be used as files in a pod
  - use volume to mount the files
- Can be used as dotenv files

# Create secrets

## CLI

```
echo -n 'root' > ./username.txt 
echo -n '@$$word!' > ./password.txt
kubectl create secret generic db-user-pass-secret --from-file=./username.txt --from-file=./password.txt
```

## Manifest

1. Get the values in base64

```
echo -n 'root' |base64
echo -n '@$$word!' |base64
```

2. Substitute and apply
   
```
apiVersion: v1
kind: Secret
metadata:
  name: db-user-pass-secret
type: Opaque
data:
  username: cm9vdA==
  password: QCQkd29yZCE=
```

`kubectl apply -f db-user-pass.yml`

# Mount secret in manifest

## Via env

```
        env:
          - name: WORDPRESS_DB_PASSWORD
            valueFrom:
              secretKeyRef:
                name: db-user-pass-secret
                key: password
```

## Via file

```
        volumeMounts:
        - name: cred-volume
          mountPath: /etc/creds
          readOnly: true
      volumes:
      - name: cred-volume
        secret: 
          secretName: db-user-pass-secret
```