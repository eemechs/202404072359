ami                  = "ami-090006f29ecb2d79a"
create_spot_instance = true
instance_type        = "t2.micro"
monitoring           = true
name                 = "ec2-comment-api"
user_data            = "template/api_server.tpl"


