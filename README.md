# CI-Jenkins-Tools

A collection of tools and utilities for Continuous Integration and Jenkins automation.

## Overview

This repository contains various tools, scripts, and configurations for CI/CD pipelines and Jenkins automation.


### Prerequisites

- Jenkins
- Docker (if applicable)
- Required dependencies (to be specified)

### Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd CI-Jenkins-Tools
```

2. Follow the specific setup instructions for each tool/component.

## Project Structure & My Approach

Here's how I organized and automated this project:

- **Diagrams/**: I created and stored architecture diagrams here, such as the CI/CD pipeline overview.
- **Resources/**: I collected and documented all the scripts, configuration snippets, and integration steps for Slack, Nexus, SonarQube, GitHub, and build jobs in this directory.
- **ansible/**: I wrote Ansible playbooks to automate infrastructure and application setup, making deployments repeatable and reliable.
- **src/**: I structured the source code with clear separation between main application logic and tests.
- **userdata/**: I developed shell scripts and configuration files to automate the setup of Jenkins, Nexus, and SonarQube on EC2 instances.

## Current Scenario

- Agile SDLC is followed.
- Developers make regular code changes.
- These commits need to be built and tested.
- Usually, the Build & Release Team handles this job.
- Alternatively, it may be the developers' responsibility to merge and integrate code.

## Problem: Issues with Current Situation

- In an Agile SDLC, there are frequent code changes.
- Code is not always tested frequently enough.
- This leads to the accumulation of bugs and errors in the codebase.
- Developers need to spend time reworking to fix these bugs and errors.
- The build and release process is often manual.
- There are inter-team dependencies that can slow down progress.

## Solution: Continuous Integration

- Build and test for every commit.
- Automated process for building and testing.
- Notifications for every build status.
- Fix code instantly if bugs or errors are found, rather than waiting.

## Process: Continuous Integration

Continuous Integration (CI) is a development practice where developers integrate code into a shared repository frequently, and each integration is verified by an automated build and test process. This helps to detect problems early, improve software quality, and reduce the time it takes to deliver updates.

## Benefits of CI Pipeline

- Fault isolation: Issues are detected and isolated quickly.
- Short MTTR (Mean Time To Repair): Faster recovery from failures.
- Agile: Supports agile development practices.
- No human intervention: Automated processes reduce manual effort.

## Tools Used

- **Jenkins**: Continuous Integration server
- **Git**: Version control system
- **Maven**: Build tool
- **Checkstyle**: Code analysis tool
- **Slack**: Notification system
- **Nexus**: Artifact/software repository
- **SonarQube**: Code analysis server
- **AWS EC2**: Compute resource

## Objectives and Goals

- Fault isolation
- Short MTTR (Mean Time To Repair)
- Fast turnaround on feature changes
- Less disruptive to development and deployment

## Architecture

The following diagram illustrates the CI/CD pipeline architecture used in this project:

![CI/CD Architecture](./Diagrams/architecture.png)

This architecture covers the flow from code commit to build, test, code analysis, artifact packaging, repository upload, and notifications.

## Flow of Execution (My Steps)

The following orchestrated steps show how I built a robust, automated, and scalable CI/CD pipeline:

1. **I authenticated with AWS**  
   I securely logged in to my AWS account to provision cloud resources.

2. **I generated secure access credentials**  
   I created a login key for safe and automated access to EC2 instances.

3. **I provisioned Security Groups**  
   I defined and configured Security Groups (SG) to control network access for:
   - Jenkins (CI Server)
   - Nexus (Artifact Repository)
   - SonarQube (Code Quality Server)

4. **I launched EC2 instances with automated user data scripts**  
   I spun up dedicated EC2 instances for Jenkins, SonarQube, and Nexus, each automatically configured using my user data scripts for seamless setup.

5. **I completed Jenkins post-installation configuration**  
   I finalized Jenkins setup, installed essential plugins, and prepared it for pipeline orchestration.

6. **I initialized the Nexus repository**  
   I set up Nexus and created three repositories to manage build artifacts efficiently.

7. **I completed SonarQube post-installation**  
   I configured SonarQube for advanced code quality analysis.

8. **I set up Jenkins pipeline jobs**  
   - I created and configured the main Build Job
   - I integrated Slack for real-time build notifications
   - I added Checkstyle for automated code analysis
   - I integrated SonarQube for continuous code quality checks
   - I configured artifact upload jobs for seamless delivery to Nexus

9. **I orchestrated the pipeline**  
   I connected all jobs into a unified Build Pipeline, ensuring smooth, end-to-end automation from code commit to artifact storage.

10. **I enabled automated build triggers**  
    I set up webhooks or polling to trigger builds automatically on code changes, ensuring rapid feedback and continuous integration.

11. **I performed end-to-end testing**  
    I validated the entire pipeline by pushing code changes from IntelliJ and monitoring the automated flow through build, test, analysis, and deployment.

12. **I implemented automated cleanup**  
    I created cleanup routines to remove temporary resources and maintain a cost-effective, clutter-free environment.

This approach delivers a modern, cloud-native CI/CD solution that maximizes automation, security, and developer productivity.

## Deployment Steps Followed

### Phase 1: AWS Infrastructure Setup

#### 1.1 Security Groups Creation
I created three security groups with appropriate rules:

**Jenkins Security Group (vprofile-jenkins-sg):**
- SSH (22): 0.0.0.0/0
- Jenkins (8080): 0.0.0.0/0
- Custom TCP (50000): 0.0.0.0/0

**Nexus Security Group (vprofile-nexus-sg):**
- SSH (22): 0.0.0.0/0
- Nexus (8081): 0.0.0.0/0

**SonarQube Security Group (Sonar-sg-vprofile):**
- SSH (22): 0.0.0.0/0
- SonarQube (9000): 0.0.0.0/0
- HTTP (80): 0.0.0.0/0

#### 1.2 Key Pair Setup
- Created key pair: `ci-vprofile-key`
- Downloaded private key to local machine
- Set proper permissions: `chmod 600 ci-vprofile-key.pem`

### Phase 2: Jenkins Server Deployment

#### 2.1 Instance Launch
- **OS**: Ubuntu 24.04 LTS
- **Instance Type**: t2.micro (upgraded to t3.medium for better performance)
- **Security Group**: vprofile-jenkins-sg
- **Key Pair**: ci-vprofile-key
- **User Data**: Used `userdata/jenkins-setup.sh`

#### 2.2 Jenkins Installation & Configuration
I encountered and resolved several issues:

**Issue 1: Java Version Compatibility**
- Problem: Jenkins failed to start due to Java 11 being too old
- Solution: Updated userdata script to install Java 17
- Commands executed:
  ```bash
  sudo apt-get update
  sudo apt-get install -y openjdk-17-jdk
  sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java
  ```

**Issue 2: Maven Installation**
- Problem: Maven not installed by default
- Solution: Added Maven installation to userdata script
- Commands executed:
  ```bash
  sudo apt-get install -y maven
  mvn --version  # Verified installation
  ```

#### 2.3 Jenkins Verification
- Confirmed service status: `sudo systemctl status jenkins`
- Retrieved initial admin password: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
- Accessed web UI: `http://3.85.168.173:8080`
- Initial admin password: `0d19fc7494f94168a6f7d67deb8b8fe2`

