# Nginx Hosting Guide

This guide explains how to install and configure nginx to serve the generated HTML visualization files on Ubuntu.

## Table of Contents

1. [Install nginx](#install-nginx)
2. [nginx Service Commands](#nginx-service-commands)
3. [Configure nginx](#configure-nginx)
4. [Access Visualizations](#access-visualizations)
5. [Test Configuration](#test-configuration)
6. [Optional: Enable gzip Compression](#optional-enable-gzip-compression)
7. [Firewall Configuration](#firewall-configuration)

---

## Install nginx

### Step 1: Update Package List

```bash
sudo apt update
```

### Step 2: Install nginx

```bash
sudo apt install -y nginx
```

### Step 3: Verify Installation

```bash
nginx -v
```

Expected output:
```
nginx version: nginx/1.x.x
```

---

## nginx Service Commands

### Start nginx

```bash
sudo systemctl start nginx
```

### Stop nginx

```bash
sudo systemctl stop nginx
```

### Restart nginx

```bash
sudo systemctl restart nginx
```

### Check nginx Status

```bash
sudo systemctl status nginx
```

### Enable nginx on Boot

```bash
sudo systemctl enable nginx
```

---

## Configure nginx

### Step 1: Create nginx Configuration

Edit the default nginx configuration:

```bash
sudo nano /etc/nginx/sites-available/default
```

### Step 2: Add Configuration

Replace the contents with:

```nginx
server {
    listen 80;
    server_name localhost;

    # Serve the visualization files
    location / {
        root /path/to/r-analyze-data/output/visualizations;
        index index.html;
        autoindex on;
    }

    # Optional: Enable gzip compression
    gzip on;
    gzip_types text/html text/css application/javascript;
    gzip_min_length 1000;
}
```

### Step 3: Update the Path

Replace `/path/to/r-analyze-data` with your actual project path:

```nginx
# Get your project path
pwd  # Copy this path and use it in the config
```

Example:
```nginx
root /home/username/VScodeProjects/r-analyze-data/output/visualizations;
```

### Step 4: Save and Exit

Press `Ctrl+O` to save, then `Ctrl+X` to exit in nano.

---

## Access Visualizations

### After Restarting nginx

1. Generate your visualizations using the R scripts (see [USAGE.md](USAGE.md))
2. Restart nginx: `sudo systemctl restart nginx`
3. Open your browser

### Access URLs

| URL | Description |
|-----|-------------|
| `http://localhost/` | View all visualizations |
| `http://localhost/dashboard_with_filters.html` | Interactive dashboard |
| `http://localhost/time_series_*.html` | Time series charts |

### From Other Devices

To access from another device on your network:

1. Find your local IP:
   ```bash
   hostname -I | awk '{print $1}'
   ```

2. Access via: `http://<your-ip-address>/`

---

## Test Configuration

### Test nginx Configuration Syntax

```bash
sudo nginx -t
```

Expected output:
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### Check nginx Error Logs

```bash
sudo tail -f /var/log/nginx/error.log
```

### Check nginx Access Logs

```bash
sudo tail -f /var/log/nginx/access.log
```

---

## Optional: Enable gzip Compression

gzip compression reduces file sizes for faster loading.

### Edit nginx Configuration

```bash
sudo nano /etc/nginx/nginx.conf
```

### Add or Uncomment gzip Settings

```nginx
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_proxied any;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
gzip_comp_level 6;
```

### Restart nginx

```bash
sudo systemctl restart nginx
```

---

## Firewall Configuration

### Check if UFW is Active

```bash
sudo ufw status
```

### Allow HTTP Traffic

```bash
sudo ufw allow http
```

### Allow HTTPS Traffic (Optional)

```bash
sudo ufw allow https
```

### Allow Specific Port

```bash
sudo ufw allow 80/tcp
```

### Enable Firewall (If Disabled)

```bash
sudo ufw enable
```

---

## Troubleshooting

### Port Already in Use

If port 80 is already in use:

```bash
# Check what's using port 80
sudo lsof -i :80

# Stop the conflicting service
sudo systemctl stop <service-name>

# Or use a different port in nginx config
listen 8080;
```

### Permission Denied Errors

```bash
# Check directory permissions
ls -la /path/to/r-analyze-data/output/visualizations

# Fix permissions if needed
sudo chmod -R 755 /path/to/r-analyze-data/output/visualizations
```

### Browser Cache Issues

Clear your browser cache or use incognito mode.

---

## Next Steps

- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Solve common nginx issues
- [USAGE.md](USAGE.md) - Generate visualizations to serve
