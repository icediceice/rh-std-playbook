
# AAP 2.5 Execution Environment OS Patching


> **Optimized for Red Hat Ansible Automation Platform 2.5 Execution Environments**

This playbook provides a comprehensive, enterprise-grade solution for automated OS patching across Linux (RedHat/Debian families) and Windows environments, specifically designed for Ansible Automation Platform (AAP) 2.5 execution environments. All tasks are tagged, idempotent, and check mode friendly. The playbook and survey are optimized for AAP job templates and execution environments.


## 🚀 Key Features

- **✅ AAP 2.5 Native**: Built specifically for execution environments with AAP inventory and credential integration
- **🔄 Cross-Platform**: Supports RHEL, CentOS, Ubuntu, Debian, and Windows Server platforms
- **🛡️ Secure by Design**: Uses AAP credential management - no hardcoded passwords or keys
- **📊 Comprehensive Reporting**: Detailed execution logs and optional email notifications
- **🔧 Flexible Configuration**: Web-based survey interface for runtime customization
- **♻️ Smart Rebooting**: Intelligent reboot detection and conditional execution
- **🏗️ Modular Architecture**: Role-based design for maintainability and extensibility

## 📋 AAP 2.5 Prerequisites

### Required AAP Components (AAP 2.5 Best Practices)
- **Ansible Automation Platform 2.5+** with execution environments enabled
- **AAP Inventory** with properly configured host groups
- **AAP Credentials** for target systems (SSH for Linux, WinRM for Windows)
- **Execution Environment** with required collections (see below)

### Required Collections in Execution Environment (see requirements.yml)
```yaml
# These collections must be available in your execution environment:
- ansible.posix (>=1.5.0)      # Linux patching operations
- ansible.windows (>=2.0.0)    # Windows updates and management
- community.general (>=8.0.0)  # Email notifications and utilities
- ansible.utils (>=3.0.0)      # Enhanced utility functions
- community.windows (>=2.0.0)  # Additional Windows modules
```

### AAP Inventory Configuration (Recommended Groups)
Ensure your AAP inventory includes these recommended groups:
- `linux` - All Linux systems
- `windows` - All Windows systems  
- `rhel` - Red Hat Enterprise Linux systems
- `ubuntu` - Ubuntu systems
- `windows_servers` - Windows Server systems
- `production`, `development`, `staging` - Environment-based groups


## 🔧 AAP 2.5 Setup & Best Practices

### 1. Import Project (via AAP Web Console)
1. Navigate to **Projects** in AAP web console
2. Click **Add** and configure:
   - **Name**: `OS Patching - AAP 2.5`
   - **Source Control Type**: `Git`
   - **Source Control URL**: `[your-git-repository-url]`
   - **Source Control Branch**: `main`

### 2. Configure Execution Environment (EE)
Ensure your execution environment includes all required collections from `requirements.yml`:
```bash
# Example EE build process
ansible-builder build --tag my-patching-ee --file execution-environment.yml
```

### 3. Create Job Template (with Survey)
1. Navigate to **Templates** → **Add** → **Job Template**
2. Configure the following:
   - **Name**: `AAP 2.5 OS Patching`
   - **Job Type**: `Run`
   - **Inventory**: `[your-aap-inventory]`
   - **Project**: `OS Patching - AAP 2.5`
   - **Execution Environment**: `[your-ee-with-collections]`
   - **Playbook**: `patching_playbook.yml`
   - **Credentials**: Add appropriate Linux/Windows credentials
   - **Enable Privilege Escalation**: ✅
   - **Allow Simultaneous**: Configure based on infrastructure capacity

### 4. Configure Survey (see patching_survey_new.json)
1. In the Job Template, click **Survey** tab → **Add**
2. Copy the survey configuration from `patching_survey.json`
3. The survey includes:
   - Target host patterns (uses AAP inventory groups)
   - Reboot permissions
   - Maintenance windows
   - Update categories
   - Email notifications


## 🎯 Usage (AAP 2.5 Execution Environment)

### Running via AAP Web Console (Recommended)
1. Navigate to **Templates** and select the OS Patching job template
2. Click **Launch** 
3. Complete the survey form:
   - **Target Host Pattern**: Select from your AAP inventory groups
   - **Allow Automatic Reboot**: Choose based on maintenance window
   - **Maintenance Window**: Set appropriate duration (1-8 hours)
   - **Windows Update Categories**: Select update types for Windows hosts
   - **Linux Package Exclusions**: Specify packages to skip (if any)
   - **Email Notification**: Optional completion notification

