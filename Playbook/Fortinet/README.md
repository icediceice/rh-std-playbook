# Fortinet Ansible Playbook Suite

This repository provides a modular and survey-driven set of Ansible playbooks for managing and monitoring Fortinet Virtual Appliances (VA). The playbooks are designed for operational flexibility, automation, and easy integration with Ansible Tower/AWX surveys.

## Features
- **Centralized Host Management:**
  - Manage all Fortinet VA endpoints via `group_vars/fortinet.yml` or the `fortinet_hosts-management-survey.json`.
- **Modular Playbooks:**
  - Each playbook is focused on a specific operational task and uses variables for easy customization.
- **Survey Integration:**
  - All playbooks are compatible with Ansible Tower/AWX surveys for dynamic variable input.
- **Multi-Endpoint Support:**
  - Easily target multiple Fortinet VAs by editing the `fortinet_hosts` variable.

## Playbooks

| Playbook | Description |
|----------|-------------|
| `connect_fortinet.yml` | Connect and authenticate to Fortinet VA (with encrypted password support). |
| `check_vpn_phase2_status.yml` | Check the status of a specific VPN Phase 2 tunnel. |
| `flush_phase2_tunnel.yml` | Flush all Phase 2 tunnels for a specified VPN. |
| `verify_tcp_application.yml` | Verify application connectivity over TCP/IP. |
| `enable_packet_capture.yml` | Enable packet capture on all interfaces related to a VPN. |
| `flush_tunnel1.yml` | Flush a specific tunnel (Tunnel 1). |
| `check_ike_phase1_status.yml` | Check the status of a specific IKE Phase 1 tunnel. |
| `run_diagnostic.yml` | Run diagnostic commands on Fortinet VA. |
| `notify_admin_tunnel_status.yml` | Send an email notification to admin about tunnel status. |

## Surveys
- Each playbook (except host management) has a matching survey JSON in the `surveys/` directory for variable input.
- Use `fortinet_hosts-management-survey.json` to add or remove Fortinet VA endpoints. This survey always pre-populates the current value for safe editing.

## Usage

1. **Configure Hosts:**
   - Edit `group_vars/fortinet.yml` to set your initial `fortinet_hosts` list.
   - Or use the `fortinet_hosts-management-survey.json` survey to update the list.

2. **Run Playbooks:**
   - Use Ansible CLI or Tower/AWX. For Tower/AWX, attach the relevant survey to the job template.
   - Example CLI usage:
     ```sh
     ansible-playbook -i inventory playbooks/check_vpn_phase2_status.yml -e @group_vars/fortinet.yml
     ```

3. **Customize Variables:**
   - Use surveys to override variables at runtime, or edit variable files for persistent changes.

4. **Email Notification:**
   - Use `notify_admin_tunnel_status.yml` to send tunnel status notifications. Configure SMTP and admin email in the survey or variable file.

## Requirements

- Ansible Automation Platform (AAP) 2.5 or higher
- `fortinet.fortios` collection version 2.1.0+ (install with `ansible-galaxy collection install fortinet.fortios`)
- `community.general` collection version 3.0.0+ for email notifications
- `ansible.posix` collection version 1.0.0+
- Access to Fortinet VA endpoints via HTTPS (port 443)
- SMTP server for email notifications (if using notification playbook)
- Ansible Vault for sensitive variables (recommended)

## Example Inventory
```ini
[fortinet]
fortinet1 ansible_host=192.168.1.10
fortinet2 ansible_host=192.168.1.11
```

## Example Variable File (`group_vars/fortinet.yml`)
```yaml
fortinet_hosts: fortinet1,fortinet2
vdom: root
```

## Extending
- Add new playbooks for additional Fortinet operations as needed.
- Surveys can be extended to include more variables or validation.

## Support
For issues or feature requests, please open an issue in this repository.
