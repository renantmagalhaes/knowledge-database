#!/bin/bash

# OLD WAY
# #Download pip
# curl -O https://bootstrap.pypa.io/get-pip.py

# #Install pip - for all users
# sudo python get-pip.py 

# #Install aws cli for all users (dont need to add path)
# sudo pip install awscli

# Install AWS CLI
cd /tmp/
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
