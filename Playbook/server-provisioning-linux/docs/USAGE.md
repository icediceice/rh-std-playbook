# Usage Guide

## Quick Start

1. **Launch the Job Template**
   - Navigate to Resources → Templates
   - Click the rocket icon next to "Provision RHEL Server"

2. **Fill the Survey**
   - **Server Hostname**: FQDN of your server
   - **Environment**: Choose dev/staging/production
   - **Server Role**: Select based on intended use
   - **Additional Options**: Configure as needed

3. **Monitor Progress**
   - Watch the job output in real-time
   - Check for any errors or warnings

## Server Roles Explained

### Web Server
- Installs Apache HTTP Server
- Options for PHP or Python support
- SSL/TLS configuration
- Performance optimization tools

### Database Server  
- Choice of MySQL or PostgreSQL
- Automatic backup configuration
- Performance monitoring tools
- Replication ready

### Logging Server
- Central rsyslog configuration
- ELK stack for production/staging
- Log analysis and alerting
- Log retention policies

### General Purpose
- Basic server setup
- Development tools
- Docker/Podman support
- Flexible configuration

## Environment Differences

### Development
- Relaxed security settings
- Additional development tools
- Verbose logging
- No automatic backups

### Staging
- Production-like security
- Limited development tools
- Standard logging
- Weekly backups

### Production
- Strict security enforcement
- Minimal package installation
- Audit logging enabled
- Daily backups with retention

## Customization

### Adding Packages

1. **Via Survey**: Use "Additional Packages" field
2. **Permanently**: Edit package lists and refresh

### Modifying Configurations

Edit role templates in:

roles/<role-name>/templates/

### Environment-Specific Settings

Modify:

group_vars/<environment>.yml

## Maintenance

### Refresh Package Lists

Run the "Refresh Package Lists" job template weekly

### Update Servers

1. Use "Additional Packages" to add specific updates
2. Or create a separate update playbook

### Backup Management

Backups are stored in:
- MySQL: `/var/backups/mysql/`
- PostgreSQL: `/var/backups/postgresql/`
- Configs: `/var/backups/configs/`

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues.