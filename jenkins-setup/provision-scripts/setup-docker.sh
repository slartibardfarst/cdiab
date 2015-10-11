#!/bin/bash

#http://urbanautomaton.com/blog/2014/09/09/redirecting-bash-script-output-to-syslog/
exec 1> >(logger -s -t $(basename $0)) 2>&1


# Docker
if [rpm -qa | grep docker | wc -l > 0]; then
   echo "Docker already installed, skipping..."
else
   curl -sSL https://get.docker.com/ | sh
fi

sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo gpasswd -a jenkins docker

sudo service docker start
sudo chkconfig docker on

sudo service jenkins restart

