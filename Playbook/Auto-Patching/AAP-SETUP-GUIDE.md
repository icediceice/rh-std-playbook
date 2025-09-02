# AAP 2.5 OS Patching Project Configuration Guide

## Project Setup in AAP Console

### 1. Execution Environment Setup

First, build and register the execution environment:

```bash
# Build the execution environment
ansible-builder build --tag aap-os-patching:latest --file execution-environment.yml

# Push to your container registry (if using external registry)
podman push aap-os-patching:latest your-registry.com/aap-os-patching:latest
```

### 2. AAP Console Configuration

#### Step 1: Create Execution Environment
- Navigate to **Administration** → **Execution Environments**
- Click **Add**
- Configuration:
  - **Name**: `AAP OS Patching EE`
  - **Image**: `aap-os-patching:latest` (or your registry path)
  - **Description**: `Execution environment for OS patching with all required collections`

#### Step 2: Create Project
- Navigate to **Resources** → **Projects**
- Click **Add**
- Configuration:
  - **Name**: `AAP 2.5 OS Patching`
  - **Source Control Type**: `Git`
  - **Source Control URL**: `[your-git-repo-url]`
  - **Source Control Branch/Tag/Commit**: `main`
  - **Update Revision on Launch**: ✅
  - **Clean**: ✅

#### Step 3: Create Credentials
Create appropriate credentials for your target systems:

**Linux Credentials:**
- **Name**: `Linux SSH Credentials`
- **Type**: `Machine`
- **Username**: `[service-account]`
- **SSH Private Key**: `[your-ssh-key]`
- **Privilege Escalation Method**: `sudo`

**Windows Credentials:**
- **Name**: `Windows WinRM Credentials`
- **Type**: `Machine`
- **Username**: `[domain\\service-account]`
- **Password**: `[service-account-password]`

#### Step 4: Configure Inventory
Ensure your inventory has appropriate groups:
- `linux` - All Linux systems
- `windows` - All Windows systems
- `rhel` - Red Hat Enterprise Linux
- `ubuntu` - Ubuntu systems
- `windows_servers` - Windows Server systems
- Environment groups: `production`, `development`, `staging`

#### Step 5: Create Job Template
- Navigate to **Resources** → **Templates**
- Click **Add** → **Job Template**
- Configuration:
  - **Name**: `AAP 2.5 OS Patching`
  - **Job Type**: `Run`
  - **Inventory**: `[your-inventory]`
  - **Project**: `AAP 2.5 OS Patching`
  - **Execution Environment**: `AAP OS Patching EE`
  - **Playbook**: `patching_playbook.yml`
  - **Credentials**: Add Linux and Windows credentials
  - **Variables**: (Optional YAML variables)
  - **Options**:
    - ✅ **Enable Privilege Escalation**
    - ✅ **Enable Concurrent Jobs** (if infrastructure supports it)
    - ✅ **Enable Fact Storage**

#### Step 6: Configure Survey
- In the Job Template, click **Survey** tab
- Click **Add**
- Copy the survey configuration from `patching_survey.json`
- Customize choices based on your inventory groups

### 3. Execution Recommendations

#### Pre-Execution Checklist
- [ ] Execution environment is built and available
- [ ] AAP inventory contains target hosts
- [ ] Credentials have appropriate privileges
- [ ] Target systems are accessible from AAP
- [ ] Maintenance windows are scheduled
- [ ] Backup/snapshot systems are ready (if using)

#### During Execution
- Monitor job progress in AAP console
- Watch for failed hosts in the job output
- Check execution environment resource usage
- Monitor system resources on target hosts

#### Post-Execution
- Review job results and statistics
- Check for systems requiring reboot
- Validate applied updates on sample systems
- Review email notifications (if configured)
- Update documentation with any issues found

### 4. Troubleshooting

#### Common AAP Configuration Issues

**Execution Environment Issues:**
- Verify EE has all required collections
- Check container registry connectivity
- Ensure EE resource limits are adequate

**Credential Issues:**
- Test SSH/WinRM connectivity manually
- Verify privilege escalation permissions
- Check credential vault passwords

**Inventory Issues:**
- Ensure hosts are properly grouped
- Verify host variable assignments
- Check dynamic inventory sources

#### Performance Optimization

**For Large Environments:**
```yaml
# Add to job template extra variables
ansible_forks: 10
ansible_timeout: 300
ansible_gather_timeout: 30
```

**For Network-Constrained Environments:**
```yaml
# Add to job template extra variables
ansible_ssh_retries: 5
ansible_winrm_read_timeout_sec: 60
ansible_winrm_operation_timeout_sec: 300
```

### 5. Security Best Practices

- Use dedicated service accounts with minimal privileges
- Rotate credentials regularly
- Enable AAP audit logging
- Use encrypted credential storage
- Limit job template access via RBAC
- Monitor job execution logs
- Use network segmentation for patching operations

### 6. Maintenance and Updates

- Regularly update execution environment with latest collections
- Keep AAP platform updated
- Review and update excluded packages list
- Test playbook changes in development environment
- Monitor for new CVEs requiring immediate patching
- Update documentation as infrastructure changes
