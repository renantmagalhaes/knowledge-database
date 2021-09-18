#!/bin/bash

# Install AWS CLI
cd /tmp/
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Kubectl 1.18.9
sudo wget https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/kubectl -O /usr/bin/kubectl
sudo chmod +x /usr/bin/kubectl

# Install aws-iam-authenticator
sudo wget https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator -O /usr/bin/aws-iam-authenticator
sudo chmod +x /usr/bin/aws-iam-authenticator

# Install ekscli
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin