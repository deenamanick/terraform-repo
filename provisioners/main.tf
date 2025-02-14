############ Creating Key pair for EC2 ############
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my-key" {
  key_name   = "testkey"
  public_key = tls_private_key.example.public_key_openssh
}

############ Creating Security Group for EC2 ############
resource "aws_security_group" "web-server-02" {
  name        = "web-server"
  description = "Allow incoming HTTP Connections"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

############ Creating EC2 Instance ############
resource "aws_instance" "web-server-02" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.my-key.key_name          # Use the created key pair
  vpc_security_group_ids = [aws_security_group.web-server-02.id] # Fix: Use id instead of name
  subnet_id              = "subnet-0df8c168cdb951790"
  associate_public_ip_address = true  # ✅ Ensure the instance gets a public IP
  tags = {
    Name = "TerraformInstance"
  }
  timeouts {
    create = "5m" # ✅ Ensure Terraform waits for public IP
  }
  provisioner "local-exec" {
    command = "echo Instance with IP ${self.public_ip} is created >> instance_info.txt"
  }


  provisioner "file" {
    source      = "local_script.sh"
    destination = "/home/ec2-user/remote_script.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.example.private_key_pem #  # Use the generated private key
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      # "sudo yum update -y",
      # "sudo yum install -y nginx",
      # "sudo systemctl start nginx",
      "chmod +x /home/ec2-user/remote_script.sh",
      "bash /home/ec2-user/remote_script.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.example.private_key_pem #  # Use the generated private key
      host        = self.public_ip
    }
  }
  # ✅ Ensure Terraform waits for instance creation
  depends_on = [aws_key_pair.my-key]

}