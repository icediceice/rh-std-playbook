# AIX Modules Reference Guide

## Available IBM Power AIX Collection Modules

The `ibm.power_aix` collection provides AIX-specific modules that should be used instead of generic commands where possible.

### System Information & Facts Modules

| Module | Purpose | Use Case |
|--------|---------|----------|
| `ibm.power_aix.getconf` | Get system configuration variables | Better than `uname -a` or `oslevel` |
| `ibm.power_aix.lpar_facts` | Get LPAR information | Partition details, CPU, memory |
| `ibm.power_aix.lvm_facts` | Get LVM information | Volume groups, logical volumes, PVs |
| `ibm.power_aix.lpp_facts` | Get installed software info | Better than `lslpp -L` |
| `ibm.power_aix.mpio` | MultiPath I/O device info | Storage multipathing details |

### System Management Modules

| Module | Purpose | Use Case |
|--------|---------|----------|
| `ibm.power_aix.filesystem` | Manage filesystems | Create, mount, unmount filesystems |
| `ibm.power_aix.lvg` | Manage volume groups | Create, extend, reduce VGs |
| `ibm.power_aix.lvol` | Manage logical volumes | Create, extend, reduce LVs |
| `ibm.power_aix.mount` | Mount/unmount filesystems | Better than `mount` command |
| `ibm.power_aix.pagingspace` | Manage paging space | Swap space management |
| `ibm.power_aix.devices` | Manage devices | Device configuration |

### Software & Updates Modules

| Module | Purpose | Use Case |
|--------|---------|----------|
| `ibm.power_aix.installp` | Install/update software | Package management |
| `ibm.power_aix.emgr` | Manage interim fixes | eFix management |
| `ibm.power_aix.flrtvc` | Security fix management | Automated security updates |
| `ibm.power_aix.install_all_updates` | System updates | Complete system patching |
| `ibm.power_aix.suma` | SUMA operations | Service packs, technology levels |

### System Monitoring & Diagnostics

| Module | Purpose | Use Case |
|--------|---------|----------|
| `ibm.power_aix.errpt` | System error reporting | Better than `errpt` command |
| `ibm.power_aix.nmon` | Performance monitoring | System health checks |
| `ibm.power_aix.snap` | Diagnostic data collection | System diagnostics |

### User & Security Management

| Module | Purpose | Use Case |
|--------|---------|----------|
| `ibm.power_aix.user` | Manage AIX users | User account management |
| `ibm.power_aix.group` | Manage AIX groups | Group management |
| `ibm.power_aix.chsec` | Modify security stanzas | Security configuration |
| `ibm.power_aix.aixpert` | Security settings | System security management |

### NIM (Network Installation Manager) Modules

| Module | Purpose | Use Case |
|--------|---------|----------|
| `ibm.power_aix.nim` | NIM operations | Network installations |
| `ibm.power_aix.nim_resource` | Manage NIM resources | Resource management |
| `ibm.power_aix.nim_suma` | NIM SUMA operations | Centralized updates |
| `ibm.power_aix.nim_flrtvc` | NIM security fixes | Centralized security updates |

## Module Usage Examples

### System Information
```yaml
# Get system configuration
- name: Get AIX system config
  ibm.power_aix.getconf:
    name: 
      - KERNEL_BITMODE
      - _SC_NPROCESSORS_ONLN

# Get LPAR information  
- name: Get LPAR details
  ibm.power_aix.lpar_facts:

# Get LVM information
- name: Get LVM facts
  ibm.power_aix.lvm_facts:
```

### System Management
```yaml
# Manage filesystem
- name: Create filesystem
  ibm.power_aix.filesystem:
    filesystem: /test
    state: present
    vg: rootvg
    size: 1G

# Check system errors
- name: Check recent errors
  ibm.power_aix.errpt:
    detail: false
    criteria: "-s mmddHHMM{{ ansible_date_time.month }}{{ ansible_date_time.day }}0000"
```

### Software Management
```yaml
# Install software
- name: Install package
  ibm.power_aix.installp:
    name: package_name
    state: present

# Get installed software
- name: Get software list
  ibm.power_aix.lpp_facts:
```

## Advantages of AIX Modules vs Generic Commands

| Task | Generic Command | AIX Module | Advantage |
|------|----------------|------------|-----------|
| System info | `oslevel -r` | `ibm.power_aix.getconf` | Structured output, multiple values |
| Disk usage | `df -h` | `ibm.power_aix.filesystem` | Management capabilities |
| Error checking | `errpt` | `ibm.power_aix.errpt` | Better filtering, structured output |
| Software info | `lslpp -L` | `ibm.power_aix.lpp_facts` | Structured facts, searchable |
| LVM info | `lsvg`, `lslv` | `ibm.power_aix.lvm_facts` | Complete LVM facts in one call |

## Best Practices

1. **Always prefer AIX modules** over generic commands when available
2. **Use facts modules** to gather system information instead of parsing command output  
3. **Combine multiple modules** in a single task when possible
4. **Handle errors gracefully** using `failed_when: false` for discovery tasks
5. **Use structured output** from modules instead of parsing text output

## Updated Connectivity Test

The enhanced connectivity test (`aix_connectivity_test_enhanced.yml`) uses these AIX modules:
- `ibm.power_aix.getconf` - System configuration
- `ibm.power_aix.lpar_facts` - LPAR information  
- `ibm.power_aix.lvm_facts` - LVM details
- `ibm.power_aix.errpt` - Error reporting
- `ibm.power_aix.lpp_facts` - Software information
- `ibm.power_aix.filesystem` - Filesystem management