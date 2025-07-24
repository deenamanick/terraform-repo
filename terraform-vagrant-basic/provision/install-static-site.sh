#!/bin/bash

# Update packages
sudo yum update

# Install Nginx
sudo yum install -y nginx

# Copy static files to web root
sudo cp -r /home/vagrant/static-site/* /var/www/html/

# Set correct permissions
sudo chown -R www-data:www-data /var/www/html

# Enable and restart Nginx
sudo systemctl enable nginx
sudo systemctl restart nginx


