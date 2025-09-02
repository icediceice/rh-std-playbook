# AAP 2.5 Survey Manual Setup Guide

Since AAP doesn't support automatic survey import, this guide provides step-by-step instructions for manually creating surveys in the AAP web console. Each survey definition below can be copied and pasted directly into the AAP survey fields.

## How to Create Surveys in AAP

1. **Navigate to Job Templates** in AAP web console
2. **Select your Job Template**
3. **Click "Survey" tab**
4. **Enable Survey**: Toggle "Survey Enabled" to ON
5. **Add Questions**: Click "Add" for each question
6. **Copy field values** from the sections below
7. **Save Survey**

## Survey Field Mapping

When creating each survey question in AAP, use these field mappings:

| Survey Field in AAP | Corresponds to JSON field |
|---------------------|---------------------------|
| Question | `question` |
| Answer Variable Name | `variable` |
| Answer Type | `type` |
| Default Answer | `default` |
| Required | `required` |
| Choices | `choices` (for multiplechoice type) |
| Minimum Value | `min` (for integer/float types) |
| Maximum Value | `max` (for integer/float types) |

## Important Notes

- **Question Order**: Add questions in the order listed below
- **Variable Names**: Use exact variable names as shown (case-sensitive)
- **Answer Types**: Must match exactly (text, integer, boolean, multiplechoice, float)
- **Choices**: For multiplechoice, add each choice on a separate line
- **Required Fields**: Check the "Required" checkbox as indicated

---

## Survey Definitions for Manual Creation

### 1. AIX Filesystem Management Survey

**Survey Name**: `AAP 2.5 AIX Filesystem Management Survey`
**Description**: `Survey for AIX filesystem monitoring and auto-expansion. Credentials are automatically injected by AAP.`

#### Question 1
- **Question**: `Select target AIX hosts or groups:`
- **Answer Variable Name**: `target_hosts`
- **Answer Type**: `Multiple Choice (single select)`
- **Default Answer**: `aix`
- **Required**: ✅ Yes
- **Choices** (one per line):
  ```
  aix
  production
  staging
  development
  all
  ```

#### Question 2
- **Question**: `Filesystem usage threshold percentage (will override defaults):`
- **Answer Variable Name**: `filesystem_threshold`
- **Answer Type**: `Integer`
- **Default Answer**: `85`
- **Required**: ❌ No
- **Minimum Value**: `50`
- **Maximum Value**: `95`

#### Question 3
- **Question**: `Reason for this operation:`
- **Answer Variable Name**: `change_reason`
- **Answer Type**: `Text`
- **Default Answer**: `Automated filesystem monitoring and expansion`
- **Required**: ✅ Yes

#### Question 4
- **Question**: `Change ticket number (if applicable):`
- **Answer Variable Name**: `change_ticket`
- **Answer Type**: `Text`
- **Default Answer**: *(leave empty)*
- **Required**: ❌ No

#### Question 5
- **Question**: `Enable debug logging?`
- **Answer Variable Name**: `enable_debug`
- **Answer Type**: `Boolean`
- **Default Answer**: `False`
- **Required**: ❌ No

---

### 2. AIX CPU Management Survey

**Survey Name**: `AAP 2.5 AIX CPU Management Survey`
**Description**: `Survey for AIX CPU monitoring and auto-scaling via HMC. Credentials are automatically injected by AAP.`

#### Question 1
- **Question**: `Select target AIX hosts or groups:`
- **Answer Variable Name**: `target_hosts`
- **Answer Type**: `Multiple Choice (single select)`
- **Default Answer**: `aix`
- **Required**: ✅ Yes
- **Choices** (one per line):
  ```
  aix
  production
  staging
  development
  all
  ```

#### Question 2
- **Question**: `CPU load average threshold:`
- **Answer Variable Name**: `cpu_load_threshold`
- **Answer Type**: `Float`
- **Default Answer**: `5.0`
- **Required**: ❌ No
- **Minimum Value**: `1.0`
- **Maximum Value**: `20.0`

#### Question 3
- **Question**: `Enable automatic CPU scaling via HMC?`
- **Answer Variable Name**: `cpu_auto_scaling_enabled`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 4
- **Question**: `Number of virtual CPUs to add when scaling:`
- **Answer Variable Name**: `cpu_increment_count`
- **Answer Type**: `Integer`
- **Default Answer**: `1`
- **Required**: ❌ No
- **Minimum Value**: `1`
- **Maximum Value**: `4`

#### Question 5
- **Question**: `Reason for this operation:`
- **Answer Variable Name**: `change_reason`
- **Answer Type**: `Text`
- **Default Answer**: `Automated CPU monitoring and scaling`
- **Required**: ✅ Yes

#### Question 6
- **Question**: `Change ticket number (if applicable):`
- **Answer Variable Name**: `change_ticket`
- **Answer Type**: `Text`
- **Default Answer**: *(leave empty)*
- **Required**: ❌ No

