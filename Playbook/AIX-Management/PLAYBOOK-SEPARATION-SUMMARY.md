# AIX Management Playbook Separation Summary

## Overview

The AIX management system has been successfully restructured from a monolithic approach to a workflow-orchestrated architecture. This separation provides better control, visibility, and approval gates for resource management operations.

## Architecture Changes

### Before: Monolithic Approach
```
aix_complete_monitoring.yml
├── Filesystem Management
├── CPU Management  
├── Memory Management
├── Print Queue Management
└── Service Monitoring
```

### After: Workflow-Orchestrated Approach
```
Threshold Checks (Step 1)
├── aix_filesystem_threshold_check.yml
├── aix_cpu_threshold_check.yml
└── aix_memory_threshold_check.yml

Expansion/Scaling (Step 2) 
├── aix_filesystem_expansion.yml
├── aix_cpu_scaling.yml
└── aix_memory_scaling.yml

Existing Management (Unchanged)
├── aix_print_queue_management.yml
└── aix_service_monitoring.yml
```

## New Playbooks Created

### Threshold Check Playbooks

#### 1. aix_filesystem_threshold_check.yml
- **Purpose**: Monitors filesystem usage against predefined thresholds
- **Key Features**:
  - Configurable thresholds per filesystem (/, /var, /tmp, /home, /opt)
  - Custom filesystem support via survey
  - Sets workflow variables for AAP orchestration
  - Detailed logging and reporting
  - Email alerting when thresholds exceeded

- **Workflow Variables Set**:
  - `filesystem_expansion_needed`: YES/NO
  - `filesystem_expansion_list`: Filesystems requiring expansion
  - `filesystem_total_checked`: Number of filesystems monitored
  - `filesystem_exceeding_count`: Count of filesystems over threshold

#### 2. aix_cpu_threshold_check.yml
- **Purpose**: Monitors CPU load and utilization against thresholds
- **Key Features**:
  - Load average monitoring (15-minute average for stability)
  - CPU utilization sampling over configurable duration
  - LPAR CPU configuration validation
  - HMC connectivity pre-check
  - Automatic CPU scaling recommendations

- **Workflow Variables Set**:
  - `cpu_scaling_needed`: YES/NO
  - `cpu_current_count`: Current virtual CPU count
  - `cpu_recommended_count`: Recommended CPU count
  - `cpu_scale_increment`: Number of CPUs to add

#### 3. aix_memory_threshold_check.yml  
- **Purpose**: Monitors memory and paging space usage
- **Key Features**:
  - Paging space usage monitoring
  - Real memory utilization tracking
  - Multiple memory detection methods (svmon, prtconf, lparstat)
  - Memory scaling recommendations
  - Safety limits enforcement

- **Workflow Variables Set**:
  - `memory_scaling_needed`: YES/NO
  - `memory_current_mb`: Current memory in MB
  - `memory_recommended_mb`: Recommended memory
  - `memory_scale_increment_mb`: Memory to add

### Expansion/Scaling Playbooks

#### 1. aix_filesystem_expansion.yml
- **Purpose**: Expands filesystems when thresholds are exceeded
- **Key Features**:
  - Processes multiple filesystems from workflow variables
  - Volume group free space validation
  - Pre-expansion backup metadata creation
  - Safety limits (max expansion per filesystem)
  - Simulation mode for testing
  - Post-expansion verification

- **Modes**:
  - `auto`: Automatic expansion without approval
  - `manual`: Manual confirmation required
  - `simulation`: Test mode - no actual changes

#### 2. aix_cpu_scaling.yml
- **Purpose**: Scales virtual CPUs via HMC integration
- **Key Features**:
  - HMC connectivity and authentication
  - LPAR CPU configuration validation
  - Dynamic virtual CPU scaling
  - Post-scaling verification
  - Safety limits and validation
  - Comprehensive error handling

- **HMC Integration**:
  - SSH key or password authentication
  - Commands: `chhwres -r proc -m <system> -o s -p <lpar>`
  - Real-time scaling with minimal downtime

#### 3. aix_memory_scaling.yml
- **Purpose**: Scales LPAR memory via HMC integration  
- **Key Features**:
  - Dynamic memory allocation
  - HMC-based memory scaling
  - Multi-method memory detection
  - Paging space status monitoring
  - Memory scaling verification
  - Safety limits enforcement

- **HMC Integration**:
  - Commands: `chhwres -r mem -m <system> -o s -p <lpar>`
  - Immediate memory availability
  - Verification from both HMC and LPAR perspectives

## Workflow Integration Features

### Set Stats Variables
All threshold check playbooks use `set_stats` to pass data to subsequent workflow jobs:

```yaml
- name: Set AAP workflow variables
  ansible.builtin.set_stats:
    data:
      expansion_needed: "{{ expansion_required }}"
      expansion_details: "{{ expansion_data }}"
    aggregate: false
```

### Variable Inheritance
Expansion/scaling playbooks receive configuration from threshold checks:

```yaml
vars:
  filesystems_to_expand: "{{ filesystem_expansion_list | default('') }}"
  current_cpu_count: "{{ cpu_current_count | default(0) }}"
  recommended_memory_mb: "{{ memory_recommended_mb | default(0) }}"
```

