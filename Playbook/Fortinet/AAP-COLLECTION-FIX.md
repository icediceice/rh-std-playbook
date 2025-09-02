# Fix for Missing Fortinet Collection in AAP 2.5

## Problem
Error: `couldn't resolve module/action 'fortinet.fortios.fortios_monitor_fact'`

## Solutions

### Solution 1: Rebuild Execution Environment (Recommended)
```bash
# From the Fortinet directory
cd /mnt/c/git/rh-std-playbook/Playbook/Fortinet

# Build the execution environment
ansible-builder build --tag fortinet-ee:latest --file execution-environment.yml

# Push to your registry
podman push fortinet-ee:latest your-registry.com/fortinet-ee:latest
```

Then in AAP:
1. Go to **Administration → Execution Environments**
2. Update or create "Fortinet EE" with image: `your-registry.com/fortinet-ee:latest`

### Solution 2: Use Default EE with Collections
In your Job Template:
1. Set **Execution Environment** to a default EE that allows collection installation
2. Enable **"Install collections/roles from requirements.yml"** option
3. Ensure your project has the `requirements.yml` file

### Solution 3: Manual Collection Install (Temporary)
The playbook now includes a pre-task to install the collection at runtime.
This adds overhead but ensures the collection is available.

### Verification
After fixing, verify collections are available:
```bash
# In the execution environment
ansible-galaxy collection list | grep fortinet
```

Expected output:
```
fortinet.fortios    2.3.0 or higher
```

## Root Cause
The execution environment doesn't have the `fortinet.fortios` collection pre-installed.
This happens when:
- Using a generic EE without Fortinet collections
- EE build didn't include the collections properly
- Collections path is incorrect in the EE

## Prevention
Always use a custom execution environment for specialized use cases like Fortinet management.