### Phase 3: Nexus Server Deployment

#### 3.1 Instance Launch
- **OS**: CentOS Stream 9
- **Instance Type**: t2.medium
- **Security Group**: vprofile-nexus-sg
- **Key Pair**: ci-vprofile-key
- **User Data**: Used `userdata/nexus-setup.sh`

#### 3.2 Nexus Installation Challenges & Resolution

**Issue 1: Broken Download URL**
- Problem: Official download URL returned 404 error
- Solution: Downloaded Nexus 3.82.0-08 manually from Sonatype website
- Commands executed:
  ```bash
  # Downloaded locally and uploaded via SCP
  scp -i /Users/varagantibasanthkumar/Desktop/ci-vprofile-key.pem nexus-3.82.0-08-linux-x86_64.tar.gz ec2-user@54.237.19.89:/tmp/
  ```

**Issue 2: Directory Structure Problems**
- Problem: Incorrect directory structure after extraction
- Solution: Properly organized Nexus installation
- Commands executed:
  ```bash
  sudo tar xzvf nexus-3.82.0-08-linux-x86_64.tar.gz -C /opt/
  sudo mv /opt/nexus-3.82.0-08 /opt/nexus
  sudo chown -R nexus:nexus /opt/nexus
  sudo mkdir -p /opt/sonatype-work
  sudo chown -R nexus:nexus /opt/sonatype-work
  ```

