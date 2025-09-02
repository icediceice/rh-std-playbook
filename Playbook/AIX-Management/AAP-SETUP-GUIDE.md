# AAP 2.5 Setup Guide for AIX Management

This guide provides step-by-step instructions for setting up the AIX Management playbooks in Ansible Automation Platform 2.5.

## Prerequisites

- AAP 2.5 environment with web console access
- Administrative access to AAP
- AIX target systems with SSH connectivity
- HMC access for CPU/memory scaling (optional)
- SMTP server for notifications (optional)

## Setup Steps

### 1. Project Creation

1. **Navigate to Projects** in AAP web console
2. **Create New Project**:
   - Name: `AIX Management`
   - Description: `AIX system monitoring and management automation`
   - Source Control Type: `Git`
   - Source Control URL: `[Your repository URL]`
   - Source Control Branch: `main`
   - Update Revision On Launch: `Enabled`

### 2. Execution Environment Setup

1. **Navigate to Execution Environments**
2. **Create New Execution Environment**:
   - Name: `AIX Management EE`
   - Image: Build using provided `execution-environment.yml`
   - Pull: `Always pull container before running`

### 3. Credential Configuration

#### Machine Credentials for AIX Systems

1. **Navigate to Credentials**
2. **Create Machine Credential**:
   - Name: `AIX Root Credential`
   - Credential Type: `Machine`
   - Username: `root` (or appropriate admin user)
   - Password: `[AIX root password]` or SSH Private Key
   - Privilege Escalation Method: `su`

#### Vault Credentials for Sensitive Data

1. **Create Vault Credential**:
   - Name: `AIX Management Vault`
   - Credential Type: `Vault`
   - Vault Password: `[Your vault password]`

2. **Create vault file** with sensitive variables:
```yaml
# vault_secrets.yml (encrypt with ansible-vault)
vault_aix_user: root
vault_aix_password: "your_aix_password"
vault_hmc_host: "10.4.6.170"
vault_hmc_user: "hscroot"
vault_hmc_password: "hmc_password"
vault_smtp_host: "smtp.company.com"
vault_smtp_port: 587
vault_smtp_user: "ansible@company.com"
vault_smtp_pass: "smtp_password"
vault_admin_email: "admin@company.com"
```

### 4. Inventory Setup

1. **Navigate to Inventories**
2. **Create New Inventory**:
   - Name: `AIX Production Inventory`
   - Description: `Production AIX systems`

3. **Add Hosts**:
   - Navigate to Hosts in the inventory
   - Add each AIX system with:
     - Name: `prd-aix-01`
     - Variables:
```yaml
ansible_host: 10.1.1.10
environment: production
hmc_partition_name: "PRD_bgcnsr_backup"
hmc_managed_system: "P780-Plus-MHD-SN0652C9T"
```

4. **Create Groups**:
   - Group Name: `aix`
   - Add all AIX hosts to this group
   - Group Variables:
```yaml
ansible_connection: ssh
ansible_become: true
ansible_become_method: su
ansible_python_interpreter: /usr/bin/python3
```

### 5. Job Template Creation

#### Filesystem Management Template

1. **Navigate to Templates**
2. **Create Job Template**:
   - Name: `AIX Filesystem Management`
   - Job Type: `Run Playbook`
   - Inventory: `AIX Production Inventory`
   - Project: `AIX Management`
   - Playbook: `playbooks/aix_filesystem_management.yml`
   - Credentials: 
     - Machine: `AIX Root Credential`
     - Vault: `AIX Management Vault`
   - Survey: `Enabled`

3. **Import Survey**:
   - Copy content from `surveys/aix_filesystem_management_survey.json`
   - Paste into Survey section

#### CPU Management Template

1. **Create Job Template**:
   - Name: `AIX CPU Management`
   - Job Type: `Run Playbook`
   - Inventory: `AIX Production Inventory`
   - Project: `AIX Management`
   - Playbook: `playbooks/aix_cpu_management.yml`
   - Credentials: 
     - Machine: `AIX Root Credential`
     - Vault: `AIX Management Vault`
   - Survey: `Enabled`

2. **Import Survey**: Use `surveys/aix_cpu_management_survey.json`

#### Memory Management Template

1. **Create Job Template**:
   - Name: `AIX Memory Management`
   - Job Type: `Run Playbook`
   - Inventory: `AIX Production Inventory`
   - Project: `AIX Management`
   - Playbook: `playbooks/aix_memory_management.yml`
   - Credentials: 
     - Machine: `AIX Root Credential`
     - Vault: `AIX Management Vault`
   - Survey: `Enabled`

