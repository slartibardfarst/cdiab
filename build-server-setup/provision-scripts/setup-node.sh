#!/bin/bash

#http://urbanautomaton.com/blog/2014/09/09/redirecting-bash-script-output-to-syslog/
exec 1> >(logger -s -t $(basename $0)) 2>&1


pushd .
cd /tmp
sudo wget https://nodejs.org/dist/v4.1.1/node-v4.1.1-linux-x64.tar.gz
sudo tar xzvf node-v4.1.1-linux-x64.tar.gz
sudo mv --force node-v4.1.1-linux-x64/bin/* /usr/bin
sudo mv --force node-v4.1.1-linux-x64/lib/* /usr/lib
sudo rm -rf /tmp/*
popd

sudo npm install -g mocha
sudo npm install -g mocha-junit-reporter
