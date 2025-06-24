---
title: Ansible OS Patching Playbooks
---

# Ansible OS Patching Playbooks

This repository contains a set of Ansible playbooks designed for automated operating system patching across Linux (RedHat/Debian families) and Windows environments. It includes a main patching playbook, an interactive inventory management utility, and demonstrates a structured approach to OS maintenance.

## Features

- **Cross-Platform Patching**: Supports patching for both Linux (RedHat/Debian) and Windows operating systems.
- **Conditional Reboot**: Automatically reboots hosts if required by patching and explicitly allowed by configuration.
- **Configurable Updates**:
    - For Windows: Specify update categories (e.g., `SecurityUpdates`, `CriticalUpdates`).
    - For Linux: Exclude specific packages from updates.
- **Interactive Inventory Management**: A utility playbook (`manage_inventory.yml`) to easily add new hosts to your Ansible inventory file.
- **Ansible Automation Platform (AAP/AWX) Ready**: Designed with variables that can be easily mapped to survey definitions in AAP/AWX for a guided execution experience.

## Prerequisites

Before running these playbooks, ensure you have the following:

- **Ansible**: Version 2.9 or newer is recommended.
- **Python**: Required on the control node for Ansible.
- **Connectivity**:
    - **Linux Hosts**: SSH access configured (e.g., SSH keys, password-based authentication).
    - **Windows Hosts**: WinRM configured and accessible. You may need to install `pywinrm` on your Ansible control node (`pip install pywinrm`).

## Directory Structure

```
.
├── patching_playbook.yml       # Main playbook for OS patching
├── manage_inventory.yml        # Interactive playbook to manage the inventory file
├── inventory                   # Example inventory file
└── roles/
    ├── linux_patching/         # Role for Linux patching (implied by patching_playbook.yml)
    └── windows_patching/       # Role for Windows patching (implied by patching_playbook.yml)
```

*(Note: The `linux_patching` and `windows_patching` roles are referenced by `patching_playbook.yml` but are not provided in this context. You would need to create or obtain these roles.)*

## Usage

### 1. Inventory Setup

The `inventory` file defines your target hosts. You can either edit it manually or use the interactive `manage_inventory.yml` playbook.

**Using the Interactive Inventory Manager:**

This playbook will display the current inventory and then prompt you for details to add new hosts.

```bash
ansible-playbook -i inventory manage_inventory.yml
```

**Example `inventory` file structure:**

```ini
[linux]
linux-node1.example.com ansible_host=192.168.1.10

[windows]
windows-node1.example.com ansible_host=192.168.1.20

[all:vars]
# Common variables for all hosts
# It's recommended to store credentials in AAP's credential store
# ansible_user=your_user
# ansible_ssh_private_key_file=~/.ssh/id_rsa

[windows:vars]
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
ansible_winrm_transport=kerberos # or basic, ntlm, credssp
```

### 2. Running the OS Patching Playbook

The `patching_playbook.yml` orchestrates the patching process. You can control its behavior using variables.

**Basic execution (patches all hosts, no reboot):**

```bash
ansible-playbook -i inventory patching_playbook.yml
```

**Targeting specific OS types and allowing reboot:**

```bash
ansible-playbook -i inventory patching_playbook.yml -e "patch_target=linux allow_reboot=yes"
```

**Customizing Windows updates and Linux exclusions:**

```bash
ansible-playbook -i inventory patching_playbook.yml -e "patch_target=windows allow_reboot=yes win_update_categories=['SecurityUpdates', 'CriticalUpdates', 'DefinitionUpdates']"
ansible-playbook -i inventory patching_playbook.yml -e "patch_target=linux allow_reboot=no linux_exclude_packages='kernel*,httpd'"
```

## Playbook Variables

The `patching_playbook.yml` uses the following variables, which can be overridden via the command line (`-e`), `ansible.cfg`, or AAP/AWX surveys:

- `patch_target`: (Default: `all`) Specifies which hosts to target for patching. Options: `all`, `linux`, `windows`.
- `allow_reboot`: (Default: `no`) Set to `yes` to allow hosts to be rebooted if the patching process requires it.
- `win_update_categories`: (Default: `['SecurityUpdates', 'CriticalUpdates']`) For Windows hosts, a list of update categories to install.
- `linux_exclude_packages`: (Default: `""`) For Linux hosts, a comma-separated string of packages to exclude from updates (e.g., `"kernel*,httpd"`).

## Important Notes

- **Credentials**: It is highly recommended to manage sensitive credentials (e.g., `ansible_user`, `ansible_password`, SSH private keys, WinRM credentials) using Ansible Vault or, preferably, Ansible Automation Platform's credential store.
- **Privilege Escalation**: Patching and rebooting typically require elevated privileges. The playbook uses `become: true` for the reboot task. Ensure your `ansible_user` has appropriate `sudo` (Linux) or Administrator (Windows) rights.
- **Reboot Detection**: The `patching_reboot_required` variable is expected to be set by the `linux_patching` and `windows_patching` roles if a reboot is necessary after updates.
- **AAP/AWX Integration**: The `patching_survey.json` (mentioned in `patching_playbook.yml` comments) would define the survey prompts for these variables within Ansible Automation Platform, providing a user-friendly interface for job template execution.