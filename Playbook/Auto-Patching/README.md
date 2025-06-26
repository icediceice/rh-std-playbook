---
title: AAP 2.5 OS Patching Playbooks - UPDATED FOR AAP 2.5
---

# AAP 2.5 OS Patching Playbooks - UPDATED FOR AAP 2.5

This repository contains comprehensive Ansible playbooks optimized for **Ansible Automation Platform (AAP) 2.5** for automated operating system patching across Linux (RedHat/Debian families) and Windows environments.

## 🚀 AAP 2.5 New Features & Optimizations

### Enhanced Features for AAP 2.5:
- **Improved Web Console Integration**: Optimized surveys and job templates
- **Enhanced Logging**: Comprehensive logging with AAP job tracking
- **Better Error Handling**: Robust error handling and recovery mechanisms  
- **Performance Optimizations**: Batch processing and improved fact caching
- **Security Enhancements**: Updated collection versions and secure practices
- **Advanced Reporting**: Detailed patching reports and email notifications

### Key Improvements:
- ✅ AAP 2.5 Web Console ready
- ✅ Enhanced survey definitions with validation
- ✅ Improved batch processing (serial patching)
- ✅ Comprehensive pre-flight checks
- ✅ Advanced logging and audit trails
- ✅ Email notification system
- ✅ Maintenance window controls
- ✅ Pre-patch snapshot support (where available)

## Features

- **Cross-Platform Patching**: Supports patching for both Linux (RedHat/Debian) and Windows operating systems
- **AAP 2.5 Web Console Integration**: Fully compatible with AAP 2.5 web interface
- **Conditional Reboot**: Automatically reboots hosts if required by patching and explicitly allowed by configuration
- **Configurable Updates**:
    - For Windows: Specify update categories (e.g., `SecurityUpdates`, `CriticalUpdates`)
    - For Linux: Exclude specific packages from updates
- **Interactive Inventory Management**: A utility playbook (`manage_inventory.yml`) to easily add new hosts to your Ansible inventory file
- **Comprehensive Logging**: Detailed logging with AAP job correlation
- **Email Notifications**: Optional email notifications for job completion
- **Maintenance Windows**: Configurable maintenance time limits
- **Batch Processing**: Serial patching with configurable batch sizes

## Prerequisites

- **Ansible Automation Platform 2.5** or newer
- **Python**: Required on the control node for Ansible
- **Connectivity**:
    - **Linux Hosts**: SSH access configured (e.g., SSH keys, password-based authentication)
    - **Windows Hosts**: WinRM configured and accessible. You may need to install `pywinrm` on your Ansible control node (`pip install pywinrm`)
- **Collections**: All required collections are listed in `requirements.yml`

## Directory Structure

```
Auto-Patching/
├── patching_playbook.yml       # Main AAP 2.5 optimized patching playbook
├── manage_inventory.yml        # Interactive playbook to manage the inventory file  
├── patching_survey.json        # Enhanced AAP 2.5 survey definition
├── inventory                   # Example inventory file
├── ansible.cfg                 # AAP 2.5 optimized configuration
├── requirements.yml            # AAP 2.5 compatible collections
└── roles/
    ├── linux_patching/         # Enhanced Linux patching role
    └── windows_patching/       # Enhanced Windows patching role
```

## AAP 2.5 Setup Instructions

### 1. Import Project in AAP 2.5 Web Console

1. Navigate to **Resources → Projects**
2. Click **Add**
3. Fill in project details:
   - **Name**: OS Patching - AAP 2.5
   - **Organization**: Select your organization
   - **SCM Type**: Git (or Manual for local files)
   - **SCM URL**: Your repository URL
   - **SCM Branch/Tag/Commit**: main

### 2. Create Job Template

1. Navigate to **Resources → Templates**
2. Click **Add → Add job template**
3. Configure:
   - **Name**: AAP 2.5 OS Patching
   - **Job Type**: Run
   - **Inventory**: Select your inventory
   - **Project**: OS Patching - AAP 2.5
   - **Playbook**: patching_playbook.yml
   - **Credentials**: Select appropriate credentials
   - **Variables**: Leave empty (survey will handle this)

### 3. Configure Survey

1. In the job template, click **Survey** tab
2. Click **Add**
3. Import survey questions from `patching_survey.json` or manually add:
   - Target Host Group
   - Allow Automatic Reboot
   - Maintenance Window (Hours)
   - Pre-Patch Snapshot
   - Windows Update Categories
   - Linux Package Exclusions
   - Patching Batch Size
   - Email Notification

### 4. Enhanced Survey Features

The AAP 2.5 survey includes:
- **Validation**: Input validation for all fields
- **Conditional Logic**: Dynamic field visibility based on selections
- **Help Text**: Detailed descriptions for each option
- **Default Values**: Sensible defaults for quick execution

## Usage

### AAP 2.5 Web Console (Recommended)

1. Navigate to **Resources → Templates**
2. Click the rocket icon next to "AAP 2.5 OS Patching"
3. Fill out the survey form with your preferences
4. Click **Launch** to start the patching job
5. Monitor progress in real-time through the job details page

### Command Line (Advanced Users)

```bash
# Basic execution (patches all hosts, no reboot)
ansible-playbook -i inventory patching_playbook.yml

# Target specific OS types and allow reboot
ansible-playbook -i inventory patching_playbook.yml -e "patch_target=linux allow_reboot=yes"

# With email notification
ansible-playbook -i inventory patching_playbook.yml -e "notification_email=admin@company.com"
```

## Playbook Variables (AAP 2.5 Enhanced)

| Variable | Default | Description |
|----------|---------|-------------|
| `patch_target` | `all` | Target group: `all`, `linux`, `windows` |
| `allow_reboot` | `no` | Allow automatic reboot if required |
| `maintenance_window_hours` | `2` | Maximum patching time (1-8 hours) |
| `pre_patch_snapshot` | `no` | Create snapshots before patching |
| `win_update_categories` | `['SecurityUpdates', 'CriticalUpdates']` | Windows update categories |
| `linux_exclude_packages` | `""` | Comma-separated packages to exclude |
| `patching_batch_size` | `25%` | Batch size for serial patching |
| `notification_email` | `""` | Email for completion notifications |

## AAP 2.5 Logging & Monitoring

### Enhanced Logging Features:
- **Job Correlation**: All logs include AAP job ID for tracking
- **Structured Logging**: JSON and YAML formatted logs
- **Audit Trail**: Complete audit trail of all patching activities
- **Error Tracking**: Detailed error logging with context

### Log Locations:
- **Linux**: `/var/log/aap-patching/`
- **Windows**: `C:\AAP-Patching\Logs\`
- **Controller**: `/var/log/ansible-patching.log`

## Troubleshooting

### Common Issues:

1. **Job Template Won't Launch**
   - Verify inventory and credentials are configured
   - Check survey is enabled and properly configured

2. **Package Installation Failures**
   - Verify system subscriptions are active
   - Check network connectivity to update repositories

3. **Reboot Issues**
   - Ensure `allow_reboot` is set to `yes` when needed
   - Verify maintenance window is sufficient

## Security Best Practices

- Use AAP credential store for sensitive information
- Enable surveys to prevent direct variable exposure
- Use encrypted communication channels
- Regular audit of patching activities through logs
- Implement proper RBAC in AAP 2.5

## Performance Tuning

- Adjust `patching_batch_size` based on infrastructure capacity
- Use fact caching to improve performance
- Configure appropriate timeout values
- Monitor resource usage during patching

---

**Note**: This playbook is optimized for AAP 2.5 and may not be fully compatible with older AAP versions. For legacy support, please use the appropriate branch or version.