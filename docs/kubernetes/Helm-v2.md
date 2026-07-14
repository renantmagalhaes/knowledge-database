__HELM__
* https://helm.sh/

# Definition

* Helm the best way to find, share and use software built for Kubernetes

# Commands
| Command                                                  |  Description |
|----------------------------------------------------------|---|
| helm init                                                |  Install tiller on the cluster  |
| helm reset                                               |  Remove tiller from the cluster |
| helm install                                             |  Install a helm chart  |
| helm search                                              |  search for a chart |
| helm list                                                | list releases (installed charts)     |
| helm upgrade                                             |  upgrade a release   |
| helm rollback                                            | rollback a release to the previous version  |

# Install Helm

## Helm Client
```
wget https://get.helm.sh/helm-v2.16.4-linux-amd64.tar.gz
tar -xzvf helm-v2.16.4-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
```

# Tiller Client
## Add rbac-config.yaml

* kubectl create -f rbac-config.yaml

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```

## Start helm

```
helm init --service-account tiller
```
