# #!/bin/bash
# cp /etc/sysctl.conf /root/sysctl.conf_backup
# cat <<EOT> /etc/sysctl.conf
# vm.max_map_count=262144
# fs.file-max=65536
# ulimit -n 65536
# ulimit -u 4096
# EOT
# cp /etc/security/limits.conf /root/sec_limit.conf_backup
# cat <<EOT> /etc/security/limits.conf
# sonarqube   -   nofile   65536
# sonarqube   -   nproc    409
# EOT

# sudo apt-get update -y
# sudo apt-get install openjdk-11-jdk -y
# sudo update-alternatives --config java

# java -version

# sudo apt update
# wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
# sudo apt install postgresql postgresql-contrib -y
# #sudo -u postgres psql -c "SELECT version();"
# sudo systemctl enable postgresql.service
# sudo systemctl start  postgresql.service
# sudo echo "postgres:admin123" | chpasswd
# runuser -l postgres -c "createuser sonar"
# sudo -i -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
# sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
# sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
# systemctl restart  postgresql
# #systemctl status -l   postgresql
# netstat -tulpena | grep postgres
# sudo mkdir -p /sonarqube/
# cd /sonarqube/
# sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.0.34182.zip
# sudo apt-get install zip -y
# sudo unzip -o sonarqube-8.3.0.34182.zip -d /opt/
# sudo mv /opt/sonarqube-8.3.0.34182/ /opt/sonarqube
# sudo groupadd sonar
# sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
# sudo chown sonar:sonar /opt/sonarqube/ -R
# cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup
# cat <<EOT> /opt/sonarqube/conf/sonar.properties
# sonar.jdbc.username=sonar
# sonar.jdbc.password=admin123
# sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
# sonar.web.host=0.0.0.0
# sonar.web.port=9000
# sonar.web.javaAdditionalOpts=-server
# sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
# sonar.log.level=INFO
# sonar.path.logs=logs
# EOT

# cat <<EOT> /etc/systemd/system/sonarqube.service
# [Unit]
# Description=SonarQube service
# After=syslog.target network.target

# [Service]
# Type=forking

# ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
# ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

# User=sonar
# Group=sonar
# Restart=always

# LimitNOFILE=65536
# LimitNPROC=4096


# [Install]
# WantedBy=multi-user.target
# EOT

# systemctl daemon-reload
# systemctl enable sonarqube.service
# #systemctl start sonarqube.service
# #systemctl status -l sonarqube.service
# apt-get install nginx -y
# rm -rf /etc/nginx/sites-enabled/default
# rm -rf /etc/nginx/sites-available/default
# cat <<EOT> /etc/nginx/sites-available/sonarqube
# server{
#     listen      80;
#     server_name sonarqube.groophy.in;

#     access_log  /var/log/nginx/sonar.access.log;
#     error_log   /var/log/nginx/sonar.error.log;

#     proxy_buffers 16 64k;
#     proxy_buffer_size 128k;

#     location / {
#         proxy_pass  http://127.0.0.1:9000;
#         proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
#         proxy_redirect off;
              
#         proxy_set_header    Host            \$host;
#         proxy_set_header    X-Real-IP       \$remote_addr;
#         proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header    X-Forwarded-Proto http;
#     }
# }
# EOT
# ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/sonarqube
# systemctl enable nginx.service
# #systemctl restart nginx.service
# sudo ufw allow 80,9000,9001/tcp

# echo "System reboot in 30 sec"
# sleep 30
# reboot
#!/bin/bash

# Exit on any error
set -e

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a /var/log/sonarqube-setup.log
}

log "Starting SonarQube installation..."

# Update system packages
log "Updating system packages..."
yum update -y

# Install required packages
log "Installing required packages..."
yum install -y java-11-openjdk java-11-openjdk-devel wget unzip

# Verify Java installation
if ! java -version 2>&1 | grep -q "11"; then
    log "ERROR: Java 11 not properly installed"
    exit 1
fi
log "Java 11 verified successfully"

