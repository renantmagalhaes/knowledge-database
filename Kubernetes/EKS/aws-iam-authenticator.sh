#!/bin/bash

# Install aws-iam-authenticator
cd /usr/local/bin \
&& sudo curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator \
&& sudo chmod +x ./aws-iam-authenticator \
&& cd -

# Install aws cli
#Download pip
curl -O https://bootstrap.pypa.io/get-pip.py

#Install pip - for all users
sudo python get-pip.py 

#Install aws cli for all users (dont need to add path)
sudo pip install awscli

