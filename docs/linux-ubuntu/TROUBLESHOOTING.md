# Troubleshooting Guide

This guide covers common issues you may encounter when setting up and running the R visualization scripts on Ubuntu.

## Table of Contents

1. [R Package Installation Errors](#r-package-installation-errors)
2. [Permission Issues](#permission-issues)
3. [Missing System Libraries](#missing-system-libraries)
4. [Data File Path Issues](#data-file-path-issues)
5. [nginx Common Errors](#nginx-common-errors)
6. [nginx Error Logs](#nginx-error-logs)
7. [Browser Access Issues](#browser-access-issues)

---

## R Package Installation Errors

### Error: "Warning in install.packages : package 'xxx' is not available"

**Cause:** Package not available on CRAN or wrong package name.

**Solution:**
```r
# Check package name spelling
# Try with quotes
install.packages("tidyverse")
```

### Error: "Error in loadNamespace(name) : there is no package called 'xxx'"

**Cause:** Package not installed.

**Solution:**
```r
# Install missing package
install.packages("missing_package_name")

# Or install all required packages
packages <- c("tidyverse", "plotly", "htmlwidgets", "lubridate", "scales", "zoo")
install.packages(packages)
```

### Error: "Installation of package 'xxx' had non-zero exit status"

**Cause:** Missing system dependencies.

**Solution:**
```bash
# Install required system libraries
sudo apt install -y \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    libgit2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff5-dev \
    libharfbuzz-dev \
    libfribidi-dev

# Then retry installing R packages
```

### Error: "tar: failed to set default locale"

**Cause:** Missing locale configuration.

**Solution:**
```bash
sudo apt install -y locales
sudo locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
```

---

## Permission Issues

### Error: "cannot open file 'xxx.R': No such file or directory"

**Cause:** Wrong working directory.

**Solution:**
```bash
# Navigate to project directory
cd /path/to/r-analyze-data/visualizations/R

# List files to verify
ls -la
```

### Error: "cannot open file 'data/xxx.csv': No such file or directory"

**Cause:** Data file not in expected location.

**Solution:**
```bash
# Check data directory
ls -la /path/to/r-analyze-data/data/

# Copy data file if needed
cp /source/data.csv /path/to/r-analyze-data/data/
```

### Error: "permission denied" when running R scripts

**Cause:** Insufficient file permissions.

**Solution:**
```bash
# Check permissions
ls -la /path/to/r-analyze-data/

# Fix permissions
chmod -R 755 /path/to/r-analyze-data/
```

### Error: "cannot open file for writing"

**Cause:** Output directory not writable.

**Solution:**
```bash
# Create output directory
mkdir -p /path/to/r-analyze-data/output/visualizations

# Fix permissions
chmod -R 755 /path/to/r-analyze-data/output/
```

---

## Missing System Libraries

### Error: "libcurl.so.4: cannot open shared object file"

**Cause:** libcurl not installed.

**Solution:**
```bash
sudo apt install -y libcurl4-openssl-dev
```

### Error: "libxml2.so.2: cannot open shared object file"

**Cause:** libxml2 not installed.

**Solution:**
```bash
sudo apt install -y libxml2-dev
```

### Error: "libssl.so.1.1: cannot open shared object file"

**Cause:** OpenSSL not installed.

**Solution:**
```bash
sudo apt install -y libssl-dev
```

### Check All Libraries

```bash
# Verify all libraries are available
pkg-config --modversion libcurl && echo "libcurl: OK"
pkg-config --modversion libxml-2.0 && echo "libxml2: OK"
pkg-config --modversion openssl && echo "openssl: OK"
pkg-config --modversion freetype2 && echo "freetype: OK"
```

---

## Data File Path Issues

### Error: "Error in file(file, "rt") : cannot open the connection"

**Cause:** Data file path is incorrect.

**Solution:**
```r
# Check current working directory
getwd()

# Set correct path
setwd("/path/to/r-analyze-data")

# Or use absolute path in load_prescription_data()
data <- load_prescription_data("/path/to/r-analyze-data/data/yourfile.csv")
```

### Error: "Error: 'xxx.csv' does not exist"

**Cause:** File doesn't exist or wrong filename.

**Solution:**
```bash
# List files in data directory
ls -la /path/to/r-analyze-data/data/

# Check exact filename (case-sensitive)
```

### Error: "Error in read.table: 'xxx' not a recognized text input"

**Cause:** Wrong delimiter or encoding.

**Solution:**
```r
# Try different delimiter
data <- read.csv("file.csv", sep = ";", encoding = "latin1")

# Or use the load_prescription_data function from utilities.R
source("utilities.R")
data <- load_prescription_data("your-data.csv")
```

---

## nginx Common Errors

### Error: "nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)"

**Cause:** Port 80 already in use.

**Solution:**
```bash
# Check what's using port 80
sudo lsof -i :80

# Stop the conflicting service
sudo systemctl stop apache2  # If Apache is running
sudo systemctl stop nginx   # If another nginx is running

# Or use a different port
# Edit /etc/nginx/sites-available/default
listen 8080;
```

### Error: "nginx: [emerg] "root" directive is not allowed"

**Cause:** root directive in wrong context.

**Solution:**
```nginx
# Make sure root is in the server block, not location
server {
    listen 80;
    root /path/to/visualizations;  # This is correct
    location / {
        # ...
    }
}
```

### Error: "403 Forbidden"

**Cause:** Directory listing disabled or permission denied.

**Solution:**
```nginx
# Add autoindex to enable directory listing
location / {
    autoindex on;
    index index.html;
}

# Check permissions
sudo chmod -R 755 /path/to/visualizations/
```

### Error: "404 Not Found"

**Cause:** Wrong root path in configuration.

**Solution:**
```bash
# Verify the path exists
ls -la /path/to/r-analyze-data/output/visualizations/

# Update nginx config with correct path
sudo nano /etc/nginx/sites-available/default
```

---

## nginx Error Logs

### View Error Logs

```bash
# Real-time error log
sudo tail -f /var/log/nginx/error.log

# Last 50 lines
sudo tail -n 50 /var/log/nginx/error.log
```

### View Access Logs

```bash
# Real-time access log
sudo tail -f /var/log/nginx/access.log
```

### Common Error Codes

| Code | Meaning | Solution |
|------|---------|----------|
| 400 | Bad Request | Check URL syntax |
| 403 | Forbidden | Check permissions |
| 404 | Not Found | Check file path |
| 500 | Server Error | Check nginx error log |
| 502 | Bad Gateway | Check nginx service |
| 503 | Service Unavailable | Restart nginx |

---

## Browser Access Issues

### Cannot Access http://localhost/

**Solutions:**

1. Check nginx is running:
   ```bash
   sudo systemctl status nginx
   ```

2. Try using 127.0.0.1 instead:
   ```
   http://127.0.0.1/
   ```

3. Check firewall:
   ```bash
   sudo ufw status
   sudo ufw allow 80/tcp
   ```

4. Try different browser or incognito mode.

### Page Not Loading

**Solutions:**

1. Clear browser cache: `Ctrl+Shift+R` (or `Cmd+Shift+R` on Mac)
2. Check browser console for errors
3. Try another browser

### Visualizations Not Displaying

**Solutions:**

1. Check file exists in output directory:
   ```bash
   ls -la /path/to/r-analyze-data/output/visualizations/
   ```

2. Check nginx error log:
   ```bash
   sudo tail -f /var/log/nginx/error.log
   ```

---

## Getting More Help

If you're still experiencing issues:

1. Check the [official R documentation](https://www.r-project.org/)
2. Check the [nginx documentation](https://nginx.org/en/docs/)
3. Search for specific error messages online
4. Check system logs for more details