**Issue 3: Systemd Service Configuration**
- Problem: Service file had incorrect executable paths
- Solution: Updated systemd service file with correct paths
- File edited: `/etc/systemd/system/nexus.service`
- Corrected content:
  ```ini
  [Unit]
  Description=nexus service
  After=network.target

  [Service]
  Type=forking
  LimitNOFILE=65536
  ExecStart=/opt/nexus/nexus-3.82.0-08/bin/nexus start
  ExecStop=/opt/nexus/nexus-3.82.0-08/bin/nexus stop
  User=nexus
  Restart=on-abort

  [Install]
  WantedBy=multi-user.target
  ```

**Issue 4: Nexus User Configuration**
- Problem: Missing run_as_user configuration
- Solution: Created nexus.rc file
- Commands executed:
  ```bash
  echo 'run_as_user="nexus"' | sudo tee /opt/nexus/nexus-3.82.0-08/bin/nexus.rc
  sudo chown nexus:nexus /opt/nexus/nexus-3.82.0-08/bin/nexus.rc
  ```

#### 3.3 Nexus Service Management
- Reloaded systemd: `sudo systemctl daemon-reload`
- Started service: `sudo systemctl start nexus`
- Verified status: `sudo systemctl status nexus`
- Enabled auto-start: `sudo systemctl enable nexus`

#### 3.4 Nexus Verification
- Service status: Active (running)
- Memory usage: 327.4M
- Java process: PID 30969
- Web access: `http://54.237.19.89:8081`
- Admin password location: `/opt/nexus/sonatype-work/nexus3/admin.password`
- **After logging in as admin, I created the required repositories in Nexus:**
  - Maven Central Proxy (`https://repo1.maven.org/maven2/`)
  - Maven Releases
  - Maven Snapshots

### Phase 4: SonarQube Server Deployment

#### 4.1 Instance Launch
- **OS**: Ubuntu 24.04 LTS
- **Instance Type**: t2.large
- **Security Group**: Sonar-sg-vprofile
- **Key Pair**: ci-vprofile-key
- **User Data**: Used `userdata/sonar-setup.sh`

#### 4.2 SonarQube Configuration
- PostgreSQL database setup
- Nginx reverse proxy configuration
- System limits configuration
- Service creation and management

### Phase 5: Jenkins and Slack Integration

#### 5.1 Slack Notification Setup
- I installed the **Slack Notification** plugin in Jenkins via Manage Jenkins > Manage Plugins.
- I created a new **Incoming Webhook** in my Slack workspace and selected the desired channel for notifications.
- I copied the generated **Webhook URL** from Slack.
- In Jenkins, I went to **Manage Jenkins > Configure System**, scrolled to the Slack section, and entered the workspace and webhook details.
- I configured my Jenkins jobs to send notifications to Slack by adding a **Slack Notifications** post-build action, choosing when to notify (e.g., on success, failure, etc.).
- I tested the integration by running a build and verified that notifications appeared in the Slack channel.

This integration ensures my team receives real-time updates on build status directly in Slack, improving collaboration and response time.

### Phase 5: Troubleshooting & Best Practices

#### 5.1 SSH Connection Issues
- **Problem**: Permission denied errors
- **Solutions Applied**:
  - Verified key permissions: `chmod 600 ci-vprofile-key.pem`
  - Confirmed correct usernames (ubuntu for Ubuntu, ec2-user for CentOS/Amazon Linux)
  - Checked security group rules for SSH access

#### 5.2 Service Startup Issues
- **Problem**: Services failing to start
- **Solutions Applied**:
  - Checked system logs: `journalctl -xeu service-name`
  - Verified Java versions and compatibility
  - Confirmed disk space availability
  - Validated file permissions and ownership

#### 5.3 Network Access Issues
- **Problem**: Web interfaces not accessible
- **Solutions Applied**:
  - Verified security group rules
  - Checked firewall configurations (UFW)
  - Confirmed service binding to correct interfaces

### Phase 6: Verification & Testing

#### 6.1 Service Status Verification
```bash
# Jenkins
sudo systemctl status jenkins
curl -I http://localhost:8080

# Nexus
sudo systemctl status nexus
curl -I http://localhost:8081

# SonarQube
sudo systemctl status sonarqube
curl -I http://localhost:9000
```

