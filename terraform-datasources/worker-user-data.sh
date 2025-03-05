#!/bin/bash

# Install Ansible on worker nodes
sudo amazon-linux-extras enable epel -y
sudo yum install epel-release -y
sudo yum install -y ansible sshpass chpasswd
# Create ubuntu user and set password on all nodes
PASSWORD='ubuntu_password'  # Change this to your desired password
sudo useradd -m -s /bin/bash ubuntu
echo "ubuntu:$PASSWORD" | sudo chpasswd

echo "Worker setup complete!"