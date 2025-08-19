# AIX Management Playbooks for AAP 2.5

Comprehensive Ansible playbooks for managing IBM AIX systems with automated monitoring, scaling, and self-healing capabilities. Designed for Ansible Automation Platform 2.5 with modern AAP features including credential injection, surveys, and execution environments.

## Overview

This collection modernizes the original AIX shell scripts into standardized Ansible playbooks that integrate seamlessly with AAP 2.5. The playbooks provide:

- **Filesystem Management**: Automated monitoring and expansion of filesystems when thresholds are exceeded
- **CPU Management**: Dynamic CPU scaling via HMC integration based on load average monitoring
- **Memory Management**: Automatic memory allocation through HMC when paging space usage is high
- **Print Queue Management**: Monitoring and automatic restart of print queues and spooler services
- **Service Monitoring**: Zabbix agent and other service monitoring with auto-restart capabilities

## Architecture

### Directory Structure

```
AIX-Management/
├── playbooks/              # Main execution playbooks
├── roles/                  # Ansible roles for each management function
│   ├── filesystem_management/
│   ├── cpu_management/
│   ├── memory_management/
│   ├── print_queue_management/
│   └── service_monitoring/
├── inventory/              # Host inventory files
├── group_vars/             # Variable files organized by environment
├── surveys/                # AAP survey definitions for job templates
├── ansible.cfg            # Ansible configuration optimized for AAP 2.5
├── requirements.yml        # Collection dependencies
└── execution-environment.yml  # EE definition for AAP

```

### AAP 2.5 Integration Features

- **Credential Injection**: Automatic population of credentials via AAP machine credentials
- **Survey Integration**: Interactive job templates with validation and defaults
- **Execution Environment**: Custom EE with all required dependencies
- **Change Tracking**: Built-in change reason and ticket tracking
- **Email Notifications**: Integrated SMTP notifications with credential injection
- **HMC Integration**: Secure SSH-based hardware management console operations

## Quick Start

### 1. Prerequisites

- AAP 2.5 environment
- AIX target systems with SSH access
- HMC access for CPU/memory scaling (optional)
- SMTP server for notifications (optional)

### 2. Setup in AAP

1. **Import the project** into AAP from your SCM
2. **Create machine credentials** for AIX systems:
   - Username: root (or appropriate admin user)
   - Password/SSH key as appropriate
3. **Create vault credentials** for sensitive data:
   - HMC credentials
   - SMTP credentials
   - Admin email addresses
4. **Create inventories** and populate with AIX hosts
5. **Create job templates** using the provided surveys

### 3. Job Templates

Create the following job templates in AAP:

| Template Name | Playbook | Survey | Description |
|---------------|----------|---------|-------------|
| AIX Filesystem Management | `playbooks/aix_filesystem_management.yml` | `surveys/aix_filesystem_management_survey.json` | Monitor and expand filesystems |
| AIX CPU Management | `playbooks/aix_cpu_management.yml` | `surveys/aix_cpu_management_survey.json` | Monitor and scale CPU resources |
| AIX Memory Management | `playbooks/aix_memory_management.yml` | `surveys/aix_memory_management_survey.json` | Monitor and scale memory |
| AIX Print Queue Management | `playbooks/aix_print_queue_management.yml` | `surveys/aix_print_queue_management_survey.json` | Monitor and restart print services |
| AIX Service Monitoring | `playbooks/aix_service_monitoring.yml` | `surveys/aix_service_monitoring_survey.json` | Monitor and restart services |
| AIX Complete Monitoring | `playbooks/aix_complete_monitoring.yml` | `surveys/aix_complete_monitoring_survey.json` | Comprehensive system monitoring |

## Configuration

### Inventory Setup

Update `inventory/aix_hosts.yml` with your AIX systems:

```yaml
production:
  hosts:
    prd-aix-01:
      ansible_host: 10.1.1.10
      hmc_partition_name: "PRD_bgcnsr_backup"
      hmc_managed_system: "P780-Plus-MHD-SN0652C9T"
```

### Credential Configuration

Store sensitive information in AAP vault credentials:

