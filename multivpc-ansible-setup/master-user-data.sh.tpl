#!/bin/bash

# Install required packages
sudo amazon-linux-extras enable epel -y
sleep 5
sudo yum install epel-release -y
sleep 5
sudo yum install -y ansible sshpass chpasswd

# sudo apt update
# sudo apt install software-properties-common
# sudo add-apt-repository --yes --update ppa:ansible/ansible
# sudo apt install ansible sshpass chpasswd


# Fetch instance metadata for private IP
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
sudo hostnamectl set-hostname master.ansibledev.com
sudo cp /etc/hosts /etc/hosts.orig
echo "$PRIVATE_IP master.ansibledev.com master" | sudo tee -a /etc/hosts > /dev/null
# echo "10.0.1.46 worker1.ansibledev.com worker1" | sudo tee -a /etc/hosts > /dev/null
# echo "10.0.1.47 worker2.ansibledev.com worker2" | sudo tee -a /etc/hosts > /dev/null
# echo "${element(local.worker_ips, 1)} worker1.ansibledev.com" | sudo tee -a /etc/hosts > /dev/null
# echo "${element(local.worker_ips, 2)} worker2.ansibledev.com" | sudo tee -a /etc/hosts > /dev/null

sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd


# # Add worker nodes to /etc/hosts
# %{ for name, ip in worker_private_ips ~}
# echo "${ip} ${name}.ansibledev.com" | sudo tee -a /etc/hosts
# %{ endfor ~}

# Create ubuntu user and set password on all nodes
PASSWORD='ubuntu_password'  # Change this to your desired password
sudo useradd -m -s /bin/bash ubuntu
echo "ubuntu:$PASSWORD" | sudo chpasswd

sudo usermod -aG wheel ubuntu

# Generate SSH key for ubuntu user
sudo -u ubuntu bash -c 'ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N "" -q <<<y'
sudo -u ubuntu ls -l /home/ubuntu/.ssh/


# Create inventory file
sudo -u ubuntu mkdir -p /home/ubuntu/plays
sudo -u ubuntu tee /home/ubuntu/plays/inventory.ini > /dev/null <<EOF
[workers]
# worker1.ansibledev.com ansible_host=10.0.1.46 ansible_user=ubuntu
# worker2.ansibledev.com ansible_host=10.0.1.47 ansible_user=ubuntu

[dev]
worker1
EOF

sudo -u ubuntu tee /home/ubuntu/plays/ansible.cfg  > /dev/null <<EOF
[defaults]
inventory = ./inventory.ini
remote_user = ubuntu
host_key_checking = False
deprecation_warnings = False
interpreter_python = auto_silent

[privilege_escalation]
become = true
become_method = sudo
become_user = root
become_ack_pass = false
EOF

echo "ubuntu ALL=(ALL) NOPASSWD:ALL" |  sudo tee /etc/sudoers.d/90-cloud-init-users-ubuntu

# WORKER_NODES=("10.0.1.46" "10.0.1.47")  # Replace with your worker IPs
# # Copy SSH key to worker nodes
# for ip in "${WORKER_NODES[@]}"; do
#   sudo -u ubuntu sshpass -p "$PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa.pub ubuntu@$ip
# done

echo "Master setup complete!"