### Conditional Execution
Workflow nodes can use conditions based on threshold results:

```yaml
conditions: "{{ filesystem_expansion_needed == 'YES' and auto_scaling_enabled == 'true' }}"
```

## Safety and Control Features

### Threshold Configuration
- Filesystem: 85% usage (configurable per filesystem)
- CPU Load: 5.0 load average (configurable)
- CPU Utilization: 85% (configurable with sampling)
- Memory: 85% real memory, 10% paging space

### Safety Limits
- Filesystem: Max 50GB expansion per filesystem per run
- CPU: Max 32 virtual CPUs total
- Memory: Max 64GB memory total
- All limits configurable via survey/variables

### Operational Modes
- **Simulation**: Test mode, no actual changes
- **Auto**: Automatic scaling without approval
- **Manual**: Human approval required

### Approval Gates
- Manual approval workflow nodes
- Change ticket integration
- Email notifications for approval requests
- Audit trail maintenance

## Migration Benefits

### 1. Better Control
- Separate threshold monitoring from resource changes
- Approval gates for production environments
- Granular control over which resources to scale

### 2. Improved Visibility
- Dedicated logs for each operation phase
- Workflow visualization in AAP
- Clear separation of concerns

### 3. Enhanced Safety
- Simulation mode for testing
- Safety limits on all scaling operations
- Validation at each step

### 4. Operational Flexibility
- Schedule threshold checks independently
- Manual override capabilities
- Emergency scaling procedures

### 5. Compliance
- Change ticket integration
- Audit trails for all operations
- Approval workflows for governance

## Usage Scenarios

### Scenario 1: Daily Monitoring
```yaml
Schedule: Daily at 6 AM
Workflow: AIX-Complete-Resource-Monitoring
Mode: simulation
Auto-scaling: false
Purpose: Monitor and alert only
```

### Scenario 2: Emergency Scaling
```yaml
Schedule: Every 4 hours
Workflow: AIX-Critical-Resource-Monitoring  
Mode: auto
Auto-scaling: true
Target: critical-aix hosts
Purpose: Immediate scaling for critical systems
```

### Scenario 3: Planned Maintenance
```yaml
Trigger: Manual
Workflow: AIX-Resource-Scaling-With-Approval
Mode: manual
Auto-scaling: false
Purpose: Pre-approved scaling with change control
```

## File Structure

```
Playbook/AIX-Management/
├── playbooks/
│   ├── Threshold Checks/
│   │   ├── aix_filesystem_threshold_check.yml
│   │   ├── aix_cpu_threshold_check.yml
│   │   └── aix_memory_threshold_check.yml
│   ├── Expansion-Scaling/
│   │   ├── aix_filesystem_expansion.yml
│   │   ├── aix_cpu_scaling.yml
│   │   └── aix_memory_scaling.yml
│   └── Existing/
│       ├── aix_complete_monitoring.yml (updated)
│       ├── aix_filesystem_management.yml
│       ├── aix_cpu_management.yml
│       ├── aix_memory_management.yml
│       ├── aix_print_queue_management.yml
│       └── aix_service_monitoring.yml
└── Documentation/
    ├── AAP-WORKFLOW-ORCHESTRATION-GUIDE.md
    └── PLAYBOOK-SEPARATION-SUMMARY.md (this file)
```

## Next Steps

### Immediate Actions
1. **Test Threshold Playbooks**: Run in simulation mode
2. **Configure HMC Access**: Set up credentials and SSH keys
3. **Create AAP Job Templates**: For all new playbooks
4. **Design Workflows**: Based on organizational requirements
5. **Configure Surveys**: For threshold and scaling parameters

### Phase 1 Deployment
1. Deploy threshold check playbooks in monitoring-only mode
2. Validate threshold accuracy and adjust as needed
3. Test workflow variable passing
4. Configure email alerting

### Phase 2 Deployment  
1. Enable simulation mode for expansion/scaling playbooks
2. Test HMC integration thoroughly
3. Validate scaling operations in simulation
4. Create approval workflows

### Phase 3 Production
1. Enable automatic scaling for non-critical systems
2. Implement approval gates for critical systems
3. Configure scheduled monitoring
4. Establish operational procedures

## Monitoring and Maintenance

### Log Management
- All logs stored in `/bigc/log/` on target systems
- Timestamped filenames for easy identification
- Automatic cleanup via separate playbook (recommended)

### Threshold Tuning
- Review threshold breach frequency
- Adjust thresholds based on business requirements
- Monitor false positive rates
- Document threshold change decisions

### Capacity Planning
- Use threshold data for capacity forecasting
- Track scaling frequency and patterns
- Plan for long-term capacity needs
- Regular review of safety limits

## Conclusion

The separation of AIX management into workflow-orchestrated components provides significantly better control, safety, and visibility compared to the monolithic approach. The new architecture supports both automated and manual scaling scenarios while maintaining comprehensive logging and audit capabilities.

Key success factors:
- Proper HMC integration and credential management
- Appropriate threshold configuration for each environment  
- Thorough testing in simulation mode
- Clear operational procedures and approval processes
- Regular monitoring and threshold adjustment

This architecture positions the AIX management system for scalable, reliable, and compliant infrastructure automation.