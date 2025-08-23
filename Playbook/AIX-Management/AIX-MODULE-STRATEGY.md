# AIX Module Strategy: Native Modules vs Shell Commands

This document explains our hybrid approach for AIX management, using dedicated Ansible modules where available and falling back to shell commands where necessary.

## Overview

The AIX Management playbooks use a **hybrid approach** that maximizes the benefits of both native Ansible modules and shell commands:

- **Native AIX modules** where available (reliable, idempotent, structured)
- **Shell commands** where no modules exist (direct AIX command access)
- **Fallback mechanisms** to ensure reliability

## Module Coverage Analysis

### ✅ Native Modules Available (IBM Power AIX Collection)

| Function | Original Command | Ansible Module | Benefits |
|----------|------------------|----------------|----------|
| **Filesystem Management** | `chfs -a size=+2G /var` | `ibm.power_aix.filesystem` | Idempotent, error handling, validation |
| **LPAR Information** | `lparstat -i` | `ibm.power_aix.lpar_facts` | Structured output, fact integration |
| **Service Management** | `lssrc/startsrc` | `ansible.builtin.service` | Cross-platform consistency |
| **System Facts** | `df`, `mount` | `ansible.builtin.setup` | Integrated with Ansible facts |

### ❌ Shell Commands Required (No Native Modules)

| Function | AIX Command | Reason | Implementation |
|----------|-------------|--------|----------------|
| **Paging Space** | `lsps -a` | No dedicated module | `ansible.builtin.shell` |
| **Print Queues** | `lpstat -t`, `enable/disable` | AIX-specific print management | `ansible.builtin.shell` |
| **HMC Operations** | `chhwres` | Hardware management console | `ansible.builtin.shell` |
| **System Config** | `prtconf` | Detailed system information | `ansible.builtin.shell` |

## Implementation Strategy

### 1. Primary Module with Fallback

```yaml
# Try native module first
- name: Increase filesystem size using IBM AIX filesystem module
  ibm.power_aix.filesystem:
    filesystem: "/var"
    attributes:
      size: "+1G"
    state: present
  register: filesystem_result
  failed_when: false

# Fallback to shell command if module fails
- name: Fallback to chfs command if filesystem module fails
  ansible.builtin.shell: |
    chfs -a size=+1G /var
  when: filesystem_result.failed | default(false)
```

### 2. Native Module with Shell Verification

```yaml
# Use native module for facts
- name: Gather LPAR facts using IBM AIX module
  ibm.power_aix.lpar_facts:
  register: lpar_info

# Fallback to shell for missing data
- name: Get CPU count using shell (fallback)
  ansible.builtin.shell: |
    lparstat -i | grep 'Online Virtual CPUs' | awk '{print $NF}'
  when: lpar_info.ansible_facts.lpar_info.online_virtual_cpus is not defined
```

### 3. Shell Commands with Structure

```yaml
# Structure shell output for better handling
- name: Check paging space usage
  ansible.builtin.shell: |
    lsps -a | tail -1 | awk '{print $5}' | sed 's/%//'
  register: paging_usage
  changed_when: false
  
- name: Convert to structured data
  ansible.builtin.set_fact:
    paging_space_usage: "{{ paging_usage.stdout | int }}"
```

## Collection Dependencies

### Updated requirements.yml

```yaml
collections:
  # IBM Power Systems AIX Collection - PRIMARY
  - name: ibm.power_aix
    version: ">=2.0.0"
    source: https://galaxy.ansible.com
  
  # Core collections for shell commands and basic functionality
  - name: ansible.posix
  - name: ansible.builtin
  - name: community.general
```

## Benefits of Hybrid Approach

### Native Modules Advantages

1. **Idempotency**: Only make changes when necessary
2. **Error Handling**: Structured error reporting
3. **Validation**: Parameter validation before execution
4. **Integration**: Work with Ansible facts and variables
5. **Documentation**: Self-documenting parameters

### Shell Commands Advantages

1. **Complete Coverage**: Access to all AIX commands
2. **Flexibility**: Use any command-line options
3. **Performance**: Direct command execution
4. **Familiarity**: Existing script knowledge transfers
5. **Complex Operations**: Multi-step command sequences

## Best Practices Implementation

### 1. Module Selection Priority

```yaml
# Priority order for implementation:
# 1. IBM Power AIX collection module
# 2. Core Ansible module (service, file, etc.)
# 3. Community module with AIX support
# 4. Shell command with structured output
# 5. Raw shell command (last resort)
```

### 2. Error Handling

```yaml
# Comprehensive error handling for both approaches
- name: Filesystem operation
  ibm.power_aix.filesystem:
    filesystem: "{{ item.filesystem }}"
    attributes:
      size: "+{{ increment }}M"
  register: fs_result
  failed_when: false
  
- name: Handle module errors gracefully
  ansible.builtin.fail:
    msg: "Filesystem operation failed: {{ fs_result.msg }}"
  when: 
    - fs_result.failed | default(false)
    - fail_on_error | default(true)
```

