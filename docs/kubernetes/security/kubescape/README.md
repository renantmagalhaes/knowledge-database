# Kubescape

[Official Docs](https://github.com/armosec/kubescape)


# Installation

## Linux

```
curl -s https://raw.githubusercontent.com/armosec/kubescape/master/install.sh | /bin/bash
```


# Scan

## Cluster

```
kubescape scan --submit
```

## YAML files

```
kubescape scan framework nsa mitre armobest *.yaml
```