```yaml
# Vault variables to create
vault_aix_user: root
vault_aix_password: "your_password"
vault_hmc_host: "10.4.6.170"
vault_hmc_user: "hscroot"
vault_smtp_host: "smtp.company.com"
vault_smtp_user: "ansible@company.com"
vault_smtp_pass: "smtp_password"
vault_admin_email: "admin@company.com"
```

### Threshold Customization

Modify thresholds in `group_vars/all/main.yml` or override via surveys:

```yaml
filesystem_threshold_default: 85    # Filesystem usage percentage
memory_threshold_default: 10       # Paging space usage percentage
cpu_load_threshold_default: 5      # Load average threshold
```

## Role Descriptions

### filesystem_management
- Monitors filesystem usage based on configurable thresholds
- Automatically expands filesystems by 2% when thresholds are exceeded
- Sends email notifications on expansion or failure
- Logs all operations with timestamps and system information

### cpu_management
- Monitors CPU load average continuously
- Integrates with HMC to add virtual CPUs when load exceeds thresholds
- Supports configurable load thresholds and CPU increment counts
- Provides before/after CPU configuration reporting

### memory_management
- Monitors paging space usage as memory pressure indicator
- Automatically adds memory via HMC when paging usage is high
- Configurable memory increment sizes (default 512MB)
- Validates memory addition success

### print_queue_management
- Monitors print spooler service group status
- Checks individual print queue status (DOWN/READY)
- Automatically restarts failed spooler services and queues
- Supports multiple print queue monitoring

### service_monitoring
- Monitors Zabbix agent and other critical services
- Detects high load conditions and restarts services accordingly
- Automatically creates restart scripts if missing
- Extensible framework for additional service monitoring

## Email Notifications

All roles include comprehensive email notifications:

- **Success notifications**: Sent when automated actions complete successfully
- **Failure alerts**: Sent when automated remediation fails
- **Status reports**: Include before/after system state information
- **Change tracking**: Include AAP job information and change reasons

## Security Features

- **Credential injection**: No hardcoded passwords in playbooks
- **Vault integration**: Sensitive data stored in AAP vault credentials
- **SSH key authentication**: Support for key-based authentication
- **Audit trails**: Complete logging of all automated actions
- **Change tracking**: Integration with change management processes

## Monitoring and Alerting

The playbooks provide multiple monitoring mechanisms:

- **Real-time thresholds**: Immediate response to threshold breaches
- **Comprehensive logging**: All actions logged to `/bigc/log/`
- **Email notifications**: Automatic alerts to operations teams
- **AAP integration**: Full visibility in AAP job history and logging

## Troubleshooting

### Common Issues

1. **SSH Connection Failures**: Verify SSH keys and network connectivity
2. **HMC Integration Issues**: Check HMC credentials and network access
3. **Email Notification Problems**: Verify SMTP credentials and settings
4. **Permission Errors**: Ensure root/admin access on target systems

### Debug Mode

Enable debug logging by setting `enable_debug: true` in surveys or variables.

### Log Locations

- Ansible logs: `/tmp/ansible-aix.log`
- Application logs: `/bigc/log/` (on target systems)
- AAP job logs: Available in AAP web interface

## Migration from Original Scripts

This playbook collection replaces the original shell scripts:

| Original Script | New Playbook/Role |
|----------------|-------------------|
| `checkspace.ksh.sith` | `filesystem_management` role |
| `chk_load_soul.sh` | `cpu_management` role |
| `local_auto-check_lsps.ksh` | `memory_management` role |
| `auto_enable_queue_rev1.0.ksh` | `print_queue_management` role |
| `script_auto_check-zabbix_agent_restart.sh` | `service_monitoring` role |

## Contributing

When modifying these playbooks:

1. Test in development environment first
2. Update documentation for any new features
3. Follow AAP best practices for credential management
4. Ensure all changes are backwards compatible
5. Update surveys when adding new variables

## License

MIT License - See LICENSE file for details

## Support

For issues and support:
- EIS Command Center - Unix/Linux Team
- Email: command_center_alert@bigc.co.th