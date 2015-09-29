provider "aws" {
    access_key = "ASIAIHCCHWDSLV736OSQ"
    secret_key = "Q2eQUinEGuVWDq1Ekc4kZg+NfwoxllpAQco944HY"
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

#resource "aws_instance" "example" {
#    count = 1
#    instance_type = "t2.micro"
#    ami = "ami-49d0cd79"
#    security_groups = ["sg-46d0e323"]
#    subnet_id = "subnet-c05af3b7"
#    key_name = "AndrewsAwsKeyPair"
#    tags {
#        Name = "aw-terraform-test"
#    }
}

