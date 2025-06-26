# RHEL Server Provisioning Playbook for Ansible Automation Platform 2.5

This repository contains a comprehensive Ansible playbook solution optimized for **Ansible Automation Platform (AAP) 2.5** for provisioning Red Hat Enterprise Linux servers through the enhanced AAP web console.

## 🚀 AAP 2.5 Enhancements

### New Features for AAP 2.5:
- **Enhanced Web Console**: Improved survey handling and job template management
- **Advanced Logging**: Comprehensive audit trails with job correlation
- **Performance Optimizations**: Improved fact caching and connection handling
- **Security Enhancements**: Updated collection versions and credential management
- **Better Error Handling**: Robust error detection and recovery mechanisms
- **Modern UI Integration**: Optimized for AAP 2.5's enhanced user interface

### Key Improvements:
- ✅ AAP 2.5 Web Console optimized
- ✅ Enhanced survey definitions with validation
- ✅ Improved error handling and logging
- ✅ Updated collection requirements
- ✅ Better performance with fact caching
- ✅ Modern ansible.cfg optimizations

## Features

- **AAP 2.5 Native**: Fully compatible with AAP 2.5 web interface and features
- **Environment Support**: Development, Staging, and Production configurations
- **Server Roles**: Web Server, Database Server, Logging Server, General Purpose
- **Dynamic Package Management**: Automatically refreshable package lists with AAP 2.5 integration
- **Enhanced Survey Integration**: User-friendly GUI input with improved validation
- **RHEL Focused**: Optimized specifically for Red Hat Enterprise Linux 8/9
- **Comprehensive Logging**: Detailed logging with AAP job correlation
- **Role-Based Provisioning**: Specialized configurations for different server roles

## AAP 2.5 Quick Start

### 1. Import Project
1. Navigate to **Resources → Projects** in AAP 2.5 Web Console
2. Click **Add** and configure:
   - **Name**: RHEL Server Provisioning - AAP 2.5
   - **SCM Type**: Git
   - **SCM URL**: Your repository URL
   - **Update on Launch**: ✓

### 2. Create Job Template  
1. Navigate to **Resources → Templates**
2. Click **Add → Add job template**
3. Configure template settings:
   - **Name**: Provision RHEL Server - AAP 2.5
   - **Job Type**: Run
   - **Playbook**: playbooks/provision-server.yml
   - **Survey**: Enable and import from surveys/

### 3. Configure Enhanced Survey
The AAP 2.5 survey includes enhanced features:
- **Validation Rules**: Input validation for all fields
- **Conditional Logic**: Dynamic field visibility
- **Help Text**: Detailed descriptions
- **Default Values**: Intelligent defaults

## Requirements

- **Ansible Automation Platform 2.5** or newer
- **Red Hat Enterprise Linux 8 or 9** target servers
- **Valid RHEL subscription** on target systems
- **SSH Access**: Configured with appropriate credentials
- **Sudo Privileges**: For the automation user

## Enhanced Documentation

- [Installation Guide](docs/INSTALLATION.md) - Updated for AAP 2.5
- [Usage Guide](docs/USAGE.md) - AAP 2.5 specific instructions  
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common AAP 2.5 issues and solutions

## AAP 2.5 Specific Optimizations

### Performance Improvements:
- **Smart Fact Gathering**: Optimized fact collection
- **Connection Pool**: Enhanced SSH connection handling
- **Parallel Processing**: Improved task parallelization
- **Memory Management**: Better memory usage patterns

### Security Enhancements:
- **Credential Integration**: Native AAP 2.5 credential store usage
- **Encrypted Variables**: Ansible Vault integration
- **RBAC Support**: Role-based access control ready
- **Audit Logging**: Comprehensive audit trails

### Monitoring & Logging:
- **Job Correlation**: All activities linked to AAP job IDs
- **Structured Logs**: JSON/YAML formatted logging
- **Error Tracking**: Enhanced error reporting
- **Performance Metrics**: Built-in performance monitoring

## Updated Collections for AAP 2.5

The playbooks now use updated collections optimized for AAP 2.5:
- `ansible.posix` >= 1.5.0
- `community.general` >= 8.0.0  
- `community.mysql` >= 3.7.0
- `community.postgresql` >= 3.2.0
- `containers.podman` >= 1.10.0
- `redhat.insights` >= 1.0.0

## Troubleshooting AAP 2.5 Specific Issues

### Common AAP 2.5 Issues:

1. **Survey Not Loading**
   - Verify survey JSON format compatibility
   - Check field validation rules
   - Ensure project sync completed

2. **Collection Import Failures**
   - Update requirements.yml with version constraints
   - Verify automation hub connectivity
   - Check collection dependencies

3. **Performance Issues**
   - Review fact caching configuration
   - Adjust connection settings in ansible.cfg
   - Monitor resource usage in AAP dashboard

For detailed troubleshooting, see the updated [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) guide.

---

**Important**: This version is optimized for AAP 2.5. For older AAP versions, please use the appropriate compatibility branch.