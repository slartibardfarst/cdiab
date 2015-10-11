#cloud-boothook
#!/bin/bash

cat >> /home/centos/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzuhWme6wvmHxBiaVU3wCpuutS9K7613MYSDOwkLz40CtPR+aIcSombPWqDIRcurOaeUafEyhmlHdYyjEFieQC13G1GUtgMIcLIs1MONyLXO/DLVARd0d2KYLjzWE3Omql/lu8FKYqO5LYsp6eNyNntHVNvbjrkBIs32Ktz2iNJjZw8QLuPz70cJAjHf2q3Z7iSuPer9uxx0hyZLjm8zT6Z4yFkChxJ5TluqM/W2WockQP9MTg/zTEzAFwcsPyOmuEfGbtb9N6v5DlKZkdMHuorJZX+8hErjxka9jILZgC9rm2dCGT3gtgaB7iKbrl1NoUPCuk29cf3A1dC99cu/JR andrews-geo-dev-key-pair
EOF


echo "***** docker startup" >> /var/log/terraform.log 2>&1
systemctl start docker.service >> /var/log/terraform.log 2>&1
systemctl enable docker.service >> /var/log/terraform.log 2>&1
echo "***** done docker startup" >> /var/log/terraform.log 2>&1

mkdir -p /var/log/ecs >> /var/log/terraform.log 2>&1
mkdir -p /var/lib/ecs/data >> /var/log/terraform.log 2>&1

echo "***** docker installing ecs-agent" >> /var/log/terraform.log 2>&1
echo ${ecs_cluster}  >> /var/log/terraform.log 2>&1

docker run --name ecs-agent \
--detach=true \
--restart=on-failure:10 \
--volume=/var/run/docker.sock:/var/run/docker.sock \
--volume=/var/log/ecs/:/log \
--volume=/var/lib/ecs/data:/data \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/var/run/docker/execdriver/native:/var/lib/docker/execdriver/native:ro \
--publish=127.0.0.1:51678:51678 --env=ECS_LOGFILE=/log/ecs-agent.log \
--env=ECS_LOGLEVEL=info \
--env=ECS_DATADIR=/data \
--env=ECS_CLUSTER=${ecs_cluster} \
amazon/amazon-ecs-agent:latest  >> /var/log/terraform.log 2>&1

echo "***** docker finished installing ecs-agent" >> /var/log/terraform.log
