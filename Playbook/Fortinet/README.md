# Fortinet Ansible Playbook Suite - AAP 2.5 Ready

This repository provides a modular and survey-driven set of Ansible playbooks for managing and monitoring Fortinet Virtual Appliances (VA). The playbooks are **fully compatible with Ansible Automation Platform (AAP) 2.5** and designed for execution in **AAP web console using Execution Environments**.

## 🆕 AAP 2.5 Compatibility Features

### Execution Environment Support
- ✅ **Custom Execution Environment** with `execution-environment.yml`
- ✅ **Python dependencies** defined in `requirements.txt`
- ✅ **System packages** defined in `bindep.txt`
- ✅ **Collection requirements** updated for AAP 2.5
- ✅ **Container-optimized** ansible.cfg configuration

### AAP Web Console Integration
- ✅ **Survey-driven** job templates for all playbooks
- ✅ **AAP credential management** integration (Machine, Vault, Custom credentials)
- ✅ **Dynamic inventory** with inventory plugins support
- ✅ **Enhanced logging** and job tracking
- ✅ **Role-based access control** ready
- ✅ **Workflow** integration support

### Inventory Management Best Practices
- ✅ **Multiple inventory options**: Static YAML, Dynamic Python script, Constructed inventory
- ✅ **AAP credential injection**: Automatic username/password injection from AAP machine credentials
- ✅ **Environment-based grouping**: Production, staging, development groups with specific variables
- ✅ **Device categorization**: Group by type (firewall/router), location (datacenter/cloud), model
- ✅ **Inventory caching**: Performance optimization for large inventories

### Security Best Practices Integration
- ✅ **No hardcoded credentials**: All authentication through AAP credential management
- ✅ **Ansible Vault support**: Optional encryption for sensitive group_vars
- ✅ **RBAC-ready**: Proper permission structures for team-based access
- ✅ **Audit logging**: Connection tracking and job execution logs
- ✅ **Credential rotation**: Easy password updates through AAP interface

### New Files for AAP 2.5
| File | Purpose |
|------|---------|
| `execution-environment.yml` | Defines the execution environment container |
| `bindep.txt` | System package dependencies |
| `requirements.txt` | Python package dependencies |
| `build-info.yml` | EE build instructions and validation |
| `meta/galaxy.yml` | Collection metadata |
| `AAP-2.5-SETUP-GUIDE.md` | Complete setup guide for AAP 2.5 |
| `AAP-CREDENTIAL-SETUP-GUIDE.md` | Credential management best practices |
| `inventory/fortinet_aap.yml` | AAP-optimized static inventory |
| `inventory/fortinet_dynamic.py` | Dynamic inventory script |
| `inventory/fortinet_dynamic.yml` | Constructed inventory configuration |

## Inventory Options for AAP 2.5

### 1. Static Inventory with AAP Credentials (`inventory/fortinet_aap.yml`)
- **Best for**: Fixed device lists with known IP addresses
- **Features**: Environment-based grouping, AAP credential integration
- **Usage**: Standard AAP inventory import

### 2. Dynamic Inventory Script (`inventory/fortinet_dynamic.py`)
- **Best for**: Integration with external CMDBs or APIs
- **Features**: Real-time device discovery, environment variable injection
- **Usage**: Executable inventory source in AAP

### 3. Constructed Inventory (`inventory/fortinet_dynamic.yml`)
- **Best for**: Complex grouping and variable composition
- **Features**: Plugin-based inventory with advanced grouping rules
- **Usage**: YAML-based dynamic inventory with plugins

## Credential Management Integration

### AAP Machine Credentials
All playbooks now use AAP machine credentials for authentication:
- **No hardcoded passwords** in playbooks or variables
- **Automatic injection** of `ansible_user` and `ansible_password`
- **Credential rotation** through AAP interface
- **RBAC-controlled** access to credentials

### Group Variables Structure
```
group_vars/
├── all/main.yml          # Global defaults for all devices
├── production/main.yml   # Production environment settings
├── staging/main.yml      # Staging environment settings
├── firewalls/main.yml    # Firewall-specific variables
└── datacenter_*/main.yml # Location-specific variables
```