#### Question 7
- **Question**: `Enable debug logging?`
- **Answer Variable Name**: `enable_debug`
- **Answer Type**: `Boolean`
- **Default Answer**: `False`
- **Required**: ❌ No

---

### 3. AIX Memory Management Survey

**Survey Name**: `AAP 2.5 AIX Memory Management Survey`
**Description**: `Survey for AIX memory monitoring and auto-scaling via HMC. Credentials are automatically injected by AAP.`

#### Question 1
- **Question**: `Select target AIX hosts or groups:`
- **Answer Variable Name**: `target_hosts`
- **Answer Type**: `Multiple Choice (single select)`
- **Default Answer**: `aix`
- **Required**: ✅ Yes
- **Choices** (one per line):
  ```
  aix
  production
  staging
  development
  all
  ```

#### Question 2
- **Question**: `Paging space usage threshold percentage:`
- **Answer Variable Name**: `memory_threshold`
- **Answer Type**: `Integer`
- **Default Answer**: `10`
- **Required**: ❌ No
- **Minimum Value**: `5`
- **Maximum Value**: `50`

#### Question 3
- **Question**: `Memory increment in MB when scaling:`
- **Answer Variable Name**: `memory_increment`
- **Answer Type**: `Integer`
- **Default Answer**: `512`
- **Required**: ❌ No
- **Minimum Value**: `256`
- **Maximum Value**: `2048`

#### Question 4
- **Question**: `Enable automatic memory scaling via HMC?`
- **Answer Variable Name**: `memory_auto_scaling_enabled`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 5
- **Question**: `Reason for this operation:`
- **Answer Variable Name**: `change_reason`
- **Answer Type**: `Text`
- **Default Answer**: `Automated memory monitoring and scaling`
- **Required**: ✅ Yes

#### Question 6
- **Question**: `Change ticket number (if applicable):`
- **Answer Variable Name**: `change_ticket`
- **Answer Type**: `Text`
- **Default Answer**: *(leave empty)*
- **Required**: ❌ No

#### Question 7
- **Question**: `Enable debug logging?`
- **Answer Variable Name**: `enable_debug`
- **Answer Type**: `Boolean`
- **Default Answer**: `False`
- **Required**: ❌ No

---

### 4. AIX Print Queue Management Survey

**Survey Name**: `AAP 2.5 AIX Print Queue Management Survey`
**Description**: `Survey for AIX print queue and spooler monitoring with auto-restart. Credentials are automatically injected by AAP.`

#### Question 1
- **Question**: `Select target AIX hosts or groups:`
- **Answer Variable Name**: `target_hosts`
- **Answer Type**: `Multiple Choice (single select)`
- **Default Answer**: `aix`
- **Required**: ✅ Yes
- **Choices** (one per line):
  ```
  aix
  production
  staging
  development
  all
  ```

#### Question 2
- **Question**: `Print queues to monitor (comma-separated, leave blank for defaults):`
- **Answer Variable Name**: `print_queues`
- **Answer Type**: `Text`
- **Default Answer**: `lpbg5,lpbg6,lpbg1`
- **Required**: ❌ No

#### Question 3
- **Question**: `Enable print queue monitoring?`
- **Answer Variable Name**: `print_queue_monitoring_enabled`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 4
- **Question**: `Enable spooler service monitoring?`
- **Answer Variable Name**: `spooler_monitoring_enabled`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 5
- **Question**: `Enable automatic restart of failed services?`
- **Answer Variable Name**: `auto_restart_enabled`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 6
- **Question**: `Reason for this operation:`
- **Answer Variable Name**: `change_reason`
- **Answer Type**: `Text`
- **Default Answer**: `Automated print queue monitoring and restart`
- **Required**: ✅ Yes

#### Question 7
- **Question**: `Change ticket number (if applicable):`
- **Answer Variable Name**: `change_ticket`
- **Answer Type**: `Text`
- **Default Answer**: *(leave empty)*
- **Required**: ❌ No

#### Question 8
- **Question**: `Enable debug logging?`
- **Answer Variable Name**: `enable_debug`
- **Answer Type**: `Boolean`
- **Default Answer**: `False`
- **Required**: ❌ No

---

### 5. AIX Service Monitoring Survey

**Survey Name**: `AAP 2.5 AIX Service Monitoring Survey`
**Description**: `Survey for AIX service monitoring (Zabbix, etc.) with auto-restart. Credentials are automatically injected by AAP.`

#### Question 1
- **Question**: `Select target AIX hosts or groups:`
- **Answer Variable Name**: `target_hosts`
- **Answer Type**: `Multiple Choice (single select)`
- **Default Answer**: `aix`
- **Required**: ✅ Yes
- **Choices** (one per line):
  ```
  aix
  production
  staging
  development
  all
  ```

