# AIX Management Workflow Orchestration Guide

## Overview

This guide explains how to set up Ansible Automation Platform (AAP) 2.5 workflows for AIX management using the separated threshold check and expansion/scaling playbooks. The workflow-based approach provides better control, visibility, and approval gates for resource scaling operations.

## Architecture

### Workflow Components

```mermaid
graph TD
    A[Threshold Check Jobs] --> B{Thresholds Exceeded?}
    B -->|NO| C[Complete - No Action]
    B -->|YES| D[Alert Notifications]
    D --> E[Approval Gate]
    E --> F[Expansion/Scaling Jobs]
    F --> G[Completion Notifications]
    
    subgraph "Threshold Checks"
        H[Filesystem Check]
        I[CPU Check]
        J[Memory Check]
    end
    
    subgraph "Expansion/Scaling"
        K[Filesystem Expansion]
        L[CPU Scaling]
        M[Memory Scaling]
    end
```

## Playbook Structure

### Threshold Check Playbooks
- **aix_filesystem_threshold_check.yml** - Monitors filesystem usage against thresholds
- **aix_cpu_threshold_check.yml** - Monitors CPU load and utilization
- **aix_memory_threshold_check.yml** - Monitors memory and paging space usage

### Expansion/Scaling Playbooks
- **aix_filesystem_expansion.yml** - Expands filesystems when thresholds exceeded
- **aix_cpu_scaling.yml** - Adds virtual CPUs via HMC
- **aix_memory_scaling.yml** - Increases memory allocation via HMC

## AAP Workflow Setup

### Step 1: Create Job Templates

#### 1.1 Threshold Check Job Templates

**Filesystem Threshold Check**
```yaml
Name: AIX-Filesystem-Threshold-Check
Project: AIX-Management
Playbook: playbooks/aix_filesystem_threshold_check.yml
Inventory: AIX-Servers
Credentials: AIX-SSH-Key
Survey: Yes
```

**CPU Threshold Check**
```yaml
Name: AIX-CPU-Threshold-Check
Project: AIX-Management
Playbook: playbooks/aix_cpu_threshold_check.yml
Inventory: AIX-Servers
Credentials: AIX-SSH-Key
Survey: Yes
```

**Memory Threshold Check**
```yaml
Name: AIX-Memory-Threshold-Check
Project: AIX-Management
Playbook: playbooks/aix_memory_threshold_check.yml
Inventory: AIX-Servers
Credentials: AIX-SSH-Key
Survey: Yes
```

#### 1.2 Expansion/Scaling Job Templates

**Filesystem Expansion**
```yaml
Name: AIX-Filesystem-Expansion
Project: AIX-Management
Playbook: playbooks/aix_filesystem_expansion.yml
Inventory: AIX-Servers
Credentials: AIX-SSH-Key
Survey: Yes
Ask Variables on Launch: Yes
```

**CPU Scaling**
```yaml
Name: AIX-CPU-Scaling
Project: AIX-Management
Playbook: playbooks/aix_cpu_scaling.yml
Inventory: AIX-Servers
Credentials: AIX-SSH-Key, HMC-Credentials
Survey: Yes
Ask Variables on Launch: Yes
```

**Memory Scaling**
```yaml
Name: AIX-Memory-Scaling
Project: AIX-Management
Playbook: playbooks/aix_memory_scaling.yml
Inventory: AIX-Servers
Credentials: AIX-SSH-Key, HMC-Credentials
Survey: Yes
Ask Variables on Launch: Yes
```

### Step 2: Create Survey Specifications

#### 2.1 Filesystem Threshold Check Survey
```yaml
survey_spec:
  - question_name: "Target Hosts"
    variable: "target_hosts"
    type: "text"
    default: "aix"
    required: true
  - question_name: "Root FS Threshold (%)"
    variable: "root_fs_threshold"
    type: "integer"
    default: 85
    min: 50
    max: 95
  - question_name: "Var FS Threshold (%)"
    variable: "var_fs_threshold"
    type: "integer"
    default: 85
    min: 50
    max: 95
  - question_name: "Home FS Threshold (%)"
    variable: "home_fs_threshold"
    type: "integer"
    default: 85
    min: 50
    max: 95
  - question_name: "Send Threshold Alerts"
    variable: "send_threshold_alerts"
    type: "multiplechoice"
    choices: ["true", "false"]
    default: "true"
  - question_name: "Alert Email Recipients"
    variable: "alert_emails"
    type: "textarea"
    default: "admin@example.com"
    required: false
```

