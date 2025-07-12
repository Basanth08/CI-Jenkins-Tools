# CI/CD Infrastructure Deployment Checklist

## Pre-Deployment Steps

### 1. AWS CLI Configuration
- [ ] AWS CLI installed and configured
- [ ] Correct AWS region set
- [ ] Proper IAM permissions

### 2. Key Pair Setup
- [ ] Create or import key pair
- [ ] Download private key (.pem file)
- [ ] Set correct permissions: `chmod 600 your-key.pem`

### 3. Security Groups Setup
- [ ] Create security groups before launching instances
- [ ] Add your current IP to SSH rules
- [ ] Open required ports (8080, 8081, 9000, 80)

## Instance Launch Order

### 1. Jenkins Server (First)
- [ ] Instance Type: t3.medium (minimum)
- [ ] OS: Ubuntu 22.04 LTS or Amazon Linux 2023
- [ ] Security Group: vprofile-jenkins_SG
- [ ] Userdata: jenkins-setup.sh
- [ ] Storage: 20GB GP3 EBS

### 2. Nexus Server
- [ ] Instance Type: t3.medium (minimum)
- [ ] OS: Amazon Linux 2023
- [ ] Security Group: vprofile-nexus_SG
- [ ] Userdata: nexus-setup.sh
- [ ] Storage: 30GB GP3 EBS

### 3. SonarQube Server
- [ ] Instance Type: t3.large (minimum)
- [ ] OS: Amazon Linux 2023
- [ ] Security Group: vprofile-sonar_SG
- [ ] Userdata: sonar-setup.sh
- [ ] Storage: 40GB GP3 EBS

## Post-Deployment Verification

### 1. SSH Access Test
```bash
# Test SSH connection
ssh -i your-key.pem ubuntu@JENKINS_IP
ssh -i your-key.pem ec2-user@NEXUS_IP
ssh -i your-key.pem ec2-user@SONAR_IP
```

### 2. Service Status Check
```bash
# Jenkins
systemctl status jenkins

# Nexus
systemctl status nexus

# SonarQube
systemctl status sonarqube
```

### 3. Web Access Test
- [ ] Jenkins: http://JENKINS_IP:8080
- [ ] Nexus: http://NEXUS_IP:8081
- [ ] SonarQube: http://SONAR_IP:9000

### 4. Log Verification
```bash
# Check setup logs
tail -f /var/log/jenkins-setup.log
tail -f /var/log/nexus-setup.log
tail -f /var/log/sonarqube-setup.log
```

## Common Issues & Solutions

### SSH Connection Issues
- **Problem**: Permission denied (publickey)
- **Solution**: Check key permissions, username, security group

### Service Not Starting
- **Problem**: Jenkins/Nexus/SonarQube service failed
- **Solution**: Check logs, Java version, disk space

### Port Access Issues
- **Problem**: Can't access web interfaces
- **Solution**: Verify security group rules, firewall settings

## Security Best Practices

### 1. Network Security
- [ ] Use specific IP ranges instead of 0.0.0.0/0 where possible
- [ ] Implement VPC with private subnets for production
- [ ] Use security groups with minimal required access

### 2. Instance Security
- [ ] Regular security updates
- [ ] Strong passwords for admin accounts
- [ ] Regular backups of configuration and data

### 3. Monitoring
- [ ] Set up CloudWatch monitoring
- [ ] Configure log aggregation
- [ ] Set up alerts for service failures

## Backup Strategy

### 1. Configuration Backups
- [ ] Jenkins configuration: `/var/lib/jenkins/`
- [ ] Nexus data: `/opt/nexus/sonatype-work/`
- [ ] SonarQube data: `/opt/sonarqube/data/`

### 2. Automated Backups
- [ ] Set up EBS snapshots
- [ ] Configure S3 backups for critical data
- [ ] Test backup restoration procedures

## Maintenance Tasks

### Weekly
- [ ] Check service status
- [ ] Review logs for errors
- [ ] Update system packages
- [ ] Verify backup completion

### Monthly
- [ ] Review security group rules
- [ ] Update SSL certificates
- [ ] Review and update passwords
- [ ] Performance monitoring review

## Emergency Procedures

### Service Recovery
1. Check service status: `systemctl status SERVICE_NAME`
2. Check logs: `journalctl -u SERVICE_NAME -xe`
3. Restart service: `systemctl restart SERVICE_NAME`
4. If persistent issues, check resource usage and logs

### Instance Recovery
1. Check instance status in AWS Console
2. Verify security group rules
3. Check EBS volume status
4. Consider instance reboot if necessary

## Contact Information
- AWS Support: For infrastructure issues
- Service Documentation: For application-specific issues
- Team Lead: For deployment decisions 