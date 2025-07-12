#!/bin/bash

# Security Group Setup Script
# This script helps create and configure security groups for CI/CD infrastructure

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Security Group Configuration Guide"

echo "
=== SECURITY GROUP SETUP GUIDE ===

For Jenkins Server (vprofile-jenkins_SG):
- SSH (22): Your IP address
- HTTP (80): 0.0.0.0/0 (for web access)
- Jenkins (8080): 0.0.0.0/0 (for Jenkins web interface)

For Nexus Server (vprofile-nexus_SG):
- SSH (22): Your IP address
- HTTP (80): 0.0.0.0/0 (for web access)
- Nexus (8081): 0.0.0.0/0 (for Nexus repository)

For SonarQube Server (vprofile-sonar_SG):
- SSH (22): Your IP address
- HTTP (80): 0.0.0.0/0 (for web access)
- SonarQube (9000): 0.0.0.0/0 (for SonarQube web interface)

=== AWS CLI COMMANDS ===

# Create Security Groups
aws ec2 create-security-group --group-name vprofile-jenkins_SG --description "Security group for Jenkins"
aws ec2 create-security-group --group-name vprofile-nexus_SG --description "Security group for Nexus"
aws ec2 create-security-group --group-name vprofile-sonar_SG --description "Security group for SonarQube"

# Add SSH access (replace YOUR_IP with your actual IP)
aws ec2 authorize-security-group-ingress --group-name vprofile-jenkins_SG --protocol tcp --port 22 --cidr YOUR_IP/32
aws ec2 authorize-security-group-ingress --group-name vprofile-nexus_SG --protocol tcp --port 22 --cidr YOUR_IP/32
aws ec2 authorize-security-group-ingress --group-name vprofile-sonar_SG --protocol tcp --port 22 --cidr YOUR_IP/32

# Add web access
aws ec2 authorize-security-group-ingress --group-name vprofile-jenkins_SG --protocol tcp --port 8080 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name vprofile-nexus_SG --protocol tcp --port 8081 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name vprofile-sonar_SG --protocol tcp --port 9000 --cidr 0.0.0.0/0

# Add HTTP access
aws ec2 authorize-security-group-ingress --group-name vprofile-jenkins_SG --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name vprofile-nexus_SG --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name vprofile-sonar_SG --protocol tcp --port 80 --cidr 0.0.0.0/0

=== INSTANCE RECOMMENDATIONS ===

Jenkins Server:
- Instance Type: t3.medium (minimum)
- OS: Ubuntu 22.04 LTS or Amazon Linux 2023
- Storage: 20GB GP3 EBS

Nexus Server:
- Instance Type: t3.medium (minimum)
- OS: Amazon Linux 2023
- Storage: 30GB GP3 EBS

SonarQube Server:
- Instance Type: t3.large (minimum)
- OS: Amazon Linux 2023
- Storage: 40GB GP3 EBS

=== USERDATA SCRIPTS ===

Use the improved scripts in this directory:
- jenkins-setup.sh (for Jenkins)
- nexus-setup.sh (for Nexus)
- sonar-setup.sh (for SonarQube)

=== MONITORING ===

Check service status:
- Jenkins: systemctl status jenkins
- Nexus: systemctl status nexus
- SonarQube: systemctl status sonarqube

Check logs:
- Jenkins: tail -f /var/log/jenkins/jenkins.log
- Nexus: tail -f /opt/nexus/sonatype-work/nexus3/log/nexus.log
- SonarQube: tail -f /opt/sonarqube/logs/sonar.log
" 