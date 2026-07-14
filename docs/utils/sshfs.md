# SSHFS — Mount a Remote Linux Filesystem over SSH

!!! note "Source"
    Transcript from [tecmint.com](https://www.tecmint.com/sshfs-mount-remote-linux-filesystem-directory-using-ssh/).

SSHFS (Secure SHell FileSystem) lets you mount a remote filesystem and interact with remote directories and files on a local machine using SFTP over SSH. It relies on the FUSE (Filesystem in Userspace) kernel module, so no privileged kernel changes are required.

## Step 1: Install the SSHFS client

```sh
# yum install sshfs
# dnf install sshfs              # Fedora 22+
$ sudo apt-get install sshfs     # Debian/Ubuntu
```

## Step 2: Create the mount directory

```sh
# mkdir /mnt/tecmint
$ sudo mkdir /mnt/tecmint        # Debian/Ubuntu
```

## Step 3: Mount the remote filesystem

Replace `x.x.x.x` with the remote IP address:

```sh
# sshfs tecmint@x.x.x.x:/home/tecmint/ /mnt/tecmint
$ sudo sshfs -o allow_other tecmint@x.x.x.x:/home/tecmint/ /mnt/tecmint     # Debian/Ubuntu
```

If the server uses SSH key-based authentication, specify the key path:

```sh
# sshfs -o IdentityFile=~/.ssh/id_rsa tecmint@x.x.x.x:/home/tecmint/ /mnt/tecmint
$ sudo sshfs -o allow_other,IdentityFile=~/.ssh/id_rsa tecmint@x.x.x.x:/home/tecmint/ /mnt/tecmint     # Debian/Ubuntu
```

## Step 4: Verify the mount

```sh
# cd /mnt/tecmint
# ls
```

## Step 5: Check the mount point with `df -hT`

```sh
# df -hT
```

Sample output:

```
Filesystem                          Type        Size  Used Avail Use% Mounted on
tecmint@192.168.0.102:/home/tecmint fuse.sshfs  324G   55G  253G  18% /mnt/tecmint
```

## Step 6: Mount permanently via `/etc/fstab`

```sh
# vi /etc/fstab
$ sudo vi /etc/fstab     # Debian/Ubuntu
```

Add to the bottom of the file (requires SSH passwordless login for auto-mount on reboot):

```
sshfs#tecmint@x.x.x.x:/home/tecmint/ /mnt/tecmint fuse.sshfs defaults 0 0
```

Or, with SSH key-based authentication:

```
sshfs#tecmint@x.x.x.x:/home/tecmint/ /mnt/tecmint fuse.sshfs IdentityFile=~/.ssh/id_rsa defaults 0 0
```

Apply the changes:

```sh
# mount -a
$ sudo mount -a   # Debian/Ubuntu
```

## Step 7: Unmount the remote filesystem

```sh
# umount /mnt/tecmint
```
