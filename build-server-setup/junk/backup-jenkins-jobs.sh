#!/bin/bash

jenkins=$(cat "../jenkins-server-ip.txt")

if [ ! -e "./jenkins-cli.jar" ]; then
	curl "http://$jenkins:8080/jnlpJars/jenkins-cli.jar" -o "jenkins-cli.jar"
fi

java -jar jenkins-cli.jar -s http://$jenkins:8080/ list-jobs 