### Survey Updates
- **Target selection**: Choose device groups instead of manual host lists
- **No credential prompts**: Credentials automatically injected by AAP
- **Environment-aware**: Surveys adapt to target environment settings

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

## Usage with AAP 2.5

### 1. Configure Inventory and Credentials
   - **Set up AAP Machine Credential** for Fortinet device access (see [AAP-CREDENTIAL-SETUP-GUIDE.md](AAP-CREDENTIAL-SETUP-GUIDE.md))
   - **Import inventory** using one of the provided inventory options
   - **Configure device grouping** in inventory (production, staging, firewalls, etc.)

### 2. Create and Run Job Templates
   - **Create job templates** in AAP web console pointing to playbooks
   - **Attach machine credentials** to job templates for automatic authentication
   - **Import surveys** from `surveys/` directory for dynamic parameter input
   - **Select target groups** using surveys (e.g., `production`, `staging`, `firewalls`)

### 3. Example Job Template Setup
   ```yaml
   Job Template: "Fortinet - Check VPN Status"
   Inventory: "Fortinet Devices"
   Project: "Fortinet Management" 
   Playbook: "playbooks/check_vpn_phase2_status.yml"
   Credentials: ["Fortinet Device Access"]
   Survey: "check_vpn_phase2_status-survey.json"
   ```

### 4. Monitor and Audit
   - **View execution logs** in AAP web console
   - **Track job history** and success/failure rates
   - **Review connection logs** at `/tmp/fortinet_connections.log`
   - **Monitor credential usage** through AAP audit logs

📖 **For detailed credential setup, see [AAP-CREDENTIAL-SETUP-GUIDE.md](AAP-CREDENTIAL-SETUP-GUIDE.md)**
📖 **For complete AAP setup instructions, see [AAP-2.5-SETUP-GUIDE.md](AAP-2.5-SETUP-GUIDE.md)**

## Requirements - Updated for AAP 2.5

### Execution Environment Requirements
- **Ansible Automation Platform (AAP) 2.5** or higher
- **Execution Environment** with container runtime support
- **Container registry access** for custom EE (optional)

### Collection Requirements
- `fortinet.fortios` collection version **2.3.0+** (install via `requirements.yml`)
- `community.general` collection version **8.0.0+** for email notifications
- `ansible.posix` collection version **1.5.0+**
- `ansible.netcommon` collection version **5.0.0+**
- `ansible.utils` collection version **3.0.0+**

### Infrastructure Requirements
- **Access to Fortinet VA endpoints** via HTTPS (port 443)
- **SMTP server** for email notifications (if using notification playbook)
- **Network connectivity** from AAP execution environment to Fortinet devices

### Security Requirements
- **Ansible Vault** for sensitive variables (recommended)
- **AAP credential management** for device access
- **RBAC configuration** in AAP (recommended)

## 🚀 Quick Start for AAP 2.5

### 1. Set Up Execution Environment
```bash
# Build custom execution environment (optional)
ansible-builder build --tag fortinet-ee:latest .

# Or use pre-built EE in AAP console
# Navigate to Administration > Execution Environments
# Add: quay.io/ansible/automation-hub-ee:latest
```

### 2. Import Project in AAP
1. **Create Project** in AAP web console
2. **Point to this repository** URL
3. **Select Execution Environment**: Fortinet Management EE
4. **Sync project** to import playbooks

### 3. Configure Credentials
1. **Machine Credential**: Fortinet device access
2. **Vault Credential**: For encrypted variables (optional)

### 4. Create Job Templates
1. **Import surveys** from `surveys/` directory
2. **Link to playbooks** in `playbooks/` directory
3. **Test execution** with sample parameters

📖 **For detailed setup instructions, see [AAP-2.5-SETUP-GUIDE.md](AAP-2.5-SETUP-GUIDE.md)**

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

## 📝 AAP 2.5 Migration Changes

This section documents all changes made to ensure AAP 2.5 compatibility, execution environment support, and security best practices:

