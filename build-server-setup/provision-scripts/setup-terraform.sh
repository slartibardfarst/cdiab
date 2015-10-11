#!/bin/bash

#http://urbanautomaton.com/blog/2014/09/09/redirecting-bash-script-output-to-syslog/
exec 1> >(logger -s -t $(basename $0)) 2>&1


pushd .
cd /tmp
sudo wget https://dl.bintray.com/mitchellh/terraform/terraform_0.6.3_linux_amd64.zip
sudo unzip terraform_0.6.3_linux_amd64.zip
sudo mv --force terraform* /usr/bin
sudo rm -rf /tmp/*
popd
