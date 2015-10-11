#!/bin/bash

#http://urbanautomaton.com/blog/2014/09/09/redirecting-bash-script-output-to-syslog/
exec 1> >(logger -s -t $(basename $0)) 2>&1


#Jinstall ava
sudo yum -y install java-1.7.0-openjdk

# Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins

sudo service jenkins start
sudo chkconfig jenkins on

#wait until Jenkins is available
while [ 0 -eq `curl -s -I localhost:8080 | grep "Jenkins" | wc -l` ]
do
   echo "waiting for Jenkins to start..."
   sleep 5
done
echo "Jenkins is running!"

#update and install plugins
sudo cd /tmp
while [ true ]
do
   sudo wget http://localhost:8080/jnlpJars/jenkins-cli.jar
   if [ $? = 0 ]; then
      echo "jenkins-cli.jar downloaded!"
      break
   else
      echo "jenkins-cli.jar download failed, retrying..."
      sleep 5
   fi
done

UPDATE_LIST=$( java -jar ./jenkins-cli.jar -s http://127.0.0.1:8080/ list-plugins | grep -e ')$' | awk '{ print $1 }' ); 
UPDATE_LIST="$UPDATE_LIST greenballs build-name-setter github"
echo "Jenkins plugins to update: " $UPDATE_LIST

if [ ! -z "${UPDATE_LIST}" ]; then
    echo Updating Jenkins Plugins: ${UPDATE_LIST};
    java -jar ./jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin ${UPDATE_LIST};
    java -jar ./jenkins-cli.jar -s http://127.0.0.1:8080/ safe-restart;
fi
