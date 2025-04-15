resource "aws_security_group" "jenkins_sg" {
  name = "Jenkins-SG"

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

resource "aws_instance" "jenkins_master" {
  ami             = data.aws_ami.amzlinux.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = <<-EOF
#!/bin/bash  
sudo yum -y update
sudo yum install -y git  # Install Git
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo amazon-linux-extras enable java-openjdk17
sudo yum install -y java-17-amazon-corretto-devel
sudo yum install -y jenkins
export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64
source ~/.bash_profile
sudo systemctl start jenkins
sudo systemctl enable jenkins
EOF

  tags = {
    Name = "Jenkins-Master"
  }
}

# resource "aws_instance" "jenkins_slave" {
#   ami             = data.aws_ami.amzlinux.id
#   instance_type   = "t3.micro"
#   security_groups = [aws_security_group.jenkins_sg.name]

#   user_data = <<-EOF
# # #!/bin/bash  
# sudo yum -y update
# sudo amazon-linux-extras enable java-openjdk17
# sudo yum install -y java-17-amazon-corretto-devel
# export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64
# source ~/.bash_profile
# sudo useradd jenkins
# EOF

#   tags = {
#     Name = "Jenkins-Slave"
#   }
# }
