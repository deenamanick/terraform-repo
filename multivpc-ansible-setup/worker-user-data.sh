#!/bin/bash

# Install Ansible on worker nodes
sudo amazon-linux-extras enable epel -y
sudo yum install epel-release -y
sudo yum install -y ansible sshpass chpasswd

# Create ubuntu user and set password on all nodes
PASSWORD='ubuntu_password'  # Change this to your desired password
sudo useradd -m -s /bin/bash ubuntu
echo "ubuntu:$PASSWORD" | sudo chpasswd
sudo usermod -aG wheel ubuntu

sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "ubuntu ALL=(ALL) NOPASSWD:ALL" |  sudo tee /etc/sudoers.d/90-cloud-init-users-ubuntu


echo "Worker setup complete!"