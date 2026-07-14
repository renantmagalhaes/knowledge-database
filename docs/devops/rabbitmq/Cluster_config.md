# RabbitMQ — Cluster Config

```sh
# Master node
rabbitmqctl set_policy ha-all "" '{"ha-mode":"all","ha-sync-mode":"automatic"}'

# Slave nodes
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@SERVER_DNS_NAME
rabbitmqctl start_app
```

## Troubleshoot

All nodes MUST have the same `erlang.cookie`. Locations:

- `/var/lib/rabbitmq/.erlang.cookie`
- `$HOME/.erlang.cookie`

### Force file locations

```sh
touch /etc/rabbitmq/rabbitmq-env.conf
```

Content:

```
NODENAME=rabbit@$HOSTNAME
NODE_IP_ADDRESS=x.x.x.x
NODE_PORT=5672

HOME=/var/lib/rabbitmq
LOG_BASE=/var/log/rabbitmq
MNESIA_BASE=/var/lib/rabbitmq/mnesia
```