### New Files Added
1. **`execution-environment.yml`** - Defines the container image and build process for the execution environment
2. **`bindep.txt`** - System package dependencies required in the execution environment
3. **`requirements.txt`** - Python package dependencies for Fortinet operations
4. **`build-info.yml`** - Build instructions and validation commands for the execution environment
5. **`meta/galaxy.yml`** - Collection metadata for AAP 2.5 compatibility
6. **`AAP-2.5-SETUP-GUIDE.md`** - Complete setup guide for AAP 2.5 web console
7. **`AAP-CREDENTIAL-SETUP-GUIDE.md`** - Comprehensive credential management guide
8. **`inventory/fortinet_aap.yml`** - AAP-optimized static inventory with credential integration
9. **`inventory/fortinet_dynamic.py`** - Dynamic inventory script with AAP environment support
10. **`inventory/fortinet_dynamic.yml`** - Constructed inventory configuration with plugins
11. **`group_vars/all/main.yml`** - Global variables with AAP credential integration
12. **`group_vars/production/main.yml`** - Production environment-specific variables
13. **`group_vars/staging/main.yml`** - Staging environment-specific variables

### Updated Files
1. **`ansible.cfg`** - Updated for execution environment and inventory plugin compatibility:
   - Changed log path to `/tmp/` for container compatibility
   - Added inventory plugin support and caching
   - Enhanced execution environment optimizations

2. **`requirements.yml`** - Updated collection versions:
   - `fortinet.fortios` >= 2.3.0
   - `community.general` >= 8.0.0
   - `ansible.posix` >= 1.5.0
   - Added `ansible.builtin` and `ansible.utils` collections

3. **`playbooks/connect_fortinet.yml`** - Enhanced for AAP credential integration:
   - Removed hardcoded credential variables
   - Added AAP variable injection support
   - Enhanced authentication and logging
   - Added audit trail functionality

4. **`surveys/connect_fortinet-survey.json`** - Updated for inventory-based targeting:
   - Replaced manual host input with group selection
   - Removed credential prompts (handled by AAP)
   - Added environment-specific options

5. **`README.md`** - Comprehensive documentation updates:
   - AAP 2.5 compatibility features
   - Inventory management best practices
   - Credential setup instructions
   - Security best practices integration

### Configuration Optimizations
- **Container-ready logging** with writable paths
- **Inventory plugin support** with caching for performance
- **Memory-based fact caching** for improved execution speed
- **Enhanced error handling** for execution environments
- **Standardized collection paths** for containers

### Security Enhancements
- **Eliminated hardcoded credentials** from all playbooks and variables
- **AAP credential injection** using machine, vault, and custom credentials
- **Environment-based variable segregation** using group_vars structure
- **RBAC-ready configurations** with proper permission structures
- **Audit logging** for connection tracking and compliance
- **Encrypted credential** support in job templates

### Inventory Management Improvements
- **Multiple inventory options** for different use cases and environments
- **Dynamic grouping** by environment, device type, and location
- **AAP credential integration** with automatic variable injection
- **Inventory caching** for improved performance with large device lists
- **Plugin-based inventory** for advanced composition and grouping rules

### Playbook Enhancements
- **Target flexibility** using inventory groups instead of manual host lists
- **AAP variable integration** with automatic credential and metadata injection
- **Enhanced logging** with job tracking and audit trails
- **Environment awareness** through group_vars and inventory metadata
- **Error handling** improvements for container execution environments

## Extending
- Add new playbooks for additional Fortinet operations as needed.
- Surveys can be extended to include more variables or validation.

## Support

For issues or feature requests related to these AAP 2.5 compatible Fortinet playbooks:

1. **AAP 2.5 Setup Issues**: Refer to [AAP-2.5-SETUP-GUIDE.md](AAP-2.5-SETUP-GUIDE.md)
2. **Execution Environment Issues**: Check the build logs and container documentation
3. **Playbook Issues**: Open an issue in this repository
4. **Collection Issues**: Refer to the respective collection documentation:
   - [Fortinet FortiOS Collection](https://docs.ansible.com/ansible/latest/collections/fortinet/fortios/)
   - [Community General Collection](https://docs.ansible.com/ansible/latest/collections/community/general/)

### Migration Support

If you're migrating from older Ansible/AWX versions:
- Review the migration changes in the **AAP 2.5 Migration Changes** section above
- Test execution environments in a non-production environment first
- Update job templates to use the new execution environment
- Verify credential management with AAP 2.5 standards

---

**📋 This playbook suite is optimized for AAP 2.5 and ready for production use with execution environments.**
