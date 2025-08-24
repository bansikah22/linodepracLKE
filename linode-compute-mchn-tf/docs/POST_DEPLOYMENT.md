# Post-Deployment Guide

This guide covers the steps to complete your Linode server setup after Terraform deployment.

## Server Information

- **Public IP**: 162.216.18.5
- **SSH Command**: `ssh root@162.216.18.5`
- **Password**: IronMan@2024!
- **Region**: us-east (Newark, NJ)

## Step 1: Install Web Server (Nginx)

### Prerequisites
Ensure no package manager locks exist.

### Installation Commands

```bash
# SSH into your server
ssh root@162.216.18.5

# Update package lists
apt update

# Install nginx
apt install -y nginx

# Enable nginx to start on boot
systemctl enable nginx

# Start nginx service
systemctl start nginx

# Verify nginx is running
systemctl status nginx
```

### Troubleshooting Package Manager Locks

If you encounter package manager lock errors:

```bash
# Check for stuck processes
ps aux | grep apt

# Kill stuck process (replace 1132 with actual PID)
sudo kill -9 1132

# Remove lock files
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*
sudo rm /var/lib/dpkg/lock-frontend

# Reconfigure dpkg
sudo dpkg --configure -a

# Fix broken packages
sudo apt --fix-broken install

# Continue with nginx installation
apt update && apt install -y nginx
```

## Step 2: Configure Welcome Page

### Create Custom Welcome Page

```bash
# Create the welcome page
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Your Linode Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .header { background: #f0f0f0; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Welcome to Your Linode Server</h1>
            <p>This server was created using Terraform.</p>
            <p><strong>Server Details:</strong></p>
            <ul>
                <li>Hostname: production-web-server</li>
                <li>IP Address: 162.216.18.5</li>
                <li>Region: us-east</li>
                <li>Status: Running</li>
            </ul>
        </div>
        <h2>Next Steps:</h2>
        <ol>
            <li>Configure your applications</li>
            <li>Set up SSL certificates</li>
            <li>Configure your domain</li>
            <li>Set up monitoring and backups</li>
        </ol>
    </div>
</body>
</html>
EOF
```

## Step 3: Test Web Server

### Local Testing

```bash
# Test nginx locally
curl http://localhost

# Check nginx configuration
nginx -t

# Check if port 80 is listening
netstat -tlnp | grep :80
```

### External Access

**Important**: Use HTTP, not HTTPS for initial access.

- **Correct URL**: `http://162.216.18.5`
- **Incorrect URL**: `https://162.216.18.5:80/`

### Browser Access

1. Open your web browser
2. Navigate to: `http://162.216.18.5`
3. You should see the welcome page

## Step 4: Security Hardening

### Change Root Password

```bash
# Change the default password
passwd
```

### Set Up SSH Keys (Recommended)

```bash
# Generate SSH key pair on your local machine
ssh-keygen -t rsa -b 4096

# Copy public key to server
ssh-copy-id root@162.216.18.5
```

### Configure Firewall

```bash
# Check firewall status
ufw status

# Allow SSH from specific IP (optional)
ufw allow from YOUR_IP_ADDRESS to any port 22

# Reload firewall
ufw reload
```

## Step 5: SSL Certificate Setup

### Install Certbot

```bash
# Install Certbot for Let's Encrypt
apt install -y certbot python3-certbot-nginx

# Get SSL certificate (replace with your domain)
certbot --nginx -d yourdomain.com
```

## Step 6: Application Deployment

### Install Additional Software

```bash
# Install Docker
apt install -y docker.io
systemctl enable docker
systemctl start docker

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Install other tools
apt install -y git htop unzip
```

### Deploy Your Application

```bash
# Clone your application
git clone https://github.com/yourusername/yourapp.git

# Set up your application
cd yourapp
npm install  # if Node.js app
```

## Step 7: Monitoring and Maintenance

### Set Up Log Monitoring

```bash
# Check nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# Check system logs
journalctl -u nginx -f
```

### Regular Maintenance

```bash
# Update system packages
apt update && apt upgrade -y

# Check disk usage
df -h

# Check memory usage
free -h

# Check running services
systemctl list-units --type=service --state=running
```

## Troubleshooting

### Common Issues

1. **Website not accessible**: Check firewall rules and nginx status
2. **SSL errors**: Ensure you're using HTTP initially, not HTTPS
3. **Package manager locks**: Follow the troubleshooting steps above
4. **Permission errors**: Check file permissions and ownership

### Useful Commands

```bash
# Check nginx configuration
nginx -t

# Reload nginx configuration
systemctl reload nginx

# Check nginx error logs
tail -f /var/log/nginx/error.log

# Check system resources
htop

# Check network connectivity
ping google.com
```

## Next Steps

1. **Domain Configuration**: Point your domain to 162.216.18.5
2. **SSL Setup**: Install SSL certificate for your domain
3. **Application Deployment**: Deploy your web applications
4. **Monitoring**: Set up monitoring and alerting
5. **Backups**: Configure regular backups
6. **Security**: Implement additional security measures

## Support

- **Linode Support**: https://www.linode.com/support/
- **Nginx Documentation**: https://nginx.org/en/docs/
- **Terraform Documentation**: https://www.terraform.io/docs
