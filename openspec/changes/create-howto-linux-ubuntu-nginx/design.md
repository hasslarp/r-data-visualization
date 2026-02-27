## Context

This design document outlines the technical approach for creating a comprehensive how-to guide for Linux Ubuntu users to set up and use the R data analysis tools in this project, as well as host the generated web files using nginx. The guide will be created as markdown documentation files that can be easily maintained and updated.

## Goals / Non-Goals

**Goals:**
- Create clear, step-by-step installation instructions for R and required packages on Ubuntu
- Document the complete workflow for running each visualization script
- Provide nginx installation and configuration instructions for serving static HTML files
- Document how to access visualizations via a web browser
- Provide troubleshooting guidance for common Ubuntu-specific issues
- Ensure the guide is accessible to users with varying levels of Linux experience
- Make the documentation easy to maintain and update

**Non-Goals:**
- Creating video tutorials or interactive guides
- Supporting other Linux distributions (Debian, Fedora, etc.)
- Modifying the existing R scripts for Ubuntu compatibility
- Providing support for RStudio Server or cloud-based R environments
- Configuring SSL/HTTPS for nginx (basic HTTP only)
- Setting up reverse proxy or load balancing

## Decisions

1. **Documentation Format: Markdown**
   - Rationale: Markdown is universal, easy to version control, and renders well on GitHub/GitLab
   - Alternative considered: HTML (harder to maintain), PDF (harder to edit)

2. **Location: docs/ or HowTo directory in project root**
   - Rationale: Keeps documentation alongside code, easy to discover
   - Alternative considered: Wiki (separated from code), separate website (too complex)

3. **Structure: Separate files for setup, usage, data, and nginx hosting**
   - Rationale: Allows users to find relevant information quickly
   - Alternative considered: Single comprehensive file (harder to navigate)

4. **Package Management: Use apt for system packages, R packages from CRAN**
   - Rationale: Follows Ubuntu best practices, ensures compatibility
   - Alternative considered: Docker containers (more complex setup)

5. **Web Server: nginx**
   - Rationale: Lightweight, high-performance, widely used for static file serving
   - Alternative considered: Apache (more complex configuration), Python http.server (not suitable for production)
   - Configuration: Serve files from output/visualizations/ directory on localhost:80

## Nginx Configuration

### Server Setup
- Install nginx via apt: `sudo apt install nginx`
- Default config location: `/etc/nginx/sites-available/default`
- Serve files from: `/path/to/r-analyze-data/output/visualizations/`
- Access URL: `http://localhost/` or `http://localhost:80/`

### Sample Configuration
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
}
```

### Security Considerations
- Run nginx as non-root user (www-data)
- Use firewall (ufw) to restrict access if needed
- Consider basic authentication for local development

## Risks / Trade-offs

- [Risk] Different Ubuntu versions may have slightly different package names → [Mitigation] Specify minimum Ubuntu version (20.04+) and note version-specific differences
- [Risk] R package dependencies may change over time → [Mitigation] Include version pins where critical, recommend checking CRAN for latest
- [Risk] Users may have different data file locations → [Mitigation] Provide clear instructions for configuring paths
- [Risk] nginx configuration may conflict with existing web servers → [Mitigation] Document how to check for port conflicts and stop other services

## Migration Plan

1. Create documentation directory structure
2. Write the setup guide (linux-ubuntu-setup.md)
3. Write the usage guide (linux-ubuntu-usage.md)
4. Write the data preparation guide (linux-ubuntu-data.md)
5. Write the nginx hosting guide (linux-ubuntu-nginx.md)
6. Add troubleshooting section
7. Update project README to link to the new documentation
8. No rollback needed - this is purely documentation