# Configure system limits
log "Configuring system limits..."
cp /etc/sysctl.conf /root/sysctl.conf_backup
cat >> /etc/sysctl.conf << 'EOT'
vm.max_map_count=262144
fs.file-max=65536
EOT

# Apply sysctl changes
sysctl -p

# Configure security limits
log "Configuring security limits..."
cp /etc/security/limits.conf /root/sec_limit.conf_backup
cat >> /etc/security/limits.conf << 'EOT'
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOT

# Install PostgreSQL
log "Installing PostgreSQL..."
yum install -y postgresql postgresql-server postgresql-contrib

# Initialize PostgreSQL database
log "Initializing PostgreSQL database..."
postgresql-setup initdb
systemctl enable postgresql
systemctl start postgresql

# Configure PostgreSQL
log "Configuring PostgreSQL..."
sudo -u postgres psql -c "CREATE USER sonar WITH PASSWORD 'admin123';"
sudo -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON SCHEMA public TO sonar;"

# Restart PostgreSQL to apply changes
systemctl restart postgresql

# Verify PostgreSQL is running
if ! systemctl is-active --quiet postgresql; then
    log "ERROR: PostgreSQL failed to start"
    exit 1
fi
log "PostgreSQL configured and running"

# Download and install SonarQube
log "Downloading SonarQube..."
cd /tmp
SONAR_VERSION="8.3.0.34182"
SONAR_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip"

# Retry download with timeout
for i in {1..3}; do
    if wget --timeout=60 --tries=3 "$SONAR_URL" -O sonarqube.zip; then
        log "SonarQube downloaded successfully"
        break
    else
        log "Download attempt $i failed, retrying..."
        sleep 10
    fi
done

if [ ! -f sonarqube.zip ]; then
    log "ERROR: Failed to download SonarQube after 3 attempts"
    exit 1
fi

# Extract SonarQube
log "Extracting SonarQube..."
unzip -o sonarqube.zip -d /opt/
mv "/opt/sonarqube-${SONAR_VERSION}" /opt/sonarqube

# Create sonar user and group
log "Creating sonar user..."
groupadd -f sonar
useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar -r sonar

# Set ownership
log "Setting ownership..."
chown -R sonar:sonar /opt/sonarqube/

# Configure SonarQube
log "Configuring SonarQube..."
cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup

cat > /opt/sonarqube/conf/sonar.properties << 'EOT'
sonar.jdbc.username=sonar
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=logs
EOT

# Create systemd service
log "Creating systemd service..."
cat > /etc/systemd/system/sonarqube.service << 'EOT'
[Unit]
Description=SonarQube service
After=syslog.target network.target postgresql.service

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOT

# Start SonarQube service
log "Starting SonarQube service..."
systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube

# Wait for SonarQube to start
log "Waiting for SonarQube to start..."
sleep 60

# Check if service is running
if systemctl is-active --quiet sonarqube; then
    log "SonarQube service started successfully"
else
    log "ERROR: SonarQube service failed to start"
    systemctl status sonarqube
    exit 1
fi

# Install and configure Nginx (optional)
log "Installing Nginx..."
yum install -y nginx

# Create Nginx configuration
log "Configuring Nginx..."
cat > /etc/nginx/conf.d/sonarqube.conf << 'EOT'
server {
    listen 80;
    server_name _;

    access_log /var/log/nginx/sonar.access.log;
    error_log /var/log/nginx/sonar.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
              
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto http;
    }
}
EOT

# Remove default nginx configuration
rm -f /etc/nginx/conf.d/default.conf

# Start Nginx
log "Starting Nginx..."
systemctl enable nginx
systemctl start nginx

# Configure firewall (if using firewalld)
if command -v firewall-cmd &> /dev/null; then
    log "Configuring firewall..."
    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-port=9000/tcp
    firewall-cmd --reload
fi

# Clean up
log "Cleaning up temporary files..."
rm -f /tmp/sonarqube.zip

# Get the URL where SonarQube is running
log "SonarQube is available at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9000"
log "Default credentials: admin/admin"

log "SonarQube installation completed successfully!"