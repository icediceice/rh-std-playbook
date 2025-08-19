# Role Validation for AAP 2.5

This document helps validate that your AIX Management roles are properly configured for AAP 2.5 Git-based distribution.

## Role Structure Validation

### 1. Verify Role Directory Structure

Each role should have this structure:
```
roles/
├── filesystem_management/
│   ├── tasks/main.yml          ✓ Required
│   ├── defaults/main.yml       ✓ Required
│   ├── templates/              ✓ Required
│   ├── meta/main.yml          ✓ Required
│   └── handlers/main.yml      ✓ Optional
├── cpu_management/
│   ├── tasks/main.yml          ✓ Required
│   ├── defaults/main.yml       ✓ Required
│   ├── templates/              ✓ Required
│   └── meta/main.yml          ✓ Required
[... other roles ...]
```

### 2. Role Naming Validation

Role names must match directory names and playbook references:

| Directory Name | Playbook Reference | Status |
|----------------|-------------------|---------|
| `filesystem_management` | `- role: filesystem_management` | ✅ Valid |
| `cpu_management` | `- role: cpu_management` | ✅ Valid |
| `memory_management` | `- role: memory_management` | ✅ Valid |
| `print_queue_management` | `- role: print_queue_management` | ✅ Valid |
| `service_monitoring` | `- role: service_monitoring` | ✅ Valid |

### 3. Meta Information Validation

Each `meta/main.yml` should contain:
```yaml
galaxy_info:
  author: EIS Command Center - Unix/Linux Team
  description: [Role description]
  min_ansible_version: "2.15"
  platforms:
    - name: AIX
      versions: [all]

dependencies: []

collections:
  - ansible.posix
  - community.general
```

## AAP 2.5 Integration Validation

### 1. Project Configuration

Verify `ansible.cfg` contains:
```ini
[defaults]
roles_path = roles/
collections_paths = ./collections:~/.ansible/collections:/usr/share/ansible/collections
```

### 2. Requirements Configuration

Verify `requirements.yml` contains only external collections:
```yaml
collections:
  - name: ansible.posix
  - name: community.general
  - name: ansible.utils
  - name: community.crypto
# No roles section - using local roles
```

### 3. Playbook References

Verify playbooks reference roles correctly:
```yaml
roles:
  - role: filesystem_management
    tags:
      - filesystem
      - monitoring
```

## Testing Role Discovery

### 1. Local Testing (Development)

Test role resolution locally:
```bash
# From project directory
ansible-playbook playbooks/aix_filesystem_management.yml --check --list-tasks
```

Expected output should show tasks from the role.

### 2. AAP Testing (Production)

1. **Project Sync**: Ensure project syncs without errors
2. **Job Template Test**: Create test job template
3. **Dry Run**: Execute with `--check` mode
4. **Verify Logs**: Check for role loading messages

## Common Issues and Solutions

### Issue 1: Role Not Found
```
ERROR! the role 'filesystem_management' was not found
```

**Solutions:**
- Verify role directory exists in `roles/`
- Check role name spelling in playbook
- Ensure `roles_path` in ansible.cfg is correct

### Issue 2: Role Tasks Not Loading
```
PLAY [AIX Filesystem Management] ***
TASK [Gathering Facts] ***
[No role tasks shown]
```

**Solutions:**
- Verify `tasks/main.yml` exists in role
- Check YAML syntax in task files
- Ensure proper indentation

### Issue 3: Role Dependencies Not Resolved
```
ERROR! Unable to retrieve file contents
Could not find or access 'ansible.posix'
```

**Solutions:**
- Verify `requirements.yml` lists required collections
- Ensure AAP has access to Automation Hub/Galaxy
- Check collection installation in execution environment

## Best Practices for Git-based Roles

### 1. Version Control
- Tag releases in Git for version management
- Use meaningful commit messages
- Maintain CHANGELOG.md for role updates

### 2. Testing
- Test roles independently before integration
- Use molecule for role testing (optional)
- Validate on multiple AIX versions if applicable

### 3. Documentation
- Keep role documentation in each role's directory
- Update README.md when roles change
- Document role variables and dependencies

### 4. Security
- Never commit sensitive data to Git
- Use AAP vault/credentials for secrets
- Review role permissions and access

## Advantages of Git-based Approach

### For Your AIX Management Project:

1. **Simplified Deployment**
   - Single Git repository contains everything
   - AAP automatically discovers and uses roles
   - No separate role distribution mechanism

2. **Version Management**
   - Git branches for different environments
   - Tags for stable releases
   - Easy rollback capabilities

3. **Team Collaboration**
   - Standard Git workflow for changes
   - Code review process
   - Change tracking and approval

4. **Maintenance**
   - Direct editing in Git repository
   - Immediate availability after sync
   - No republishing required

5. **Enterprise Integration**
   - Works with corporate Git systems
   - Integrates with existing CI/CD pipelines
   - Supports enterprise security models

## Alternative: Automation Hub (When to Consider)

Consider Automation Hub distribution if:

- [ ] Roles will be shared across multiple organizations
- [ ] You need formal collection versioning
- [ ] Roles are general-purpose (not AIX-specific)
- [ ] You want to publish to Red Hat Automation Hub
- [ ] Multiple AAP instances need the same roles

For your AIX Management use case, Git-based distribution is optimal.

## Validation Checklist

- [ ] All role directories exist in `roles/`
- [ ] Each role has required files (tasks/main.yml, defaults/main.yml, meta/main.yml)
- [ ] Role names match between directories and playbook references
- [ ] ansible.cfg specifies correct roles_path
- [ ] requirements.yml contains only external collections
- [ ] Playbooks reference roles correctly
- [ ] Local testing shows role tasks loading
- [ ] AAP project syncs without errors
- [ ] Test job templates execute successfully

Your current setup follows AAP 2.5 best practices for role distribution.