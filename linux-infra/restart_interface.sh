#!/bin/bash
#  * * * * bash restart_interface.sh

ping -c 1 8.8.8.8
if [ $? -eq 0 ]; then
    echo Working
else
    systemctl restart networking
fi