#### 6.2 Log Monitoring
```bash
# Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Nexus logs
sudo tail -f /opt/sonatype-work/nexus3/log/nexus.log

# SonarQube logs
sudo tail -f /opt/sonarqube/logs/sonar.log
```

### Phase 7: Security & Maintenance

#### 7.1 Security Hardening
- Updated system packages regularly
- Configured UFW firewall rules
- Implemented proper file permissions
- Used dedicated service users (nexus, sonarqube)

#### 7.2 Backup Strategy
- Documented configuration files
- Created userdata scripts for reproducible deployments
- Stored important credentials securely

### Current Status

✅ **Jenkins Server**: Running successfully on `http://3.85.168.173:8080`
✅ **Nexus Server**: Running successfully on `http://54.237.19.89:8081`
⏳ **SonarQube Server**: Ready for deployment

### Next Steps

1. **Complete SonarQube setup** and verify web access
2. **Configure Jenkins plugins** for pipeline automation
3. **Set up Nexus repositories** for artifact management
4. **Integrate all components** into a complete CI/CD pipeline
5. **Implement automated testing** and deployment workflows

## Deployment Guide

### Pre-Deployment Checklist

#### 1. AWS CLI Configuration
- [ ] AWS CLI installed and configured
- [ ] Correct AWS region set
- [ ] Proper IAM permissions

#### 2. Key Pair Setup
- [ ] Create or import key pair
- [ ] Download private key (.pem file)
- [ ] Set correct permissions: `chmod 600 your-key.pem`

#### 3. Security Groups Setup
- [ ] Create security groups before launching instances
- [ ] Add your current IP to SSH rules
- [ ] Open required ports (8080, 8081, 9000, 80)

### Instance Launch Order

#### 1. Jenkins Server (First)
- [ ] Instance Type: t3.medium (minimum)
- [ ] OS: Ubuntu 22.04 LTS or Amazon Linux 2023
- [ ] Security Group: vprofile-jenkins_SG
- [ ] Userdata: `userdata/jenkins-setup.sh`
- [ ] Storage: 20GB GP3 EBS

#### 2. Nexus Server
- [ ] Instance Type: t3.medium (minimum)
- [ ] OS: Amazon Linux 2023
- [ ] Security Group: vprofile-nexus_SG
- [ ] Userdata: `userdata/nexus-setup.sh`
- [ ] Storage: 30GB GP3 EBS

#### 3. SonarQube Server
- [ ] Instance Type: t3.large (minimum)
- [ ] OS: Amazon Linux 2023
- [ ] Security Group: vprofile-sonar_SG
- [ ] Userdata: `userdata/sonar-setup.sh`
- [ ] Storage: 40GB GP3 EBS

### Post-Deployment Verification

#### 1. SSH Access Test
```bash
# Test SSH connection
ssh -i your-key.pem ubuntu@JENKINS_IP
ssh -i your-key.pem ec2-user@NEXUS_IP
ssh -i your-key.pem ec2-user@SONAR_IP
```

#### 2. Service Status Check
```bash
# Jenkins
systemctl status jenkins

# Nexus
systemctl status nexus

# SonarQube
systemctl status sonarqube
```

#### 3. Web Access Test
- [ ] Jenkins: http://JENKINS_IP:8080
- [ ] Nexus: http://NEXUS_IP:8081
- [ ] SonarQube: http://SONAR_IP:9000

#### 4. Log Verification
```bash
# Check setup logs
tail -f /var/log/jenkins-setup.log
tail -f /var/log/nexus-setup.log
tail -f /var/log/sonarqube-setup.log
```

### Common Issues & Solutions

#### SSH Connection Issues
- **Problem**: Permission denied (publickey)
- **Solution**: Check key permissions, username, security group

#### Service Not Starting
- **Problem**: Jenkins/Nexus/SonarQube service failed
- **Solution**: Check logs, Java version, disk space

#### Port Access Issues
- **Problem**: Can't access web interfaces
- **Solution**: Verify security group rules, firewall settings

### Security Best Practices

#### 1. Network Security
- [ ] Use specific IP ranges instead of 0.0.0.0/0 where possible
- [ ] Implement VPC with private subnets for production
- [ ] Use security groups with minimal required access

#### 2. Instance Security
- [ ] Regular security updates
- [ ] Strong passwords for admin accounts
- [ ] Regular backups of configuration and data

#### 3. Monitoring
- [ ] Set up CloudWatch monitoring

