#!/bin/bash

# Install required packages
sudo amazon-linux-extras enable epel -y
sleep 5
sudo yum install epel-release -y
sleep 5
sudo yum install -y ansible sshpass chpasswd

# Fetch instance metadata for private IP
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
sudo hostnamectl set-hostname master.ansibledev.com
sudo cp /etc/hosts /etc/hosts.orig
echo "$PRIVATE_IP master.ansibledev.com" | sudo tee -a /etc/hosts > /dev/null
echo "10.0.1.46 worker1.ansibledev.com" | sudo tee -a /etc/hosts > /dev/null
echo "10.0.1.47 worker2.ansibledev.com" | sudo tee -a /etc/hosts > /dev/null

# # Add worker nodes to /etc/hosts
# %{ for name, ip in worker_private_ips ~}
# echo "${ip} ${name}.ansibledev.com" | sudo tee -a /etc/hosts
# %{ endfor ~}

# Create ubuntu user and set password on all nodes
PASSWORD='ubuntu_password'  # Change this to your desired password
sudo useradd -m -s /bin/bash ubuntu
echo "ubuntu:$PASSWORD" | sudo chpasswd

# Generate SSH key for ubuntu user
sudo -u ubuntu bash -c 'ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N "" -q <<<y'
sudo -u ubuntu ls -l /home/ubuntu/.ssh/


# Create inventory file
sudo -u ubuntu tee /home/ubuntu/plays/inventory.ini > /dev/null <<EOF
[master]
master.ansibledev.com ansible_host=$PRIVATE_IP ansible_user=ubuntu
worker1.ansibledev.com ansible_host=10.0.1.46 ansible_user=ubuntu
worker2.ansibledev.com ansible_host=10.0.1.47 ansible_user=ubuntu


# [workers]
# %{ for name, ip in worker_private_ips ~}
# ${name}.ansibledev.com ansible_host=${ip} ansible_user=ubuntu
# %{ endfor ~}
EOF

WORKER_NODES=("10.0.1.46" "10.0.1.47") 
# Copy SSH key to worker nodes
sleep 10
%{ for name, ip in "${WORKER_NODES[@]}" ~}
sshpass -p "$PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa.pub ubuntu@${ip}
%{ endfor ~}


echo "Master setup complete!"