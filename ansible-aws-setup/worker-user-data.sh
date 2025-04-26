#!/bin/bash

# Install Ansible on worker nodes
sudo amazon-linux-extras enable epel -y
sudo yum install epel-release -y
sudo yum install -y ansible sshpass chpasswd
sudo yum install docker

# Create ubuntu user and set password on all nodes
PASSWORD='ubuntu_password'  # Change this to your desired password
sudo useradd -m -s /bin/bash ubuntu
echo "ubuntu:$PASSWORD" | sudo chpasswd
sudo usermod -aG wheel ubuntu

sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "ubuntu ALL=(ALL) NOPASSWD:ALL" |  sudo tee /etc/sudoers.d/90-cloud-init-users-ubuntu

#install Kubernetes

sudo yum update
sudo yum -y install docker.io
curl -LO https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
r=https://api.github.com/repos/kubernetes/minikube/releases
curl -LO $(curl -s $r | grep -o 'http.*download/v.*beta.*/minikube-linux-amd64' | head -n1)
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --vm-driver=none	
sudo yum install conntrack
minikube start --vm-driver=none

echo "Worker setup complete!"