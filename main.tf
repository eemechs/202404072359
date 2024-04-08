module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "api-challenge-spot"

  create_spot_instance = true
  spot_price           = "0.60"
  spot_type            = "persistent"

  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}