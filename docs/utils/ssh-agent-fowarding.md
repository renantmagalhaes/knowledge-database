# SSH Agent Forwarding

Commands for SSH agent forwarding through a bastion host.

## Step 1: Create public/private key on the remote client (EC2)

```sh
ssh-keygen
```

## Step 2: Set up authentication

Copy the contents of the public key from the remote client to the `~/.ssh/authorized_keys` file of both the Bastion and the Private EC2 instance.

## Step 3: Use SSH agent forwarding

Run the following commands on the remote-client EC2 instance:

```sh
exec ssh-agent bash
eval 'ssh-agent -s'
ssh-add -L
ssh-add -k ~/.ssh/id_rsa
```

## Step 4: Test the setup

From the remote-client EC2, connect to the Bastion:

```sh
ssh -A [BASTION-EC2-IP]
```

Once logged into the Bastion, connect to the Private EC2:

```sh
ssh [IP-OF-PRIVATE-EC2]
```