#### 2.2 CPU Threshold Check Survey
```yaml
survey_spec:
  - question_name: "Target Hosts"
    variable: "target_hosts"
    type: "text"
    default: "aix"
    required: true
  - question_name: "CPU Load Threshold"
    variable: "cpu_threshold"
    type: "float"
    default: 5.0
    min: 1.0
    max: 10.0
  - question_name: "CPU Utilization Threshold (%)"
    variable: "cpu_util_threshold"
    type: "integer"
    default: 85
    min: 50
    max: 95
  - question_name: "Monitoring Duration (minutes)"
    variable: "monitoring_duration_minutes"
    type: "integer"
    default: 5
    min: 1
    max: 30
  - question_name: "CPUs to Add"
    variable: "cpu_add_count"
    type: "integer"
    default: 1
    min: 1
    max: 4
  - question_name: "HMC Server"
    variable: "hmc_server"
    type: "text"
    required: false
  - question_name: "Target LPAR Name"
    variable: "target_lpar_name"
    type: "text"
    required: false
```

#### 2.3 Memory Threshold Check Survey
```yaml
survey_spec:
  - question_name: "Target Hosts"
    variable: "target_hosts"
    type: "text"
    default: "aix"
    required: true
  - question_name: "Paging Space Threshold (%)"
    variable: "paging_threshold"
    type: "integer"
    default: 10
    min: 5
    max: 50
  - question_name: "Real Memory Threshold (%)"
    variable: "memory_threshold"
    type: "integer"
    default: 85
    min: 70
    max: 95
  - question_name: "Memory to Add (MB)"
    variable: "memory_add_mb"
    type: "integer"
    default: 512
    min: 256
    max: 2048
  - question_name: "HMC Server"
    variable: "hmc_server"
    type: "text"
    required: false
  - question_name: "Target LPAR Name"
    variable: "target_lpar_name"
    type: "text"
    required: false
```

### Step 3: Create Workflow Templates

#### 3.1 Complete AIX Resource Monitoring Workflow

**Workflow Template: AIX-Complete-Resource-Monitoring**

```yaml
name: AIX-Complete-Resource-Monitoring
description: Comprehensive AIX resource monitoring with automatic scaling
organization: Default
survey_enabled: true
ask_variables_on_launch: true
```

**Workflow Survey:**
```yaml
survey_spec:
  - question_name: "Target AIX Hosts"
    variable: "target_hosts"
    type: "text"
    default: "aix"
    required: true
  - question_name: "Enable Filesystem Monitoring"
    variable: "enable_filesystem_check"
    type: "multiplechoice"
    choices: ["true", "false"]
    default: "true"
  - question_name: "Enable CPU Monitoring"
    variable: "enable_cpu_check"
    type: "multiplechoice"
    choices: ["true", "false"]
    default: "true"
  - question_name: "Enable Memory Monitoring"
    variable: "enable_memory_check"
    type: "multiplechoice"
    choices: ["true", "false"]
    default: "true"
  - question_name: "Automatic Expansion/Scaling"
    variable: "auto_scaling_enabled"
    type: "multiplechoice"
    choices: ["true", "false"]
    default: "false"
  - question_name: "Scaling Mode"
    variable: "scaling_mode"
    type: "multiplechoice"
    choices: ["simulation", "auto", "manual"]
    default: "simulation"
  - question_name: "Change Ticket Number"
    variable: "change_ticket"
    type: "text"
    required: false
  - question_name: "Change Reason"
    variable: "change_reason"
    type: "text"
    default: "Automated resource monitoring and scaling"
```

#### 3.2 Workflow Node Configuration

**Node 1: Parallel Threshold Checks**
```yaml
- name: filesystem-threshold-check
  job_template: AIX-Filesystem-Threshold-Check
  success_nodes: [check-filesystem-results]
  failure_nodes: [send-failure-notification]
  
- name: cpu-threshold-check
  job_template: AIX-CPU-Threshold-Check
  success_nodes: [check-cpu-results]
  failure_nodes: [send-failure-notification]
  
- name: memory-threshold-check
  job_template: AIX-Memory-Threshold-Check
  success_nodes: [check-memory-results]
  failure_nodes: [send-failure-notification]
```

**Node 2: Conditional Result Checks**
```yaml
- name: check-filesystem-results
  job_template: null
  workflow_job_template: null
  unified_job_template: null
  always_nodes: []
  success_nodes: [filesystem-expansion]
  failure_nodes: []
  conditions: "{{ filesystem_expansion_needed == 'YES' and auto_scaling_enabled == 'true' }}"

- name: check-cpu-results
  conditions: "{{ cpu_scaling_needed == 'YES' and auto_scaling_enabled == 'true' }}"
  success_nodes: [cpu-scaling]
  
- name: check-memory-results
  conditions: "{{ memory_scaling_needed == 'YES' and auto_scaling_enabled == 'true' }}"
  success_nodes: [memory-scaling]
```

