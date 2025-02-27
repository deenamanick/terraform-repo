# Spin up Jenkin server in EC2 

## datasources.tf
```
# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

```

## main.tf
```
resource "aws_security_group" "ec2sg" {
  name = "EC2-SG"

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "ec2instance" {
  #ami             = "ami-0c101f26f147fa7fd"
  ami             = data.aws_ami.amzlinux.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.ec2sg.name}"]
  #subnet_id       = data.aws_subnet.subnet1.id

  user_data = <<-EOF
    #!/bin/bash
    sudo su -
    yum update -y
    yum install httpd -y
    echo "<html><h1> Welcome to Jeevi Academy </h1></html>" >> /var/www/html/index.html  
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Name = "MyEC2Server"
  }
}



# ###################### Default VPC ######################
# data "aws_vpc" "vpc" {
#   default = true
# }

# data "aws_subnet" "subnet1" {
#   vpc_id            = data.aws_vpc.vpc.id
#   availability_zone = "us-east-1a"
# }

# data "aws_subnet" "subnet2" {
#   vpc_id            = data.aws_vpc.vpc.id
#   availability_zone = "us-east-1b"
# }
```

## provider.tf
```
# CONFIGURATION AND PARAMETERS
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
# Optionally, you can specify the default version of Terraform to work with
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

```
## variable.tf
```
variable "access_key" {
  description = "Access key to AWS console"
  type        = string
}

variable "secret_key" {
  description = "Secret key to AWS console"
  type        = string
  sensitive   = true
}
variable "region" {
  description = "AWS region"
  type        = string
}
```
## terraform.tfvars
```
region     = "us-east-1"
access_key = ""
secret_key = ""

```
###  Install Jenkins on the instance

```

sudo su -
sudo yum -y update
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo amazon-linux-extras enable java-openjdk17
sudo yum install java-17-amazon-corretto-devel
sudo yum upgrade -y
sudo yum install jenkins -y
export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64
source ~/.bash_profile
java -version
sudo systemctl start jenkins
sudo systemctl status jenkins

```





