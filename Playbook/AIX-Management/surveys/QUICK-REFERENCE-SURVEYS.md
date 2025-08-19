# Quick Reference: Survey Field Values for Copy-Paste

This document provides a condensed format for quickly copying survey field values directly into AAP. Each section corresponds to one survey question.

## Usage Instructions

1. Open your Job Template in AAP
2. Go to Survey tab and enable survey
3. Click "Add" for each question
4. Copy the values from each section below into the corresponding AAP fields
5. Save the survey

---

## 1. AIX Filesystem Management Survey

### Question 1
```
Question: Select target AIX hosts or groups:
Variable: target_hosts
Type: Multiple Choice (single select)
Default: aix
Required: YES
Choices:
aix
production
staging
development
all
```

### Question 2
```
Question: Filesystem usage threshold percentage (will override defaults):
Variable: filesystem_threshold
Type: Integer
Default: 85
Required: NO
Min: 50
Max: 95
```

### Question 3
```
Question: Reason for this operation:
Variable: change_reason
Type: Text
Default: Automated filesystem monitoring and expansion
Required: YES
```

### Question 4
```
Question: Change ticket number (if applicable):
Variable: change_ticket
Type: Text
Default: (empty)
Required: NO
```

### Question 5
```
Question: Enable debug logging?
Variable: enable_debug
Type: Boolean
Default: False
Required: NO
```

---

## 2. AIX CPU Management Survey

### Question 1
```
Question: Select target AIX hosts or groups:
Variable: target_hosts
Type: Multiple Choice (single select)
Default: aix
Required: YES
Choices:
aix
production
staging
development
all
```

### Question 2
```
Question: CPU load average threshold:
Variable: cpu_load_threshold
Type: Float
Default: 5.0
Required: NO
Min: 1.0
Max: 20.0
```

### Question 3
```
Question: Enable automatic CPU scaling via HMC?
Variable: cpu_auto_scaling_enabled
Type: Boolean
Default: True
Required: NO
```

### Question 4
```
Question: Number of virtual CPUs to add when scaling:
Variable: cpu_increment_count
Type: Integer
Default: 1
Required: NO
Min: 1
Max: 4
```

### Question 5
```
Question: Reason for this operation:
Variable: change_reason
Type: Text
Default: Automated CPU monitoring and scaling
Required: YES
```

### Question 6
```
Question: Change ticket number (if applicable):
Variable: change_ticket
Type: Text
Default: (empty)
Required: NO
```

### Question 7
```
Question: Enable debug logging?
Variable: enable_debug
Type: Boolean
Default: False
Required: NO
```

---

## 3. AIX Memory Management Survey

### Question 1
```
Question: Select target AIX hosts or groups:
Variable: target_hosts
Type: Multiple Choice (single select)
Default: aix
Required: YES
Choices:
aix
production
staging
development
all
```

### Question 2
```
Question: Paging space usage threshold percentage:
Variable: memory_threshold
Type: Integer
Default: 10
Required: NO
Min: 5
Max: 50
```

### Question 3
```
Question: Memory increment in MB when scaling:
Variable: memory_increment
Type: Integer
Default: 512
Required: NO
Min: 256
Max: 2048
```

### Question 4
```
Question: Enable automatic memory scaling via HMC?
Variable: memory_auto_scaling_enabled
Type: Boolean
Default: True
Required: NO
```

### Question 5
```
Question: Reason for this operation:
Variable: change_reason
Type: Text
Default: Automated memory monitoring and scaling
Required: YES
```

### Question 6
```
Question: Change ticket number (if applicable):
Variable: change_ticket
Type: Text
Default: (empty)
Required: NO
```

### Question 7
```
Question: Enable debug logging?
Variable: enable_debug
Type: Boolean
Default: False
Required: NO
```

---

## 4. AIX Print Queue Management Survey

### Question 1
```
Question: Select target AIX hosts or groups:
Variable: target_hosts
Type: Multiple Choice (single select)
Default: aix
Required: YES
Choices:
aix
production
staging
development
all
```

