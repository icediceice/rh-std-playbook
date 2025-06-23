# Troubleshooting Guide

## Common Issues

### 1. Job Template Fails to Start

**Problem**: Job template won't launch or shows "No inventory selected"

**Solution**:
- Ensure inventory is attached to the job template
- Verify credentials are properly configured
- Check that the survey is enabled

### 2. Package Installation Failures

**Problem**: "No package matching 'package-name' found"

**Solutions**:
- Verify RHEL subscription is active: `subscription-manager status`
- Enable required repositories: `subscription-manager repos --enable=*`
- Refresh package lists using the refresh playbook
- Check package name spelling and availability for your RHEL version

### 3. SSH Connection Issues

**Problem**: "Failed to connect to the host via ssh"

**Solutions**:
- Verify SSH key or password in credentials
- Check firewall rules on target host
- Ensure user has sudo privileges
- Test manual SSH connection first

### 4. Firewall Configuration Errors

**Problem**: "firewalld.service could not be found"

**Solutions**:
- Install firewalld: `yum install firewalld`
- Start service: `systemctl start firewalld`
- Or disable in survey if not needed

### 5. SELinux Denials

**Problem**: Services fail to start due to SELinux

**Solutions**:
- Check audit log: `ausearch -m avc -ts recent`
- Generate policy: `audit2allow -a -M mypolicy`
- Or set to permissive temporarily

### 6. Role-Specific Issues

#### Web Server
- **Apache won't start**: Check for port conflicts
- **SSL errors**: Verify certificate paths
- **PHP not working**: Install PHP packages from optional section

#### Database Server
- **MySQL root password**: Check `/tmp/mysql_root_pass`
- **Connection refused**: Verify bind address
- **Slow queries**: Check slow query log

#### Logging Server
- **Disk full**: Implement log rotation
- **Missing logs**: Check rsyslog configuration
- **Kibana access**: Verify firewall rules and install ELK option

#### General Server
- **Podman issues**: See Container-Specific Issues section

## Container-Specific Issues (Podman)

### Podman Command Not Found
**Problem**: "podman: command not found"

**Solution**:
- Ensure "Container Tools" was selected in survey
- Install manually: `sudo yum install podman podman-compose`

### Podman Permission Denied
**Problem**: "permission denied while trying to connect to the Docker daemon socket"

**Solution**:
- Podman doesn't use a daemon like Docker
- Run as regular user: `podman run` (no sudo needed)
- For system containers: `sudo podman run`

### Container Registry Access
**Problem**: "Error pulling image"

**Solution**:
- Check registry configuration: `/etc/containers/registries.conf`
- Login to registry if needed: `podman login registry.redhat.io`
- Use fully qualified image names

### Rootless Container Issues
**Problem**: Container can't bind to privileged ports

**Solution**:
- Use ports > 1024 for rootless containers
- Or use: `sudo sysctl net.ipv4.ip_unprivileged_port_start=80`
- Or run as root: `sudo podman run`

## Performance Issues

### Slow Playbook Execution
- Enable fact caching in ansible.cfg
- Use `gather_facts: no` where possible
- Limit concurrent connections

### High Memory Usage
- Adjust buffer pool sizes for databases
- Limit Apache MaxClients
- Configure swap space
- Check container resource limits

## Package Management Issues

### Optional Packages Not Installing
**Problem**: Selected optional packages aren't installed

**Solution**:
- Check playbook output for package names
- Verify package availability: `yum search package-name`
- Some packages may have different names in RHEL vs other distros

### Custom Package Format
**Problem**: Custom packages field not working

**Solution**:
- Use comma-separated format: `package1,package2,package3`
- No spaces around commas
- Check for typos in package names

## Getting Help

1. **Check Logs**:
   - AAP: `/var/log/tower/`
   - Target servers: `/var/log/messages`
   - Service logs: `journalctl -u service-name`

2. **Enable Debug Mode**:
   Add to job template extra vars:
   ```yaml
   ansible_verbosity: 4

3. **Validate Variables**:
Check survey responses in job output header

4. **Community Support**:
   - Red Hat Customer Portal
   - Ansible Community Forums
   - GitHub Issues
Emergency Recovery
Rollback Failed Provisioning

Keep system backups before provisioning
Use configuration management for recovery
Document pre-provisioning state

Manual Package Removal
If optional packages cause issues:
bash# List recently installed packages
rpm -qa --last | head -20

# Remove problematic package
sudo yum remove package-name
Reset to Minimal State
bash# Remove all optional packages (careful!)
sudo yum groupremove "Development Tools"
sudo yum remove podman buildah skopeo
Prevention Tips

Test in Development First: Always test in dev environment
Use Minimal Options: Start with essentials only
Document Changes: Keep track of customizations
Regular Backups: Enable backups for important servers
Monitor Resources: Watch CPU, memory, and disk usage

