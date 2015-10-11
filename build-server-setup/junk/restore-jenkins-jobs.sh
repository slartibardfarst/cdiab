#!/bin/bash

jenkins=$(cat "../jenkins-server-ip.txt")
echo $jenkins



curl -X POST -H "Content-Type:application/xml" -d @"build_api.xml" "http://$jenkins:8080/createItem?name=build_api"
