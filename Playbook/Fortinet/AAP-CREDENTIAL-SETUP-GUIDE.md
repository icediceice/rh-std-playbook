# AAP 2.5 Credential Setup Guide for Fortinet Management

## Overview
This guide explains how to set up and configure credentials in Ansible Automation Platform 2.5 for Fortinet device management, following security best practices.

## Credential Types Required

### 1. Machine Credential (Primary)
**Purpose**: Authentication to Fortinet devices
**Credential Type**: `Machine`
**Usage**: Provides username/password for Fortinet device access

#### Setup Steps:
1. Navigate to **Resources > Credentials**
2. Click **Add** to create a new credential
3. Configure the following:
   - **Name**: `Fortinet Device Access`
   - **Credential Type**: `Machine`
   - **Username**: Your Fortinet admin username (e.g., `admin`)
   - **Password**: Your Fortinet admin password
   - **Privilege Escalation Method**: `None` (not needed for network devices)

#### Variable Injection:
When this credential is attached to a job template, AAP will automatically inject:
```yaml
ansible_user: "admin"           # From credential username
ansible_password: "secretpass"  # From credential password
```

### 2. Vault Credential (Optional)
**Purpose**: Decrypt Ansible Vault encrypted variables
**Credential Type**: `Vault`
**Usage**: For encrypted group_vars or host_vars files

#### Setup Steps:
1. Create a new credential with type `Vault`
2. Configure:
   - **Name**: `Fortinet Vault Password`
   - **Credential Type**: `Vault`
   - **Vault Password**: Your vault password

### 3. Custom Credential for SMTP (Optional)
**Purpose**: Email notifications from playbooks
**Credential Type**: `Custom`
**Usage**: Secure SMTP configuration

#### Create Custom Credential Type:
1. Navigate to **Administration > Credential Types**
2. Click **Add** to create custom type:
   - **Name**: `SMTP Configuration`
   - **Input Configuration**:
     ```yaml
     fields:
       - id: smtp_host
         type: string
         label: SMTP Host
       - id: smtp_port
         type: string
         label: SMTP Port
         default: "587"
       - id: smtp_user
         type: string
         label: SMTP Username
       - id: smtp_pass
         type: string
         label: SMTP Password
         secret: true
       - id: admin_email
         type: string
         label: Admin Email
     required:
       - smtp_host
       - admin_email
     ```
   - **Injector Configuration**:
     ```yaml
     extra_vars:
       vault_smtp_host: '{{ smtp_host }}'
       vault_smtp_port: '{{ smtp_port }}'
       vault_smtp_user: '{{ smtp_user }}'
       vault_smtp_pass: '{{ smtp_pass }}'
       vault_admin_email: '{{ admin_email }}'
     ```

#### Create SMTP Credential Instance:
1. Navigate to **Resources > Credentials**
2. Create credential with the custom type:
   - **Name**: `Fortinet SMTP Settings`
   - **Credential Type**: `SMTP Configuration`
   - Fill in your SMTP details

## Inventory Configuration

### Option 1: Static Inventory with AAP Credentials
Use the provided `inventory/fortinet_aap.yml` file which includes credential variable references:

```yaml
fortinet:
  hosts:
    fw-prod-01:
      ansible_host: 192.168.1.10
  vars:
    # These will be injected by AAP machine credential
    ansible_user: "{{ fortinet_username | default('admin') }}"
    ansible_password: "{{ fortinet_password }}"
```

### Option 2: Dynamic Inventory
Use the `inventory/fortinet_dynamic.py` script which supports:
- Environment variable injection from AAP
- Custom credential fields
- Automatic host grouping

### Option 3: Constructed Inventory
Use `inventory/fortinet_dynamic.yml` for advanced inventory composition:
- Group hosts by environment, type, location
- Apply credentials per group
- Dynamic variable assignment

## Job Template Configuration

### 1. Create Job Template
1. Navigate to **Resources > Templates**
2. Click **Add > Add job template**
3. Configure basic settings:
   - **Name**: `Fortinet - Device Connection`
   - **Job Type**: `Run`
   - **Inventory**: Select your Fortinet inventory
   - **Project**: Your Fortinet management project
   - **Playbook**: `playbooks/connect_fortinet.yml`
   - **Execution Environment**: `Fortinet Management EE`

### 2. Attach Credentials
In the **Credentials** section, add:
- **Machine Credential**: `Fortinet Device Access`
- **Vault Credential**: `Fortinet Vault Password` (if using vault)
- **Custom Credential**: `Fortinet SMTP Settings` (if using email notifications)

### 3. Configure Survey
1. Click the **Survey** tab
2. Click **Add** and upload `surveys/connect_fortinet-survey.json`
3. Enable the survey

## Security Best Practices

### 1. Credential Security
- ✅ Use unique passwords for each environment
- ✅ Rotate passwords regularly
- ✅ Use AAP's credential encryption
- ✅ Limit credential access with RBAC
- ❌ Never hardcode passwords in playbooks or variables

### 2. Inventory Security
- ✅ Use dynamic inventory when possible
- ✅ Store sensitive host variables in vault
- ✅ Use group_vars for environment-specific settings
- ✅ Implement proper RBAC for inventory access

### 3. RBAC Configuration
```yaml
# Example RBAC setup
Teams:
  - Fortinet-Admins: Full access to all Fortinet resources
  - Fortinet-Operators: Execute job templates only
  - Fortinet-Viewers: Read-only access

Permissions:
  - Fortinet-Admins: Admin on Fortinet project, inventory, credentials
  - Fortinet-Operators: Execute on job templates
  - Fortinet-Viewers: Read on project and inventory
```

### 4. Audit and Logging
- ✅ Enable job template logging
- ✅ Configure webhook notifications
- ✅ Review job execution logs regularly
- ✅ Monitor credential usage

## Variable Precedence with AAP Credentials

Understanding how AAP injects variables:

1. **Highest Priority**: AAP Machine Credential
   ```yaml
   ansible_user: "admin"      # From credential
   ansible_password: "pass"   # From credential
   ```

2. **High Priority**: Job Template Extra Variables
3. **Medium Priority**: Survey Variables
4. **Lower Priority**: Group Variables
5. **Lowest Priority**: Inventory Variables

## Troubleshooting

### Credential Issues
- **Problem**: Authentication failed
- **Solution**: Verify credential username/password in AAP
- **Check**: Ensure credential is attached to job template

### Variable Injection Issues
- **Problem**: Variables not being injected
- **Solution**: Check credential type and attachment
- **Check**: Review job template credential configuration

### Inventory Issues
- **Problem**: Hosts not found
- **Solution**: Verify inventory sync and host definitions
- **Check**: Test inventory script execution

## Testing Credentials

### 1. Test Connection
Create a simple test job template:
```bash
# Test playbook
- hosts: fortinet
  tasks:
    - debug: msg="Connected to {{ inventory_hostname }} as {{ ansible_user }}"
```

### 2. Verify Variable Injection
```bash
# Check variables in job output
- debug: var=ansible_user
- debug: msg="Password is {{ 'set' if ansible_password is defined else 'not set' }}"
```

### 3. Test Permissions
- Run job as different users
- Verify RBAC restrictions work
- Test credential access controls

## Migration from Manual Credentials

If migrating from hardcoded credentials:

1. **Create AAP credentials** following this guide
2. **Update playbooks** to remove hardcoded values
3. **Test thoroughly** in staging environment
4. **Update job templates** to use new credentials
5. **Remove old credential files** from repository

---

**🔒 Security Note**: This approach ensures credentials are never stored in playbooks, version control, or logs, following AAP 2.5 security best practices.
