# AIX Python Setup Guide

## Problem: Python Interpreter Not Found

The error `"/bin/sh: /usr/bin/python3: not found"` occurs because AIX systems have different Python installation paths than Linux systems.

## Solution Steps

### Step 1: Run Python Discovery Playbook

First, discover available Python interpreters on your AIX system:

```bash
ansible-playbook playbooks/aix_python_discovery.yml -i inventory/aix_hosts.yml
```

This playbook will:
- Test basic connectivity without Python (using `raw` commands)
- Search common AIX Python installation paths
- Display available Python interpreters
- Provide configuration recommendations

### Step 2: Common AIX Python Locations

| Location | Description | Typical Installation |
|----------|-------------|---------------------|
| `/usr/bin/python` | Default AIX Python 2.x | Base AIX installation |
| `/opt/freeware/bin/python` | AIX Toolbox Python 2.x | `yum install python` |
| `/opt/freeware/bin/python3` | AIX Toolbox Python 3.x | `yum install python3` |
| `/usr/local/bin/python3` | Custom Python build | Manual compilation |
| `/opt/python/bin/python3` | Enterprise Python | Commercial package |

### Step 3: Update Inventory Configuration

Based on discovery results, update your `group_vars/all/main.yml`:

```yaml
# If Python 2 found at /usr/bin/python
ansible_python_interpreter: /usr/bin/python

# If Python 3 found at /opt/freeware/bin/python3  
ansible_python_interpreter: /opt/freeware/bin/python3

# Let Ansible auto-discover (may be slower)
ansible_python_interpreter: auto_legacy_silent
```

### Step 4: Install Python if Not Found

If no Python is found, install it:

#### Option A: Using AIX Toolbox (Recommended)
```bash
# Install yum first if not available
installp -acX -d /path/to/media rpm.rte yum

# Install Python 3
yum install python3

# Install Python 2 (if needed)
yum install python
```

#### Option B: Using Base AIX Installation
```bash
# From AIX installation media
installp -acX -d /path/to/media python
```

#### Option C: Download from IBM
Download Python from IBM AIX Toolbox:
- https://www.ibm.com/support/pages/aix-toolbox-linux-applications-downloads-alpha

### Step 5: Test Configuration

After updating the Python interpreter, test with the basic connectivity playbook:

```bash
ansible-playbook playbooks/aix_connectivity_test.yml -i inventory/aix_hosts.yml
```

## Troubleshooting

### Issue: "Module result deserialization failed"
**Cause**: Wrong Python path or Python not working
**Solution**: 
1. Run discovery playbook to verify Python path
2. Test Python manually: `ssh user@aix-host '/path/to/python --version'`
3. Update `ansible_python_interpreter` in inventory

### Issue: Python version incompatibility
**Cause**: Very old Python version (< 2.6)
**Solution**: 
1. Install newer Python version
2. Use `ansible_python_interpreter: auto_legacy_silent`

### Issue: Permission denied
**Cause**: Python executable not accessible to ansible user
**Solution**:
1. Check permissions: `ls -la /path/to/python`
2. Ensure ansible user can execute Python

## Raw Command Alternative

For systems without Python, you can use raw commands:

```yaml
- name: Execute command without Python
  raw: command_here
  register: result
```

The `aix_python_discovery.yml` playbook demonstrates this approach.

## Best Practices

1. **Always run discovery first** on new AIX systems
2. **Use consistent Python paths** across similar AIX systems  
3. **Document Python installation** in your inventory
4. **Test after changes** to ensure connectivity works
5. **Consider using auto_legacy_silent** for mixed environments

## Example Inventory Configuration

```yaml
# inventory/aix_hosts.yml
all:
  hosts:
    aix-host1:
      ansible_host: 192.168.1.100
      ansible_python_interpreter: /opt/freeware/bin/python3
    aix-host2:
      ansible_host: 192.168.1.101
      ansible_python_interpreter: /usr/bin/python
  vars:
    ansible_connection: ssh
    ansible_user: root
```

Run the discovery playbook first, then update your inventory based on the results!