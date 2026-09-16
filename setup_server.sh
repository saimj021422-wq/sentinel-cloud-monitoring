#!/bin/bash

# Update package repositories
sudo dnf update -y

# Install Apache web server
sudo dnf install httpd -y

# Start and enable Apache service
sudo systemctl start httpd
sudo systemctl enable httpd

# Create a custom landing page
echo "<h1>Cloud Server Automated via Bash Script | Built by Sai</h1>" | sudo tee /var/www/html/index.html