### Execution Environment Flow (Best Practice)
1. **Pre-Tasks**: Validates AAP environment and displays execution information
2. **Role Execution**: Runs platform-specific patching (linux_patching or windows_patching)
3. **Post-Tasks**: Handles reboots (if required and allowed)
4. **Summary**: Generates comprehensive report and sends notifications


## 📊 Monitoring and Reporting (AAP Console)

### AAP Console Monitoring
- **Real-time Output**: View live execution logs in AAP web console
- **Job Status**: Track progress across all targeted hosts
- **Error Handling**: Automatic failure notifications and retry capabilities

### Log Information Includes
- AAP job ID and execution environment details
- Per-host patching status and results
- Reboot requirements and actions taken
- Update counts and package information
- Execution timing and summary statistics


## 🔍 Variables Reference (Survey & AAP Variables)

### Survey Variables (see patching_survey_new.json)

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `patch_target` | Multiple Choice | AAP inventory group/pattern to target | `all` |
| `allow_reboot` | Boolean | Allow automatic reboots if required | `false` |
| `maintenance_window_hours` | Integer | Maximum operation time (1-8 hours) | `2` |
| `pre_patch_snapshot` | Boolean | Create snapshots before patching | `false` |
| `win_update_categories` | Multi-Select | Windows update categories to install | `SecurityUpdates, CriticalUpdates` |
| `linux_exclude_packages` | Text | Comma-separated packages to exclude | `""` |
| `notification_email` | Text | Email for completion notifications | `""` |

### Built-in AAP Variables (Automatically Provided)

These variables are automatically provided by AAP 2.5:
- `tower_job_id` / `awx_job_id` - Unique job identifier
- `tower_job_template_name` / `awx_job_template_name` - Job template name
- `tower_user_name` / `awx_user_name` - User who launched the job
- `ansible_runner_job_uuid` - Execution environment identifier


## 🛠️ Troubleshooting (AAP 2.5)

### Common Issues and Solutions

#### "Collection not found" errors
**Problem**: Missing collections in execution environment
**Solution**: Ensure your execution environment includes all collections from `requirements.yml`

#### "Permission denied" errors
**Problem**: AAP credentials lack sufficient privileges
**Solution**: Verify credentials have sudo/administrator rights for target systems

#### "Host unreachable" errors
**Problem**: Network connectivity or credential issues
**Solution**: 
- Verify AAP inventory hosts are accessible
- Check SSH/WinRM connectivity
- Validate AAP credentials are correctly configured

#### "Reboot required but not allowed"
**Problem**: Updates require reboot but `allow_reboot` is false
**Solution**: Re-run job with `allow_reboot` set to true during maintenance window

### Debug Mode
Enable verbose logging by adding `-vvv` to the job template's extra variables:
```yaml
ansible_verbosity: 3
```


## 📁 File Structure (Best Practice)

```
Auto-Patching/
├── patching_playbook.yml      # Main AAP 2.5 playbook
├── patching_survey.json       # AAP web console survey configuration
├── requirements.yml           # Execution environment collections
├── ansible.cfg               # Optimized for AAP execution environments
├── README.md                 # This documentation
└── roles/
    ├── linux_patching/       # Linux patching role
    │   └── tasks/main.yml    # Linux update tasks
    └── windows_patching/     # Windows patching role
        └── tasks/main.yml    # Windows update tasks
```


## 🔒 Security Considerations (AAP 2.5)

- **No Hardcoded Credentials**: All authentication uses AAP credential management
- **Privilege Escalation**: Managed through AAP credentials, not playbook
- **Network Security**: Operates within AAP's established security model
- **Audit Trail**: Complete execution logs maintained in AAP console
- **Role-Based Access**: Leverage AAP's RBAC for user permissions


## 📞 Support and Contributing (AAP 2.5)

### Getting Help
1. Check AAP console job output for detailed error messages
2. Review this documentation for common issues
3. Verify execution environment has all required collections
4. Ensure AAP inventory and credentials are properly configured

### Best Practices (AAP 2.5)
- Test in development environment before production deployment
- Use maintenance windows for production patching
- Monitor job execution through AAP console
- Keep execution environment collections updated
- Review patch results before approving system reboots

---


---

**Note**: This playbook is specifically designed for AAP 2.5 execution environments. For standalone Ansible installations, modifications may be required.
