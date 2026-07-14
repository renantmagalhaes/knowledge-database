# Keel.sh

[Official Docs](https://keel.sh/docs/)

# Installation

1. Get latest manifest file

```
wget https://sunstone.dev/keel?namespace=keel&username=admin&password=admin&tag=latest -O keel-deployment.yaml
```

2. If you dont want to expose the keel admin interface, change (line 94)

```
spec:
  type: LoadBalancer
```

To

```
spec:
  type: ClusterIP
```

3. Set your Docker Repo / Credentials / Access Keys

For example:

```
            - name: BASIC_AUTH_USER
              value: admin
            - name: BASIC_AUTH_PASSWORD
              value: admin
            - name: AWS_ACCESS_KEY_ID
              value: ""
            - name: AWS_SECRET_ACCESS_KEY
              value: ""
            - name: AWS_REGION
              value: ""
            - name: SLACK_TOKEN
              value: ""
            - name: SLACK_CHANNELS
              value: "general"
            - name: SLACK_APPROVALS_CHANNEL
              value: "general"
            - name: SLACK_BOT_NAME
              value: "keel"

```

4. Apply configuration

`kubectl apply -f kubectl apply -f keel-deployment.yaml`

# Add policies to manifest file

Policies to get every latest release. Need 1 approval

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-interface
  namespace: "app-frontend"
  labels:
    app: xsensors
    keel.sh/policy: all
    keel.sh/trigger: poll
    keel.sh/approvals: "1"
```

[To see all other options click here](https://keel.sh/docs/#policies):



# Access Dashboard

```
kubectl port-forward -n keel svc/keel 9300:9300
```

[keel dashboard](http://localhost:9300)
