resource "aws_security_group" "ec2sgnew" {
  name = "EC2-SG-NEW"

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

resource "aws_instance" "ec2instance" {
  # ami = "ami-0c101f26f147fa7fd"
  count           = 3 # <-- This will create 3 instances
  ami             = data.aws_ami.amzlinux.id
  instance_type   = var.is_dev ? "t3.micro" : "t2.micro"
  security_groups = ["${aws_security_group.ec2sgnew.name}"]
  #subnet_id       = data.aws_subnet.subnet1.id

  user_data = <<-EOF
#!/bin/bash  
echo "Number of tags: ${length(var.instance_tags)}" > /tmp/tag_count.txt
sudo amazon-linux-extras enable epel -y
sudo yum install epel-release -y
sudo yum -y update
sudo yum install -y git  # Install Git
sudo yum install -y sshpass chpasswd
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum update
sudo yum install java-17-amazon-corretto-devel
sudo yum install jenkins -y
#export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64
#source ~/.bash_profile
java -version
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo yum install -y maven
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
# Create ubuntu user and set password on all nodes
PASSWORD='ubuntu_password'  # Change this to your desired password
sudo useradd -m -s /bin/bash ubuntu
echo "ubuntu:$PASSWORD" | sudo chpasswd
sudo usermod -aG wheel ubuntu
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" |  sudo tee /etc/sudoers.d/90-cloud-init-users-ubuntu


EOF

  #   tags = {             ### {} Interpolation
  #     Name = "Instance-${var.environment}"
  #   }
  # }

  # Use join() to create a comma-separated string of tags
  tags = {
    Name = "EC2-Instance-${count.index + 1}" # Different name for each instance
    Tags = join(", ", var.instance_tags)     # Joins the list into a single string Built-in Functions
  }

  # Use substr() to create a truncated instance name
  volume_tags = {
    TruncatedName = substr("MyLongInstanceName", 0, 10) # Truncates to first 10 characters
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
