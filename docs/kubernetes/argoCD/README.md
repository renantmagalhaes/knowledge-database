# ArgoCD

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

[Tutorial](https://www.youtube.com/watch?v=MeU5_k9ssrs)
# Installations

## CLI

```
sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd
```

## K8s deployment

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

# Connect to Argo

**Method 1 - port-forward**

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
https://localhost:8080/
```

**Method 2 - change service type to loadbalancer**

```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get services -n argocd
```

## Credentials

user: admin
pass: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`


# Set Configuration

```
kubectl apply -f argoconf.yaml
```

## Add Credential (for private repos)
Generate [PAT token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) [in this link](https://github.com/settings/tokens/new)

- export GITHUB_TOKEN=<your-token>

[Docs](https://cloud.redhat.com/blog/how-to-use-argocd-deployments-with-github-tokens)

```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: argocd-demo-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  url: https://github.com/renantmagalhaes/argocd-demo
  password: ${GITHUB_TOKEN}
  username: not-used
EOF
```