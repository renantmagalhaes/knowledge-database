# RabbitMQ — After Install

```sh
# Enable console
rabbitmq-plugins enable rabbitmq_management

# Delete guest user
rabbitmqctl delete_user guest

# Enable admin user with password 'admin'
rabbitmqctl add_user admin admin
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
```
