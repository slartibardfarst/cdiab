provider "aws" {
    region = "us-west-2"
}

resource "aws_iam_role" "ecs-role" {
  name = "${var.instance_prefix}-ecs-role"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance-profile" {
  name = "${var.instance_prefix}-ecs-instance-profile"
  roles = ["${aws_iam_role.ecs-role.name}"]
}


resource "aws_iam_role_policy" "inline-policy" {
  name = "${var.instance_prefix}-ecs-inline_policy"
  role = "${aws_iam_role.ecs-role.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "elasticloadbalancing:*",
        "cloudwatch:*",
        "autoscaling:*",
        "s3:*",
        "sns:*",
        "sqs:*",
        "logs:*",
        "ecs:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
      "logs:*"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.instance_prefix}-group"
  max_size = 5
  min_size = 2
  health_check_grace_period = 3000
  health_check_type = "ELB"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.launch-config.name}"
  vpc_zone_identifier = ["${split(",", var.aws_vpc_subnets)}"]
  #load_balancers = ["${split(",", aws_elb.elb.name)}"]
   tag {
     key = "Name"
     value = "${var.instance_prefix}-${var.environment}-${count.index}"
     propagate_at_launch = true
   }
}

resource "aws_launch_configuration" "launch-config" {
    name = "${var.instance_prefix}-aw-${var.environment}"
    instance_type = "${var.instance_type}"
    image_id = "${var.aws_ami}"
    key_name = "${var.key_name}"
    security_groups = ["${split(",", var.aws_security_group)}"]
    iam_instance_profile = "${aws_iam_instance_profile.instance-profile.name}"
    user_data = "${template_file.userdata_node_provisioner.rendered}"
}

resource "aws_elb" "elb" {
  name = "${var.instance_prefix}-${var.aws_group}-${var.environment}"
  security_groups = ["${split(",", var.aws_security_group)}"]
  subnets = ["${split(",", var.aws_vpc_subnets)}"]
  internal = true
  cross_zone_load_balancing = true

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  
  #health_check {
  #  healthy_threshold = 2
  #  unhealthy_threshold = 2
  #  timeout = 15
  #  target = "HTTP:80/restricted/test"
  #  interval = 30
  #}

  # The LB will point to all nodes
  connection_draining = false
}

resource "aws_route53_record" "rte53" {
  zone_id = "${var.aws_private_dns}"
  name = "${var.instance_prefix}.cdiab"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.elb.dns_name}"]
}

#resource "aws_instance" "ecs-docker-host" {
#    count = "${var.instance_count}"
#    instance_type = "${var.instance_type}"
#    ami = "${var.aws_ami}"
#    security_groups = ["${split(",", var.aws_security_group)}"]
#    subnet_id = "${var.aws_vpc_subnet}"
#    key_name = "${var.key_name}"
#    iam_instance_profile = "${aws_iam_instance_profile.instance-profile.name}"
#    user_data = "${template_file.userdata_node_provisioner.rendered}"
#    tags {
#      Name = "${var.instance_prefix}-${var.environment}-${count.index}"
#      Index = "${count.index}"
#      Service = "hello-world-system"
#      Environment = "${var.environment}"
#    }
#    #provisioner "local-exec" {
#    #  command = "sleep 50"
#    #}
#}

resource "template_file" "userdata_node_provisioner" {
  filename = "userdata_node_provision.sh"
  vars {
    instance_prefix = "${var.instance_prefix}"
    environment = "${var.environment}"
    ecs_cluster="${aws_ecs_cluster.hello-world.id}"
  }
}


resource "aws_ecs_service" "hello-world-ecs-service" {
  name = "${var.instance_prefix}-hello-world-service"
  cluster = "${aws_ecs_cluster.hello-world.id}"
  task_definition = "${aws_ecs_task_definition.hello-world.arn}"
  desired_count = "${var.instance_count}"
  #iam_role = "${aws_iam_role.ecs-role.arn}"
  iam_role = "ecsServiceRole"
    load_balancer {
      elb_name = "${aws_elb.elb.name}"
      container_name = "node-hello"
      container_port = 3000                 #is this really the container instance port?
  }
}

resource "aws_ecs_cluster" "hello-world" {
  name = "${var.instance_prefix}-hello-world-cluster"
}

resource "aws_ecs_task_definition" "hello-world" {
  family = "${var.instance_prefix}"
  container_definitions = "${file("task-definitions.json")}"
}

