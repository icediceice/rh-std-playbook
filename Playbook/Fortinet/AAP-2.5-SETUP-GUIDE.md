# AAP 2.5 Execution Environment Setup Guide for Fortinet Management

## Overview
This guide provides step-by-step instructions for setting up and using the Fortinet management playbooks with Ansible Automation Platform 2.5 execution environments.

## Prerequisites
- Ansible Automation Platform 2.5 or higher
- Access to AAP web console
- Container registry access (optional, for custom EE)
- Fortinet devices accessible via HTTPS

## Execution Environment Setup

### Option 1: Using Pre-built Execution Environment
1. In AAP web console, navigate to **Administration > Execution Environments**
2. Click **Add** to create a new execution environment
3. Use the following settings:
   - **Name**: `Fortinet Management EE`
   - **Image**: `quay.io/ansible/automation-hub-ee:latest`
   - **Pull**: `Always`

### Option 2: Building Custom Execution Environment
1. Ensure `ansible-builder` is installed on your build system
2. Navigate to the Fortinet playbook directory
3. Build the execution environment:
   ```bash
   # Quick build using helper script
   ./build-ee.sh
   
   # Or navigate to EE directory for more options
   cd execution-environment
   ./build.sh
   
   # Or use Make for advanced options
   cd execution-environment
   make build
   make test
   ```
4. Push to your container registry:
   ```bash
   cd execution-environment
   make push REGISTRY=your-registry.com
   # Or manually:
   podman tag fortinet-ee:latest your-registry.com/fortinet-ee:latest
   podman push your-registry.com/fortinet-ee:latest
   ```
5. In AAP web console, add the execution environment with your registry URL

## Project Setup in AAP 2.5

### 1. Create Project
1. Navigate to **Resources > Projects**
2. Click **Add** to create a new project
3. Configure:
   - **Name**: `Fortinet Management`
   - **Source Control Type**: `Git`
   - **Source Control URL**: Your repository URL
   - **Source Control Branch/Tag/Commit**: `main`
   - **Execution Environment**: `Fortinet Management EE`

### 2. Create Inventory
1. Navigate to **Resources > Inventories**
2. Click **Add > Add inventory**
3. Configure:
   - **Name**: `Fortinet Devices`
   - **Organization**: Your organization
4. Add hosts under **Hosts** tab:
   - Host names should match your Fortinet device names
   - Set **Variables** for each host:
     ```yaml
     ansible_host: 192.168.1.10
     ansible_user: admin
     ansible_password: "{{ vault_fortinet_password }}"
     ```

### 3. Create Credentials

#### Fortinet Device Credential
1. Navigate to **Resources > Credentials**
2. Click **Add** to create credential
3. Configure:
   - **Name**: `Fortinet Device Access`
   - **Credential Type**: `Machine`
   - **Username**: Your Fortinet admin username
   - **Password**: Your Fortinet admin password

#### Vault Credential (Optional)
1. Create another credential for Ansible Vault
2. Configure:
   - **Name**: `Fortinet Vault`
   - **Credential Type**: `Vault`
   - **Vault Password**: Your vault password

### 4. Create Job Templates

#### Example: Check VPN Phase 2 Status Template
1. Navigate to **Resources > Templates**
2. Click **Add > Add job template**
3. Configure:
   - **Name**: `Fortinet - Check VPN Phase 2 Status`
   - **Job Type**: `Run`
   - **Inventory**: `Fortinet Devices`
   - **Project**: `Fortinet Management`
   - **Playbook**: `playbooks/check_vpn_phase2_status.yml`
   - **Execution Environment**: `Fortinet Management EE`
   - **Credentials**: Select your Fortinet device credential
   - **Variables**: (Leave empty to use survey)

#### Add Survey to Job Template
1. In the job template, click **Survey** tab
2. Click **Add**
3. Upload the corresponding survey JSON from the `surveys/` directory
4. Save and enable the survey

## Running Playbooks

### Using Job Templates with Surveys
1. Navigate to **Resources > Templates**
2. Click the launch button (rocket icon) next to your job template
3. Fill in the survey form with required parameters
4. Click **Launch**

### Monitoring Execution
1. Navigate to **Views > Jobs** to see running/completed jobs
2. Click on a job to see detailed output
3. Use the **Output** tab to see real-time execution logs

## Troubleshooting

### Common Issues

#### Collection Not Found
- Ensure the execution environment includes all required collections
- Check the `requirements.yml` file in your project

#### Connection Issues
- Verify Fortinet device credentials
- Check network connectivity from AAP to Fortinet devices
- Ensure HTTPS (port 443) is accessible

#### Execution Environment Issues
- Check EE logs in **Administration > Execution Environments**
- Verify container image pull permissions
- Ensure all Python dependencies are included

### Debugging Tips
1. Enable verbose logging in job templates
2. Use the **Survey** feature to override variables for testing
3. Check the **Output** tab for detailed error messages
4. Verify inventory host variables are correctly set

## Security Best Practices
1. Use Ansible Vault for sensitive variables
2. Implement proper RBAC in AAP
3. Regularly update execution environments
4. Use encrypted credentials in AAP
5. Enable audit logging

## Support
For issues with these playbooks, check:
1. AAP documentation
2. Fortinet collection documentation
3. Project repository issues