### 3. Consistent Output Format

```yaml
# Standardize output regardless of method used
- name: Set operation result
  ansible.builtin.set_fact:
    operation_result:
      changed: "{{ fs_result.changed | default(false) }}"
      success: "{{ not (fs_result.failed | default(false)) }}"
      message: "{{ fs_result.msg | default('Operation completed') }}"
      method: "{{ 'native_module' if not fs_result.failed else 'shell_command' }}"
```

## Migration Path

### Phase 1: Current Implementation ✅
- Use shell commands for all operations (maintains compatibility)
- Add IBM Power AIX collection
- Test native modules in development

### Phase 2: Hybrid Implementation ✅ 
- Implement native modules where available
- Keep shell fallbacks for reliability
- Document module coverage

### Phase 3: Future Optimization
- Monitor IBM collection updates for new modules
- Replace shell commands as modules become available
- Contribute to module development if needed

## Module-Specific Implementation Details

### Filesystem Management

```yaml
# Native module approach
- name: Manage filesystem with native module
  ibm.power_aix.filesystem:
    filesystem: "{{ filesystem_name }}"
    attributes:
      size: "+{{ increment_size }}M"
    state: present
  register: fs_native_result
  failed_when: false

# Shell fallback
- name: Manage filesystem with shell command
  ansible.builtin.shell: |
    chfs -a size=+{{ increment_size }}M {{ filesystem_name }}
  register: fs_shell_result
  when: fs_native_result.failed | default(false)
```

### CPU Management

```yaml
# LPAR facts from native module
- name: Get LPAR information
  ibm.power_aix.lpar_facts:
  register: lpar_facts

# CPU scaling via HMC (shell only)
- name: Scale CPU via HMC
  ansible.builtin.shell: |
    ssh {{ hmc_user }}@{{ hmc_host }} "chhwres -r proc -m {{ managed_system }} -o a -p {{ partition }} --procs {{ increment }}"
  register: hmc_result
```

### Service Management

```yaml
# Native service module (works with AIX SRC)
- name: Manage AIX services
  ansible.builtin.service:
    name: "{{ service_name }}"
    state: started
  register: service_result

# Print queue management (shell only)
- name: Manage print queues
  ansible.builtin.shell: |
    enable {{ printer_name }}
  register: printer_result
```

## Testing and Validation

### Module Availability Testing

```yaml
# Test if IBM collection is available
- name: Test IBM Power AIX collection availability
  ibm.power_aix.lpar_facts:
  register: collection_test
  failed_when: false
  
- name: Set module availability flag
  ansible.builtin.set_fact:
    ibm_aix_available: "{{ not (collection_test.failed | default(true)) }}"
```

### Performance Comparison

```yaml
# Time native module execution
- name: Time native module operation
  ansible.builtin.command: date +%s
  register: start_time

- name: Execute native module
  ibm.power_aix.filesystem:
    # ... module parameters
  
- name: Calculate execution time
  ansible.builtin.set_fact:
    native_execution_time: "{{ ansible_date_time.epoch | int - start_time.stdout | int }}"
```

## Future Roadmap

### Short Term (3-6 months)
- [ ] Complete testing of all IBM AIX modules
- [ ] Implement fallback mechanisms for all operations
- [ ] Performance benchmarking native vs shell

### Medium Term (6-12 months)
- [ ] Monitor IBM collection updates
- [ ] Contribute feedback to IBM collection maintainers
- [ ] Develop custom modules for missing functionality

### Long Term (12+ months)
- [ ] Evaluate creating organization-specific AIX collection
- [ ] Consider contributing modules back to community
- [ ] Full migration to native modules where possible

## Troubleshooting Module Issues

### Common Problems and Solutions

1. **Collection Not Found**
   ```yaml
   # Solution: Verify collection installation
   - name: Install IBM Power AIX collection
     community.general.ansible_galaxy_install:
       type: collection
       name: ibm.power_aix
   ```

2. **Module Import Errors**
   ```yaml
   # Solution: Use shell fallback
   - name: Check if module is available
     ansible.builtin.set_fact:
       use_shell_fallback: true
     when: ansible_collection_ibm_power_aix is not defined
   ```

3. **Permission Issues**
   ```yaml
   # Solution: Ensure proper privileges
   - name: Verify administrative access
     ansible.builtin.command: id
     register: user_check
     failed_when: "'root' not in user_check.stdout"
   ```

## Conclusion

This hybrid approach provides the best of both worlds:

- **Reliability**: Shell commands ensure all AIX functionality is accessible
- **Modern Practices**: Native modules where available for better Ansible integration
- **Future-Proof**: Easy migration path as more modules become available
- **Maintainability**: Consistent patterns across all roles

The strategy ensures that your AIX management playbooks are both immediately functional and positioned for future enhancements as the Ansible AIX ecosystem continues to evolve.