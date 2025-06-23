# Installation Guide

## Prerequisites

- Ansible Automation Platform 2.x installed and running
- RHEL 8 or 9 target servers with:
  - Valid RHEL subscription
  - SSH access configured
  - User with sudo privileges
- Git installed on AAP controller

## Installation Steps

### 1. Clone the Repository

On your AAP controller node:

```bash
cd /tmp
git clone https://github.com/your-org/rhel-server-provisioning.git
cd rhel-server-provisioning

2. Run setup script

sudo ./scripts/setup-aap.sh

This script will:

Create the project directory structure
Copy all files to the appropriate location
Set correct permissions
Install required Ansible collections
Generate initial package lists

3. Configure AAP Web Interface
Create Project

Navigate to Resources → Projects
Click Add
Fill in:

Name: RHEL Server Provisioning
Organization: Select your organization
SCM Type: Manual
Playbook Directory: /var/lib/awx/projects/rhel-server-provisioning


Click Save

Create Inventory

Navigate to Resources → Inventories
Click Add → Add inventory
Fill in:

Name: RHEL Servers
Organization: Select your organization


Click Save
Add your target hosts to the inventory

Create Credentials

Navigate to Resources → Credentials
Click Add
Fill in:

Name: RHEL Server Access
Credential Type: Machine
Username: Your SSH username
Password: Your sudo password
SSH Private Key: Your SSH key (if using key authentication)
Privilege Escalation Method: sudo
Privilege Escalation Password: Same as password


Click Save

Create Job Template

Navigate to Resources → Templates
Click Add → Add job template
Fill in:

Name: Provision RHEL Server
Job Type: Run
Inventory: RHEL Servers
Project: RHEL Server Provisioning
Playbook: playbooks/provision-server.yml
Credentials: RHEL Server Access
Enable Privilege Escalation: ✓


Click Save

Import Survey

In the job template, click on the Survey tab
Click Add
Copy the content from surveys/server-provisioning-survey.json
Add each question according to the specification
Enable the survey

4. Create Additional Job Templates
Package Refresh Template

Create another job template named "Refresh Package Lists"
Use playbook: playbooks/refresh-packages.yml
Set to run on localhost
Schedule to run weekly for automatic updates

5. Test the Setup

Launch the "Provision RHEL Server" job template
Fill in the survey with test values
Monitor the job output

Customization
Adding Custom Packages
Edit the package lists in /var/lib/awx/projects/rhel-server-provisioning/package-lists/
Environment-Specific Settings
Modify files in group_vars/ for environment-specific configurations:

dev.yml - Development settings
staging.yml - Staging settings
production.yml - Production settings

Troubleshooting
See TROUBLESHOOTING.md for common issues and solutions.

