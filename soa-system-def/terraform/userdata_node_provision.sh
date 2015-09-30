#!/bin/bash

echo "***** docker startup" >> /var/log/terraform.log
sudo systemctl start docker.service
sudo systemctl enable docker.service

echo "***** docker installing ecs-agent" >> /var/log/terraform.log
sudo docker run --name ecs-agent --detach=true --restart=on-failure:10 --volume=/var/run/docker.sock:/var/run/docker.sock --volume=/var/log/ecs/:/log --volume=/var/lib/ecs/data:/data --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro --volume=/var/run/docker/execdriver/native:/var/lib/docker/execdriver/native:ro --publish=127.0.0.1:51678:51678 --env=ECS_LOGFILE=/log/ecs-agent.log --env=ECS_LOGLEVEL=info --env=ECS_DATADIR=/data --env=ECS_CLUSTER=${ecs_cluster} amazon/amazon-ecs-agent:latest
echo "***** docker finished installing ecs-agent" >> /var/log/terraform.log