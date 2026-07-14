# Install Full Docker Suite

## Install latest Docker

```sh
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
```

## Install Docker Compose

[Reference](https://docs.docker.com/compose/install/#install-compose)

```sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Install Docker Machine

[Reference](https://docs.docker.com/machine/install-machine/)

```sh
base=https://github.com/docker/machine/releases/download/v0.16.0 && \
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine && \
sudo install /tmp/docker-machine /usr/local/bin/docker-machine
```