2. **Import Survey**: Use `surveys/aix_memory_management_survey.json`

#### Print Queue Management Template

1. **Create Job Template**:
   - Name: `AIX Print Queue Management`
   - Job Type: `Run Playbook`
   - Inventory: `AIX Production Inventory`
   - Project: `AIX Management`
   - Playbook: `playbooks/aix_print_queue_management.yml`
   - Credentials: 
     - Machine: `AIX Root Credential`
     - Vault: `AIX Management Vault`
   - Survey: `Enabled`

2. **Import Survey**: Use `surveys/aix_print_queue_management_survey.json`

#### Service Monitoring Template

1. **Create Job Template**:
   - Name: `AIX Service Monitoring`
   - Job Type: `Run Playbook`
   - Inventory: `AIX Production Inventory`
   - Project: `AIX Management`
   - Playbook: `playbooks/aix_service_monitoring.yml`
   - Credentials: 
     - Machine: `AIX Root Credential`
     - Vault: `AIX Management Vault`
   - Survey: `Enabled`

2. **Import Survey**: Use `surveys/aix_service_monitoring_survey.json`

#### Complete Monitoring Template

1. **Create Job Template**:
   - Name: `AIX Complete Monitoring`
   - Job Type: `Run Playbook`
   - Inventory: `AIX Production Inventory`
   - Project: `AIX Management`
   - Playbook: `playbooks/aix_complete_monitoring.yml`
   - Credentials: 
     - Machine: `AIX Root Credential`
     - Vault: `AIX Management Vault`
   - Survey: `Enabled`

2. **Import Survey**: Use `surveys/aix_complete_monitoring_survey.json`

### 6. Workflow Templates (Optional)

Create workflow templates for scheduled monitoring:

1. **Create Workflow Template**:
   - Name: `AIX Daily Monitoring Workflow`
   - Description: `Daily comprehensive AIX system monitoring`

2. **Add Workflow Nodes**:
   - Node 1: `AIX Complete Monitoring`
   - Schedule: Daily at appropriate time

### 7. Scheduling

Set up regular monitoring schedules:

1. **Navigate to Schedules**
2. **Create Schedule**:
   - Name: `AIX Filesystem Daily Check`
   - Job Template: `AIX Filesystem Management`
   - Frequency: `Daily`
   - Time: `02:00 AM`

Repeat for other monitoring tasks as needed.

### 8. Notifications

Configure notifications for job results:

1. **Navigate to Notifications**
2. **Create Notification**:
   - Name: `AIX Management Email Alerts`
   - Type: `Email`
   - Host: `[SMTP server]`
   - Recipients: `[Operations team emails]`

3. **Attach to Job Templates**:
   - Enable notifications for Success, Failure, and Start events

### 9. RBAC Configuration

Set up role-based access control:

1. **Create Team**: `AIX Operations Team`
2. **Add Users** to the team
3. **Grant Permissions**:
   - Execute permissions on AIX job templates
   - Read permissions on inventories and credentials

### 10. Testing

Perform initial testing:

1. **Test Connectivity**:
   - Run a simple job template against one AIX host
   - Verify SSH connectivity and privilege escalation

2. **Test Each Template**:
   - Execute each job template with minimal scope
   - Verify successful execution and logging

3. **Test Surveys**:
   - Launch jobs with surveys
   - Verify all survey options work correctly

## Validation Checklist

- [ ] Project syncs successfully from SCM
- [ ] Execution environment builds without errors
- [ ] Machine credentials work for SSH access
- [ ] Vault credentials decrypt sensitive data
- [ ] Inventory hosts are reachable
- [ ] All job templates execute successfully
- [ ] Surveys collect input correctly
- [ ] Email notifications are received
- [ ] Log files are created on target systems
- [ ] HMC integration works (if applicable)

## Troubleshooting

### Common Issues

1. **SSH Connection Failures**:
   - Verify network connectivity
   - Check SSH key permissions
   - Validate credential configuration

2. **Permission Denied Errors**:
   - Ensure proper privilege escalation
   - Verify sudo/su configuration on targets
   - Check file system permissions

3. **HMC Integration Issues**:
   - Test SSH connectivity to HMC
   - Verify HMC user permissions
   - Check partition and system names

4. **Email Notification Problems**:
   - Test SMTP connectivity
   - Verify email credentials
   - Check firewall rules

### Support

For additional support:
- Review AAP documentation
- Check Ansible logs in `/tmp/ansible-aix.log`
- Contact EIS Command Center team
- Review job output in AAP web console