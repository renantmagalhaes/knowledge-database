# Flux

TODO: source private repos

[Tutorialv2](https://www.youtube.com/watch?v=R6OeIgb7lUI)

[Official website](https://fluxcd.io)

Flux is a tool that automatically ensures that the state of a cluster matches the config in git. It uses an operator in the cluster to trigger deployments inside Kubernetes, which means you don't need a separate CD tool. It monitors all relevant image repositories, detects new images, triggers deployments and updates the desired running configuration based on that (and a configurable policy).

The benefits are: you don't need to grant your CI access to the cluster, every change is atomic and transactional, git has your audit log. Each transaction either fails or succeeds cleanly. You're entirely code centric and don't need new infrastructure.

# Install fluxctl

[Official guide](https://fluxcd.io/docs/installation/)

# Install Flux

``` 
curl -s https://fluxcd.io/install.sh | sudo bash
```

# Deploy Flux - Github

## Flux Stack

1. Create github repo
2. Generate [PAT token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) [in this link](https://github.com/settings/tokens/new)
   1. repo permission
   2. copy and secure token
3. export 
```
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>
```
4. install flux (change owner / repo / path)
```   
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=flux-fleet \
  --branch=main \
  --path=./apps \
  --private \
  --personal
  ```

## Create source

Link the git with all manifests files

Enter inside the git flux-fleet repo and:
```
flux create source git manifests \
    --url=ssh://git@github.com/$GITHUB_USER/flux-manifests \
    --private-key-file=~.ssh/id_rsa \
    --branch main \
    --interval 30s \
    --export \
    | tee apps/flux-source.yaml


flux create kustomization manifests \
    --source manifests \
    --path "./" \
    --prune true \
    --interval 5m \
    --export \
    | tee -a apps/flux-kustomization.yaml
```


# EXTRA

```
# Create files from secrets

ssh-keygen -q -N "" -f ./identity
ssh-keyscan github.com > ./known_hosts

kubectl create secret generic ssh-credentials \
    --from-file=./identity \
    --from-file=./identity.pub \
    --from-file=./known_hosts



flux create secret git manifests \
    --url=https://github.com/renantmagalhaes/flux-manifests \
    --private-key-file=./identity
```