ami                           = "ami-051f8a213df8bc089"
create_spot_instance          = true
create_iam_instance_profile   = true
//iam_role_permissions_boundary = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
instance_type                 = "t3.micro"
monitoring                    = true
name                          = "ec2-comment-api"


