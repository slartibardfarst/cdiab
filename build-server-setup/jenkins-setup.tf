provider "aws" {
    region = "us-west-2"
}

resource "aws_instance" "example" {
    count = 1
    instance_type = "t2.micro"
    ami = "ami-dc2fcbef"
    security_groups = ["sg-87fe40e3"]
    subnet_id = "subnet-4591171c"
    key_name = "andrews-geo-dev-key-pair"
    tags {
        Name = "aw-terraform-test-3"
    }
    
    connection {
        user = "centos"
        key_file = "/Users/awatkins/.ssh/andrews-geo-dev-key-pair.pem"
    }
    
    provisioner "remote-exec" {
        scripts = [ "provision-scripts/update-system.sh",
                    "provision-scripts/setup-jenkins.sh",
                    "provision-scripts/setup-docker.sh",
                    "provision-scripts/setup-node.sh",
                    "provision-scripts/setup-terraform.sh" ]                  
    }
    
    provisioner "local-exec" {
        command = "echo ${aws_instance.example.private_ip} > jenkins-server-ip.txt"
    }
}    
    
    

