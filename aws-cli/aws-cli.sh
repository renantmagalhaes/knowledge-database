#!/bin/bash

#Download pip
curl -O https://bootstrap.pypa.io/get-pip.py

#Install pip - for all users
python get-pip.py 

#Install aws cli for all users (dont need to add path)
pip install awscli