**Node 3: Conditional Expansion/Scaling**
```yaml
- name: filesystem-expansion
  job_template: AIX-Filesystem-Expansion
  extra_vars:
    filesystems_to_expand: "{{ filesystem_expansion_list }}"
    expansion_mode: "{{ scaling_mode }}"
    change_ticket: "{{ change_ticket }}"
    change_reason: "{{ change_reason }}"
  success_nodes: [send-completion-notification]
  failure_nodes: [send-failure-notification]

- name: cpu-scaling
  job_template: AIX-CPU-Scaling
  extra_vars:
    current_cpu_count: "{{ cpu_current_count }}"
    recommended_cpu_count: "{{ cpu_recommended_count }}"
    scaling_mode: "{{ scaling_mode }}"
    change_ticket: "{{ change_ticket }}"
    change_reason: "{{ change_reason }}"
  success_nodes: [send-completion-notification]
  failure_nodes: [send-failure-notification]

- name: memory-scaling
  job_template: AIX-Memory-Scaling
  extra_vars:
    current_memory_mb: "{{ memory_current_mb }}"
    recommended_memory_mb: "{{ memory_recommended_mb }}"
    scaling_mode: "{{ scaling_mode }}"
    change_ticket: "{{ change_ticket }}"
    change_reason: "{{ change_reason }}"
  success_nodes: [send-completion-notification]
  failure_nodes: [send-failure-notification]
```

### Step 4: Approval Gate Workflows

For production environments, create approval gate workflows:

#### 4.1 Manual Approval Workflow

**Workflow Template: AIX-Resource-Scaling-With-Approval**

```yaml
- name: threshold-checks
  # ... same as above
  success_nodes: [approval-gate]

- name: approval-gate
  job_template: Manual-Approval-Job
  success_nodes: [scaling-operations]
  failure_nodes: [cancelled-notification]

- name: scaling-operations
  # ... expansion/scaling jobs
```

### Step 5: Scheduling and Automation

#### 5.1 Scheduled Monitoring

Create scheduled jobs for regular monitoring:

```yaml
schedule:
  name: Daily-AIX-Resource-Monitoring
  rrule: "DTSTART:20241201T060000Z RRULE:FREQ=DAILY;INTERVAL=1"
  workflow_job_template: AIX-Complete-Resource-Monitoring
  extra_data:
    target_hosts: "production-aix"
    scaling_mode: "simulation"
    auto_scaling_enabled: "false"
```

#### 5.2 Emergency Scaling Schedule

```yaml
schedule:
  name: Emergency-AIX-Scaling-Check
  rrule: "DTSTART:20241201T000000Z RRULE:FREQ=HOURLY;INTERVAL=4"
  workflow_job_template: AIX-Complete-Resource-Monitoring
  extra_data:
    target_hosts: "critical-aix"
    scaling_mode: "auto"
    auto_scaling_enabled: "true"
```

## Workflow Variables and Data Flow

### Set Stats Variables

Each threshold check playbook sets workflow variables using `set_stats`:

**Filesystem Threshold Check:**
- `filesystem_expansion_needed`: YES/NO
- `filesystem_expansion_list`: Comma-separated list of filesystems to expand
- `filesystem_total_checked`: Number of filesystems checked
- `filesystem_exceeding_count`: Number exceeding thresholds

**CPU Threshold Check:**
- `cpu_scaling_needed`: YES/NO
- `cpu_current_count`: Current virtual CPU count
- `cpu_recommended_count`: Recommended CPU count after scaling
- `cpu_scale_increment`: Number of CPUs to add

**Memory Threshold Check:**
- `memory_scaling_needed`: YES/NO
- `memory_current_mb`: Current memory in MB
- `memory_recommended_mb`: Recommended memory after scaling
- `memory_scale_increment_mb`: Memory to add in MB

### Variable Inheritance

Expansion/scaling playbooks receive variables from threshold checks:

```yaml
extra_vars:
  # From filesystem threshold check
  filesystems_to_expand: "{{ filesystem_expansion_list }}"
  
  # From CPU threshold check  
  current_cpu_count: "{{ cpu_current_count }}"
  recommended_cpu_count: "{{ cpu_recommended_count }}"
  
  # From memory threshold check
  current_memory_mb: "{{ memory_current_mb }}"
  recommended_memory_mb: "{{ memory_recommended_mb }}"
```

## HMC Integration

### Prerequisites