### Question 2
```
Question: Print queues to monitor (comma-separated, leave blank for defaults):
Variable: print_queues
Type: Text
Default: lpbg5,lpbg6,lpbg1
Required: NO
```

### Question 3
```
Question: Enable print queue monitoring?
Variable: print_queue_monitoring_enabled
Type: Boolean
Default: True
Required: NO
```

### Question 4
```
Question: Enable spooler service monitoring?
Variable: spooler_monitoring_enabled
Type: Boolean
Default: True
Required: NO
```

### Question 5
```
Question: Enable automatic restart of failed services?
Variable: auto_restart_enabled
Type: Boolean
Default: True
Required: NO
```

### Question 6
```
Question: Reason for this operation:
Variable: change_reason
Type: Text
Default: Automated print queue monitoring and restart
Required: YES
```

### Question 7
```
Question: Change ticket number (if applicable):
Variable: change_ticket
Type: Text
Default: (empty)
Required: NO
```

### Question 8
```
Question: Enable debug logging?
Variable: enable_debug
Type: Boolean
Default: False
Required: NO
```

---

## 5. AIX Service Monitoring Survey

### Question 1
```
Question: Select target AIX hosts or groups:
Variable: target_hosts
Type: Multiple Choice (single select)
Default: aix
Required: YES
Choices:
aix
production
staging
development
all
```

### Question 2
```
Question: Enable service monitoring?
Variable: service_monitoring_enabled
Type: Boolean
Default: True
Required: NO
```

### Question 3
```
Question: Enable automatic restart of failed services?
Variable: auto_restart_enabled
Type: Boolean
Default: True
Required: NO
```

### Question 4
```
Question: Enable Zabbix agent monitoring?
Variable: zabbix_monitoring_enabled
Type: Boolean
Default: True
Required: NO
```

### Question 5
```
Question: Reason for this operation:
Variable: change_reason
Type: Text
Default: Automated service monitoring and restart
Required: YES
```

### Question 6
```
Question: Change ticket number (if applicable):
Variable: change_ticket
Type: Text
Default: (empty)
Required: NO
```

### Question 7
```
Question: Enable debug logging?
Variable: enable_debug
Type: Boolean
Default: False
Required: NO
```

---

## 6. AIX Complete Monitoring Survey

### Question 1
```
Question: Select target AIX hosts or groups:
Variable: target_hosts
Type: Multiple Choice (single select)
Default: aix
Required: YES
Choices:
aix
production
staging
development
all
```

### Question 2
```
Question: Number of hosts to process in parallel:
Variable: batch_size
Type: Integer
Default: 1
Required: NO
Min: 1
Max: 10
```

### Question 3
```
Question: Enable filesystem monitoring and auto-expansion?
Variable: filesystem_monitoring
Type: Boolean
Default: True
Required: NO
```

### Question 4
```
Question: Enable CPU monitoring and auto-scaling?
Variable: cpu_monitoring
Type: Boolean
Default: True
Required: NO
```

### Question 5
```
Question: Enable memory monitoring and auto-scaling?
Variable: memory_monitoring
Type: Boolean
Default: True
Required: NO
```

### Question 6
```
Question: Enable print queue monitoring and auto-restart?
Variable: print_queue_monitoring
Type: Boolean
Default: True
Required: NO
```

### Question 7
```
Question: Enable service monitoring (Zabbix, etc.)?
Variable: service_monitoring
Type: Boolean
Default: True
Required: NO
```

### Question 8
```
Question: Send completion notification email?
Variable: send_completion_email
Type: Boolean
Default: False
Required: NO
```

### Question 9
```
Question: Reason for this operation:
Variable: change_reason
Type: Text
Default: Comprehensive AIX system monitoring and management
Required: YES
```

### Question 10
```
Question: Change ticket number (if applicable):
Variable: change_ticket
Type: Text
Default: (empty)
Required: NO
```

### Question 11
```
Question: Enable debug logging?
Variable: enable_debug
Type: Boolean
Default: False
Required: NO
```