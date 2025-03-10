# Create Security Group
resource "aws_security_group" "ec2sgnew" {
  name   = "EC2-SG-NEW"
  vpc_id = data.aws_vpc.vpc.id # Ensure the VPC is referenced

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fetch Default VPC
data "aws_vpc" "vpc" {
  default = true
}

# Fetch Default Subnet in us-east-1a
data "aws_subnet" "subnet1" {
  vpc_id            = data.aws_vpc.vpc.id
  availability_zone = "us-east-1a"
}

# EC2 Instance Module
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  name                        = "single-instance"
  instance_type               = "t2.micro"
  # monitoring                  = true
  subnet_id                   = data.aws_subnet.subnet1.id
  create_eip                  = true
  associate_public_ip_address = true # Ensure the instance gets a public IP

  vpc_security_group_ids = [aws_security_group.ec2sgnew.id] # Fixed reference

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
