# Ansible

## Installation

```
sudo pip3 install ansible
```

# Configuration file structure

1. ANSIBLE_CONFIG (env variable)
2. ./ansible.cfg (An ansible.cfg file, in the current directory) -- PREFERED WAY --
3. ~/.ansible.cfg (Hidden file in the home directory)
4. /etc/ansible/ansible.cfg 

# Register Ansible hosts
## Manual
Configuring SSH connectivity between hosts

### Generate ssh-keygen
```
ssh-keygen
```

### Copy public key to hosts (manual way)
```
ssh-copy-id -o StrictHostKeyChecking=no ansible@host1
ssh-copy-id -o StrictHostKeyChecking=no ansible@host2
ssh-copy-id -o StrictHostKeyChecking=no ansible@host3
ssh-copy-id -o StrictHostKeyChecking=no ansible@server1
ssh-copy-id -o StrictHostKeyChecking=no ansible@server2
ssh-copy-id -o StrictHostKeyChecking=no ansible@server3
```

## Automated way

### Install Package

```
sudo apt update
sudo apt install sshpass
```

### Create password file

```
echo "password" > password.txt
```

### Run script to register sshkey into hosts and servers (ansible and root user)

```
for user in ansible root
do
    for os in host server
    do
        for instance in 1 2 3
        do
            sshpass -f password.txt ssh-copy-id -o StrictHostKeyChecking=no ${user}@${os}${instance}
        done
    done
done
```

## Check if hosts are up and config is valid
```
ansible -i,host1,host2,host3,server1,server2,server3 all -m ping
```

## Commands

- Ping all hosts / groups
  
```
ansible all -m ping

ansible '*' -m ping
```
- Ping specific group
```  
ansible hostgroup -m ping

ansible servergroup -m ping
```

- Better interface  (add -o in the end)
```
ansible '*' -m ping -o
```

- List hosts
```
ansible all --list-hosts -o
```

- Overwrite variable
```
ansible all -m ping -e 'ansible_port=2222' -o
```