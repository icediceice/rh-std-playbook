# RHEL Server Provisioning Playbook for Ansible Automation Platform

This repository contains a comprehensive Ansible playbook solution for provisioning Red Hat Enterprise Linux servers through AAP's web GUI.

## Features

- **Environment Support**: Development, Staging, and Production
- **Server Roles**: Web Server, Database Server, Logging Server, General Purpose
- **Dynamic Package Management**: Automatically refreshable package lists
- **AAP Survey Integration**: User-friendly GUI input
- **RHEL Focused**: Optimized for Red Hat Enterprise Linux 8/9

## Quick Start

1. Clone this repository
2. Run the setup script: `./scripts/setup-aap.sh`
3. Import into AAP as a project
4. Create a job template using `playbooks/provision-server.yml`
5. Attach the survey from `surveys/server-provisioning-survey.json`

For detailed instructions, see [docs/INSTALLATION.md](docs/INSTALLATION.md)

## Requirements

- Ansible Automation Platform 2.x
- Red Hat Enterprise Linux 8 or 9 target servers
- Valid RHEL subscription

## Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [Usage Guide](docs/USAGE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)