#### Question 2
- **Question**: `Enable service monitoring?`
- **Answer Variable Name**: `service_monitoring_enabled`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 3
- **Question**: `Enable automatic restart of failed services?`
- **Answer Variable Name**: `auto_restart_enabled`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 4
- **Question**: `Enable Zabbix agent monitoring?`
- **Answer Variable Name**: `zabbix_monitoring_enabled`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 5
- **Question**: `Reason for this operation:`
- **Answer Variable Name**: `change_reason`
- **Answer Type**: `Text`
- **Default Answer**: `Automated service monitoring and restart`
- **Required**: ✅ Yes

#### Question 6
- **Question**: `Change ticket number (if applicable):`
- **Answer Variable Name**: `change_ticket`
- **Answer Type**: `Text`
- **Default Answer**: *(leave empty)*
- **Required**: ❌ No

#### Question 7
- **Question**: `Enable debug logging?`
- **Answer Variable Name**: `enable_debug`
- **Answer Type**: `Boolean`
- **Default Answer**: `False`
- **Required**: ❌ No

---

### 6. AIX Complete Monitoring Survey

**Survey Name**: `AAP 2.5 AIX Complete Monitoring Survey`
**Description**: `Comprehensive survey for all AIX monitoring and management services. Credentials are automatically injected by AAP.`

#### Question 1
- **Question**: `Select target AIX hosts or groups:`
- **Answer Variable Name**: `target_hosts`
- **Answer Type**: `Multiple Choice (single select)`
- **Default Answer**: `aix`
- **Required**: ✅ Yes
- **Choices** (one per line):
  ```
  aix
  production
  staging
  development
  all
  ```

#### Question 2
- **Question**: `Number of hosts to process in parallel:`
- **Answer Variable Name**: `batch_size`
- **Answer Type**: `Integer`
- **Default Answer**: `1`
- **Required**: ❌ No
- **Minimum Value**: `1`
- **Maximum Value**: `10`

#### Question 3
- **Question**: `Enable filesystem monitoring and auto-expansion?`
- **Answer Variable Name**: `filesystem_monitoring`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 4
- **Question**: `Enable CPU monitoring and auto-scaling?`
- **Answer Variable Name**: `cpu_monitoring`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 5
- **Question**: `Enable memory monitoring and auto-scaling?`
- **Answer Variable Name**: `memory_monitoring`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 6
- **Question**: `Enable print queue monitoring and auto-restart?`
- **Answer Variable Name**: `print_queue_monitoring`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 7
- **Question**: `Enable service monitoring (Zabbix, etc.)?`
- **Answer Variable Name**: `service_monitoring`
- **Answer Type**: `Boolean`
- **Default Answer**: `True`
- **Required**: ❌ No

#### Question 8
- **Question**: `Send completion notification email?`
- **Answer Variable Name**: `send_completion_email`
- **Answer Type**: `Boolean`
- **Default Answer**: `False`
- **Required**: ❌ No

#### Question 9
- **Question**: `Reason for this operation:`
- **Answer Variable Name**: `change_reason`
- **Answer Type**: `Text`
- **Default Answer**: `Comprehensive AIX system monitoring and management`
- **Required**: ✅ Yes

#### Question 10
- **Question**: `Change ticket number (if applicable):`
- **Answer Variable Name**: `change_ticket`
- **Answer Type**: `Text`
- **Default Answer**: *(leave empty)*
- **Required**: ❌ No

#### Question 11
- **Question**: `Enable debug logging?`
- **Answer Variable Name**: `enable_debug`
- **Answer Type**: `Boolean`
- **Default Answer**: `False`
- **Required**: ❌ No

---

## Validation Checklist

After creating each survey, verify:

- [ ] All variable names match exactly (case-sensitive)
- [ ] Answer types are correct (text, integer, boolean, multiplechoice, float)
- [ ] Default values are set correctly
- [ ] Required fields are marked appropriately
- [ ] Minimum/Maximum values are set for numeric fields
- [ ] Multiple choice options are entered correctly (one per line)
- [ ] Survey is enabled on the job template

## Testing

After creating surveys:

1. **Preview Survey**: Use AAP's survey preview feature
2. **Test Launch**: Launch job template to test survey functionality
3. **Verify Variables**: Check that survey variables are passed to playbooks correctly
4. **Validate Defaults**: Ensure default values work as expected

## Common Issues

1. **Variable Name Mismatches**: Ensure exact spelling and case
2. **Answer Type Errors**: Use exact types as specified
3. **Choice Format**: Multiple choice options must be on separate lines
4. **Missing Defaults**: Always provide sensible default values
5. **Required Field Logic**: Mark essential fields as required

## Support

If you encounter issues during survey creation:
- Review AAP documentation for survey creation
- Check job template variables match survey output
- Test with minimal survey first
- Contact EIS Command Center team for assistance