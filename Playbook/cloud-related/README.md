# Cloud-Related Ansible Playbooks

This repository provides modular, cloud-agnostic Ansible playbooks for provisioning, managing, and auditing resources across AWS, Azure, and GCP. The structure and surveys are designed for use with Ansible Automation Platform (AAP) and follow best practices for reusability, security, and user experience.

## Features
- **Modular Roles**: Each cloud task (server, PVC/volume, network, security, unused resource query, authentication) is implemented as a reusable role.
- **Multi-Cloud Support**: All playbooks and surveys support AWS, Azure, and GCP. The user selects the provider at runtime.
- **Dynamic Surveys**: Only relevant questions are shown based on the selected cloud provider.
- **Secure Authentication**: Credentials are collected, encrypted, and can be reused securely.
- **Workflow Ready**: Includes a workflow playbook for full environment setup and resource auditing.
- **Email Reporting**: Optional email reports for unused resources.

## Structure
```
cloud-related/
  playbooks/
    cloud-auth.yml
    provision-server.yml
    provision-pvc.yml
    setup-cloud-env.yml
    query-unused-resources.yml
    workflow_cloud_setup.yml
  roles/
    cloud_auth/
    cloud_server/
    cloud_pvc/
    cloud_network/
    cloud_security/
    cloud_query_unused/
  surveys/
    cloud-auth-survey.json
    provision-server-survey.json
    provision-pvc-survey.json
    setup-cloud-env-survey.json
    query-unused-resources-survey.json
```

## Getting Started

### 1. Authenticate to Your Cloud Provider
Run the authentication playbook to securely store and encrypt your credentials:
```sh
ansible-playbook playbooks/cloud-auth.yml
```
- Fill out the dynamic survey. Credentials will be encrypted and saved for reuse.

### 2. Provision Resources
You can provision servers, storage, and networks by running the respective playbooks:
```sh
ansible-playbook playbooks/provision-server.yml
ansible-playbook playbooks/provision-pvc.yml
ansible-playbook playbooks/setup-cloud-env.yml
```
- Each playbook will prompt you with a dynamic survey for the selected cloud provider.

### 3. Query Unused Resources
Audit unused resources (e.g., stopped/unused VMs) and save the results:
```sh
ansible-playbook playbooks/query-unused-resources.yml
```
- Results are displayed and saved to a file for review.

### 4. Full Workflow
To run a full environment setup and audit in sequence:
```sh
ansible-playbook playbooks/workflow_cloud_setup.yml
```

## Security
- All credentials are encrypted using Ansible Vault if a vault password file is provided.
- Sensitive fields in surveys are hidden and not logged.

## Customization
- Add or modify roles in the `roles/` directory to support additional resource types or providers.
- Update surveys in `surveys/` to match your organization's requirements.

## Requirements
- Ansible 2.10+
- Ansible collections for AWS, Azure, and GCP (see requirements.yml if provided)
- Ansible Automation Platform (AAP) for survey and workflow features

## Support
For questions or contributions, please open an issue or pull request.

## Email Reporting
- To use the email reporting feature for unused resources, you must set the following variables (can be in your prefilled vars file or survey):

  - smtp_host: SMTP server hostname (e.g., smtp.gmail.com)
  - smtp_port: SMTP server port (default: 587)
  - smtp_username: SMTP username (if required)
  - smtp_password: SMTP password (if required)
  - report_email_to: Recipient email address
  - report_email_from: Sender email address

- Required Ansible collections (install with `ansible-galaxy collection install -r requirements.yml`):
  - amazon.aws
  - azure.azcollection
  - google.cloud
  - community.general

---
This project is designed for rapid, secure, and flexible cloud automation. Enjoy!
