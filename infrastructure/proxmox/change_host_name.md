============== @breakaway9000 ======================

```https://forum.proxmox.com/threads/proxmox-node-name-change.14327/```

# Way 1

```
Powerdown all VMs and containers
Edit /etc/hostname and /etc/hosts with the new hostname
Reboot the host
At this point you will see your old host as "disconnected" in the web interface, and a new host with your new hostname appears.
SSH into the machine and navigate to /etc/pve/nodes - here you will see two folders (one with your new hostname, one with your old hostname)
The config for the containers is located at /etc/pve/nodes/<currenthostname>/lxc
The config for virtual machines is stored at /etc/pve/nodes/<currenthostname>/qemu-server
etc. depending on what other technologies you are using
So I just moved the contents of each folder into the folder for the new host - i.e. /etc/pve/nodes/<newhostname>/lxc etc. 
The second I did this, I saw the web interface update with the VMs and containers now showing in the correct datacenter and under the correct host.
Finally, move the folder with the old server's hostname (/etc/pve/nodes/<oldhostname>) somewhere for backup.
Reboot
```




# Way 2

From *cosmicdan*

1) Change some storage and config references in /etc/pve - just do a grep -ir 'oldhostnamehere' /etc/pve/. to find that
2) Don't forget to change the Search domain option for the node's DNS so your containers have they hostname set correctly (since PVE sets these dynamically).


```
cd /etc/pve/nodes/
cp -r old new
rm -r old
cd /var/lib/rrdcached/db/pve2-node/
cp -r old new
rm -r old
```