#!/bin/bash -ex

#http://urbanautomaton.com/blog/2014/09/09/redirecting-bash-script-output-to-syslog/
#exec 1> >(logger -s -t $(basename $0)) 2>&1


#https://alestic.com/2010/12/ec2-user-data-output/
sudo touch     /var/log/user-data.log
sudo chmod 666 /var/log/user-data.log
sudo chmod 666 /dev/console
sudo chmod 666 /var/log/messages
#exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

logger "******** hello  ************" 
sudo touch /var/log/andrew_was_here
