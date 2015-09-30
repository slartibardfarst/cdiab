provider "aws" {
    access_key = "ASIAIXPK3H4S5VEDZD7Q"
    secret_key = "DuRYLNUq71+3dX9YAurkpLSpxWpT1tYS2da93vQH"
    region = "us-west-2"
}

resource "aws_instance" "ecs-docker-host" {
  count = "${var.instance_count}"
  instance_type = "${var.instance_type}"
  ami = "${var.aws_ami}"  
  key_name = "${var.key_name}"
  security_groups = ["${split(",", var.aws_security_group)}"]
  subnet_id = "${var.aws_vpc_subnet}"
  iam_instance_profile = "${var.iam}"
  user_data = "${template_file.userdata_node_provisioner.rendered}"

  tags {
    Name = "${var.instance_prefix}-${var.environment}-${count.index}"
    Index = "${count.index}"
    Service = "hello-world-system"
    Environment = "${var.environment}"
  }

  provisioner "local-exec" {
    command = "sleep 50"
  }
}

resource "template_file" "userdata_node_provisioner" {
  filename = "userdata_node_provision.sh"
  vars {
    instance_prefix = "${var.instance_prefix}"
    environment = "${var.environment}"
    ecs_cluster="${var.instance_prefix}"
  }
}

resource "aws_ecs_service" "hello-world-ecs-service" {
  name = "${var.instance_prefix}"
  cluster = "${aws_ecs_cluster.hello-world.id}"
  task_definition = "${aws_ecs_task_definition.hello-world.arn}"
  desired_count = "${var.instance_count}"
}

resource "aws_ecs_cluster" "hello-world" {
  name = "${var.instance_prefix}"
}

resource "aws_ecs_task_definition" "hello-world" {
  family = "${var.instance_prefix}"
  container_definitions = "${file("task-definitions.json")}"
}