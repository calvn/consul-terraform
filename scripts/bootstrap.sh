#!/bin/bash

# Add docker to apt source
sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo <<EOF
# Ubuntu Precise
deb https://apt.dockerproject.org/repo ubuntu-precise main
# Ubuntu Trusty
deb https://apt.dockerproject.org/repo ubuntu-trusty main
# Ubuntu Vivid
deb https://apt.dockerproject.org/repo ubuntu-vivid main
# Ubuntu Wily
deb https://apt.dockerproject.org/repo ubuntu-wily main
EOF > /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get purge lxc-docker*
sudo apt-cache policy docker-engine
sudo apt-get install docker-engine
