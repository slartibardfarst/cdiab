provider "aws" {
    access_key = "ASIAJOWTZMPFFRJGMWYQ"
    secret_key = "vXj8sHPLYDs7qkgFCVUc93XUDnr7wxcmzK8LAfKX"
    region = "us-west-2"
}

resource "aws_instance" "example" {
    count = 1
    instance_type = "t2.micro"
    ami = "ami-49d0cd79"
    security_groups = ["sg-87fe40e3"]
    subnet_id = "subnet-4591171c"
    key_name = "andrew-geo-dev-key-pair"
    tags {
        Name = "aw-terraform-test"
    }
}
