#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Update package list
sudo apt update

# Install Java (OpenJDK 11) and Maven
sudo apt install -y openjdk-11-jdk maven

# Add Jenkins repository key and source
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list again and install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# (Optional) Open Jenkins port 8080 if UFW is enabled
if sudo ufw status | grep -q 'Status: active'; then
  sudo ufw allow 8080/tcp
  sudo ufw reload
fi

# Print Jenkins initial admin password location
echo "Jenkins installed. To get the initial admin password, run:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
