# Fortinet Execution Environment for AAP 2.5

This directory contains all files needed to build a custom Execution Environment (EE) for Fortinet automation in Ansible Automation Platform 2.5.

## Directory Structure

```
execution-environment/
├── execution-environment.yml    # Main EE definition file
├── requirements.yml            # Ansible collections to install
├── requirements.txt            # Python packages to install
├── bindep.txt                 # System packages to install
├── rebuild-fortinet-ee.sh     # Automated build script
├── validate-ee-requirements.sh # Pre-build validation script
└── .gitignore                 # Git ignore patterns
```

## Quick Start

### 1. Validate Requirements
```bash
./validate-ee-requirements.sh
```

### 2. Build the Execution Environment
```bash
./rebuild-fortinet-ee.sh
```

### 3. Push to Registry
```bash
# Tag for your registry
podman tag fortinet-ee:latest your-registry.com/fortinet-ee:latest

# Push to registry
podman push your-registry.com/fortinet-ee:latest
```

### 4. Configure in AAP 2.5
1. Navigate to **Administration → Execution Environments**
2. Click **Add**
3. Configure:
   - **Name**: `Fortinet EE`
   - **Image**: `your-registry.com/fortinet-ee:latest`
   - **Pull**: Select appropriate credentials

## Files Description

### execution-environment.yml
Main configuration file that defines:
- Base image (Red Hat AAP 2.5 minimal)
- Dependencies files
- Build steps for installing collections

### requirements.yml
Ansible collections required:
- `fortinet.fortios`: FortiGate automation
- `ansible.netcommon`: Network common modules
- `community.general`: General community modules
- Other supporting collections

### requirements.txt
Python packages required:
- `fortiosapi`: Fortinet API library
- `paramiko`: SSH connectivity
- `netaddr`: Network address manipulation
- Other networking libraries

### bindep.txt
System packages for various platforms:
- Development tools (gcc, python-devel)
- SSH clients
- Network utilities

## Building Manually

If you prefer to build manually instead of using the script:

```bash
# Basic build
ansible-builder build -t fortinet-ee:latest

# With specific container runtime
ansible-builder build -t fortinet-ee:latest --container-runtime podman

# With verbosity
ansible-builder build -t fortinet-ee:latest -v 3
```

## Testing the Built Image

Test if collections are properly installed:

```bash
# List collections
podman run --rm fortinet-ee:latest ansible-galaxy collection list

# Test Fortinet module availability
podman run --rm fortinet-ee:latest ansible-doc fortinet.fortios.fortios_system_global
```

## Troubleshooting

### Build Fails
- Ensure you have `ansible-builder` installed: `pip install ansible-builder`
- Check you have podman or docker installed
- Verify all dependency files exist

### Collections Not Found
- Check `requirements.yml` syntax
- Ensure Galaxy URLs are accessible
- Verify collection names and versions

### Python Package Issues
- Some packages may require system dependencies
- Check `bindep.txt` includes necessary build tools
- Review build logs for compilation errors

### Registry Push Issues
- Ensure you're logged into your registry: `podman login your-registry.com`
- Check you have push permissions
- Verify registry URL is correct

## Customization

### Using Different Base Image
Edit `execution-environment.yml`:
```yaml
images:
  base_image:
    name: 'your-preferred-base-image:tag'
```

### Adding More Collections
Edit `requirements.yml`:
```yaml
collections:
  - name: namespace.collection
    version: ">=1.0.0"
```

### Adding Python Packages
Edit `requirements.txt`:
```
package-name>=1.0.0
```

### Adding System Packages
Edit `bindep.txt`:
```
package-name [platform:centos platform:rhel]
```

## Best Practices

1. **Version Control**: Always tag your images with versions
2. **Registry**: Use a private registry for production
3. **Updates**: Regularly update collections and packages
4. **Testing**: Test new builds before production use
5. **Documentation**: Document any customizations

## Support

For issues related to:
- **Fortinet Collections**: Check [Fortinet Galaxy](https://galaxy.ansible.com/fortinet/fortios)
- **AAP 2.5**: Refer to Red Hat documentation
- **Build Issues**: Check ansible-builder documentation