1. **HMC Credentials**: Create AAP credentials for HMC access
2. **SSH Key Authentication**: Recommended over password authentication
3. **HMC User Privileges**: Ensure user has LPAR modification privileges

### HMC Credential Setup

```yaml
name: HMC-SSH-Credential
credential_type: Machine
inputs:
  username: hscroot
  ssh_key_data: |
    -----BEGIN RSA PRIVATE KEY-----
    [HMC SSH private key content]
    -----END RSA PRIVATE KEY-----
```

### LPAR Configuration Variables

Set these in group_vars or survey:

```yaml
# HMC Configuration
hmc_server: "hmc.example.com"
hmc_username: "hscroot"
hmc_managed_system: "System-9009-42A-SN1234567"

# LPAR Mapping
lpar_mappings:
  aixserver1: "LPAR-AIX-001"
  aixserver2: "LPAR-AIX-002"
```

## Monitoring and Alerting

### Log File Locations

All playbooks generate detailed logs in `/bigc/log/` on target systems:

- `filesystem_threshold_check_<hostname>_<timestamp>.log`
- `cpu_threshold_check_<hostname>_<timestamp>.log`
- `memory_threshold_check_<hostname>_<timestamp>.log`
- `filesystem_expansion_<hostname>_<timestamp>.log`
- `cpu_scaling_<hostname>_<timestamp>.log`
- `memory_scaling_<hostname>_<timestamp>.log`

### Email Notifications

Configure SMTP settings in group_vars:

```yaml
# Email Configuration
smtp_host: "smtp.example.com"
smtp_port: 587
smtp_user: "ansible@example.com"
smtp_pass: "{{ vault_smtp_password }}"
alert_emails:
  - "admin@example.com"
  - "ops-team@example.com"
```

### AAP Job Notifications

Configure AAP notifications for workflow events:

```yaml
notification_templates:
  - name: Threshold-Alert-Email
    notification_type: email
    messages:
      started: "AIX threshold monitoring started"
      success: "AIX monitoring completed - no thresholds exceeded"
      error: "AIX monitoring failed"
      workflow_approval: "AIX resource scaling requires approval"
```

## Testing and Validation

### Simulation Mode Testing

Always test with simulation mode first:

```yaml
extra_vars:
  scaling_mode: "simulation"
  expansion_mode: "simulation"
```

### Gradual Rollout

1. **Development Environment**: Full automation enabled
2. **Staging Environment**: Manual approval required
3. **Production Environment**: High thresholds, approval gates

### Validation Checklist

- [ ] Threshold check playbooks execute without errors
- [ ] Workflow variables are correctly passed between jobs
- [ ] HMC connectivity and authentication work
- [ ] Email notifications are sent correctly
- [ ] Log files are created with proper permissions
- [ ] Expansion/scaling operations work in simulation mode
- [ ] Approval gates function correctly
- [ ] Rollback procedures are documented

## Security Considerations

### Credential Management

- Use AAP credential types for all sensitive data
- Rotate HMC credentials regularly
- Use SSH key authentication for HMC access
- Encrypt sensitive group_vars with ansible-vault

### Change Management

- Require change tickets for all production scaling
- Implement approval workflows for critical systems
- Maintain audit trails of all scaling operations
- Set reasonable safety limits for scaling operations

### Access Control

- Limit workflow execution to authorized users
- Use RBAC to control access to different environments
- Separate credentials for different security zones
- Monitor and log all workflow executions

## Troubleshooting

### Common Issues

1. **HMC Connectivity**: Check SSH keys and network access
2. **LPAR Not Found**: Verify LPAR names and managed system
3. **Insufficient Permissions**: Check HMC user privileges
4. **Threshold False Positives**: Adjust threshold values
5. **Workflow Variable Issues**: Check set_stats output

### Debug Mode

Enable verbose logging:

```yaml
extra_vars:
  ansible_verbosity: 2
  debug_mode: true
```

### Log Analysis

Key log entries to check:
- Threshold comparison results
- HMC command execution output
- Resource scaling verification
- Error messages and stack traces

## Best Practices

1. **Start with Simulation**: Always test in simulation mode
2. **Gradual Thresholds**: Start with conservative thresholds
3. **Regular Reviews**: Review and adjust thresholds based on patterns
4. **Documentation**: Keep runbooks updated with procedures
5. **Monitoring**: Monitor the monitors - ensure threshold checks run successfully
6. **Capacity Planning**: Use data to plan long-term capacity needs
7. **Emergency Procedures**: Have manual scaling procedures documented

This comprehensive workflow approach provides better control, visibility, and safety for AIX resource management while maintaining automation benefits.