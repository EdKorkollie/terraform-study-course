#!/bin/bash

# sleep until instance is ready = means the script will not execute until the instance is up and ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
    sleep 1
done

# install nginx
apt-get update
apt-get -y install nginx

# make sure nginx is started
service nginx start