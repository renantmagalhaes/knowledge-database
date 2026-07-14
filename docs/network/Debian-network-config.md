# Configure Network — Debian

First of all we need to find the correct network device. The command `netstat -i` will do the trick:

```sh
rtm@debian:~$ netstat -i
Kernel Interface table
Iface MTU Met RX-OK RX-ERR RX-DRP RX-OVR TX-OK TX-ERR TX-DRP TX-OVR Flg
eth0 1500 0 476 0 0 0 187 0 0 0 BMRU
lo 65536 0 0 0 0 0 0 0 0 0 LRU
```

In my case it's `eth0`. So let's edit the configuration file — remember you need to be root to do it! The file is located here:

```sh
vi /etc/network/interfaces
```

From now on we have two paths to follow, DHCP or static. Both are shown below.

## DHCP

Add these lines:

```
auto eth0
allow-hotplug eth0
iface eth0 inet dhcp
```

Then restart the interface:

```sh
root@debian:~# /etc/init.d/networking restart
[ ok ] Restarting networking (via systemctl): networking.service.
```

And it's done!

## Static

This requires a little more will. Edit the file and add the following lines according to your scenario:

```
auto eth0
iface eth0 inet static
address 192.168.0.21
netmask 255.255.255.0
gateway 192.168.0.1
dns-nameservers 8.8.8.8
```

Then restart the interface:

```sh
root@debian:~# /etc/init.d/networking restart
[ ok ] Restarting networking (via systemctl): networking.service.
```

And it's done! Everything must be working at this point.
