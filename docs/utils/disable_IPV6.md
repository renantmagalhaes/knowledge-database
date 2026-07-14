# Disable IPv6

## Red Hat-based system

```sh
# As root
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

# re-enable IPv6
sysctl -w net.ipv6.conf.all.disable_ipv6=0
sysctl -w net.ipv6.conf.default.disable_ipv6=0
```

## Debian-based system

```sh
vi /etc/sysctl.conf
```

Add at the bottom of the file:

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

Reboot the machine:

```sh
shutdown -r now
```

To re-enable IPv6, remove the above lines from `/etc/sysctl.conf` and reboot the machine.
