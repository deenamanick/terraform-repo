module "my_ec2" {
  source            = "./aws-custom-module"
  ami             = "ami-0c101f26f147fa7fd"
  instance_type     = "t2.micro"
  subnet_id         = data.aws_subnet.subnet1.id
  security_group_id = aws_security_group.ec2sgnew.id # Fixed reference
  instance_name     = "MyCustomInstance"
}

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


