#!/bin/bash
set -e

# Log all output for troubleshooting
exec > >(tee /var/log/jenkins-userdata.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update package list
apt-get update -y

# Install Java 11
apt-get install -y openjdk-11-jdk

# Add Jenkins repository key and source
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list again
apt-get update -y

# Install Jenkins
apt-get install -y jenkins

# Start and enable Jenkins service
systemctl enable jenkins
systemctl start jenkins

# Open port 8080 if UFW is enabled
if command -v ufw >/dev/null && ufw status | grep -q 'Status: active'; then
  ufw allow 8080/tcp
  ufw reload
fi

# Print initial admin password location
echo "Jenkins installed. To get the initial admin password, run:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
