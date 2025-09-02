# Step-by-Step Survey Creation in AAP 2.5

This document provides detailed, click-by-click instructions for creating surveys in AAP 2.5 web console.

## Prerequisites

- Job templates already created in AAP
- Access to AAP web console with appropriate permissions
- Survey field values from the Quick Reference document

## General Survey Creation Process

### Step 1: Navigate to Job Template
1. Log into AAP web console
2. Click **Templates** in the left navigation menu
3. Find your job template (e.g., "AIX Filesystem Management")
4. Click on the template name to open it

### Step 2: Enable Survey
1. In the job template details page, click the **Survey** tab
2. Toggle **Survey Enabled** to ON (blue toggle switch)
3. The survey editing interface will appear

### Step 3: Add Survey Questions
1. Click the **Add** button to add your first question
2. Fill in the fields as detailed in the specific sections below
3. Click **Save** after each question
4. Repeat for all questions in the survey

### Step 4: Test and Finalize
1. Click **Preview** to test the survey
2. Make any necessary adjustments
3. Save the job template

---

## Specific Survey Creation Instructions

### 1. AIX Filesystem Management Survey

#### Question 1: Target Hosts
1. Click **Add** in the survey section
2. Fill in the fields:
   - **Question**: `Select target AIX hosts or groups:`
   - **Answer Variable Name**: `target_hosts`
   - **Answer Type**: Select `Multiple Choice (single select)` from dropdown
   - **Default Answer**: `aix`
   - **Required**: Check the checkbox ✅
3. In the **Choices** section, add these options (press Enter after each):
   ```
   aix
   production
   staging
   development
   all
   ```
4. Click **Save**

#### Question 2: Filesystem Threshold
1. Click **Add** for the next question
2. Fill in the fields:
   - **Question**: `Filesystem usage threshold percentage (will override defaults):`
   - **Answer Variable Name**: `filesystem_threshold`
   - **Answer Type**: Select `Integer` from dropdown
   - **Default Answer**: `85`
   - **Required**: Leave unchecked ❌
   - **Minimum**: `50`
   - **Maximum**: `95`
3. Click **Save**

#### Question 3: Change Reason
1. Click **Add** for the next question
2. Fill in the fields:
   - **Question**: `Reason for this operation:`
   - **Answer Variable Name**: `change_reason`
   - **Answer Type**: Select `Text` from dropdown
   - **Default Answer**: `Automated filesystem monitoring and expansion`
   - **Required**: Check the checkbox ✅
3. Click **Save**

#### Question 4: Change Ticket
1. Click **Add** for the next question
2. Fill in the fields:
   - **Question**: `Change ticket number (if applicable):`
   - **Answer Variable Name**: `change_ticket`
   - **Answer Type**: Select `Text` from dropdown
   - **Default Answer**: (leave empty)
   - **Required**: Leave unchecked ❌
3. Click **Save**

#### Question 5: Debug Logging
1. Click **Add** for the next question
2. Fill in the fields:
   - **Question**: `Enable debug logging?`
   - **Answer Variable Name**: `enable_debug`
   - **Answer Type**: Select `Boolean` from dropdown
   - **Default Answer**: `False` (or leave unchecked)
   - **Required**: Leave unchecked ❌
3. Click **Save**

### 2. AIX CPU Management Survey

Follow the same process as above, but use these specific field values:

#### Question 1: Target Hosts (same as filesystem)
- Same as filesystem survey Question 1

#### Question 2: CPU Load Threshold
- **Question**: `CPU load average threshold:`
- **Answer Variable Name**: `cpu_load_threshold`
- **Answer Type**: `Float`
- **Default Answer**: `5.0`
- **Required**: ❌
- **Minimum**: `1.0`
- **Maximum**: `20.0`

#### Question 3: Auto-scaling Enabled
- **Question**: `Enable automatic CPU scaling via HMC?`
- **Answer Variable Name**: `cpu_auto_scaling_enabled`
- **Answer Type**: `Boolean`
- **Default Answer**: `True` (or checked)
- **Required**: ❌

#### Question 4: CPU Increment
- **Question**: `Number of virtual CPUs to add when scaling:`
- **Answer Variable Name**: `cpu_increment_count`
- **Answer Type**: `Integer`
- **Default Answer**: `1`
- **Required**: ❌
- **Minimum**: `1`
- **Maximum**: `4`

#### Question 5: Change Reason
- **Question**: `Reason for this operation:`
- **Answer Variable Name**: `change_reason`
- **Answer Type**: `Text`
- **Default Answer**: `Automated CPU monitoring and scaling`
- **Required**: ✅

#### Question 6: Change Ticket (same as filesystem)
- Same as filesystem survey Question 4

#### Question 7: Debug Logging (same as filesystem)
- Same as filesystem survey Question 5

### 3. AIX Memory Management Survey

Follow the same process, using field values from the Quick Reference document.

### 4. AIX Print Queue Management Survey

Follow the same process, using field values from the Quick Reference document.

### 5. AIX Service Monitoring Survey

Follow the same process, using field values from the Quick Reference document.

### 6. AIX Complete Monitoring Survey

Follow the same process, using field values from the Quick Reference document.

---

## Common AAP Survey Field Types

### Text
- Use for: Free-form text input
- Settings: Default value, required checkbox
- Example: Change reason, ticket numbers

### Integer
- Use for: Whole numbers
- Settings: Default value, minimum, maximum, required checkbox
- Example: Thresholds, counts, timeouts

### Float
- Use for: Decimal numbers
- Settings: Default value, minimum, maximum, required checkbox
- Example: Load averages, percentages with decimals

### Boolean
- Use for: True/False options
- Settings: Default value (checked/unchecked), required checkbox
- Example: Enable/disable features

### Multiple Choice (single select)
- Use for: Selecting one option from a list
- Settings: Choices (one per line), default value, required checkbox
- Example: Host groups, environments

### Multiple Choice (multiple select)
- Use for: Selecting multiple options from a list
- Settings: Choices (one per line), default values, required checkbox
- Example: Multiple services to monitor

## Validation Tips

### Before Saving Survey:
1. **Preview the survey** using the Preview button
2. **Check variable names** are exactly correct (case-sensitive)
3. **Verify default values** make sense
4. **Test required fields** by leaving them blank in preview
5. **Validate numeric ranges** with min/max values

### After Creating Survey:
1. **Test launch** the job template
2. **Verify survey appears** correctly
3. **Check default values** populate as expected
4. **Confirm variables** are passed to the playbook
5. **Test required field validation**

## Troubleshooting Common Issues

### Survey Not Appearing
- Ensure "Survey Enabled" toggle is ON
- Check job template has survey questions saved
- Verify permissions to launch job templates

### Variable Names Not Working
- Check exact spelling and case sensitivity
- Ensure no extra spaces in variable names
- Verify variable names match playbook expectations

### Default Values Not Setting
- Confirm default values are appropriate for field type
- Check Boolean defaults are set correctly (True/False)
- Verify numeric defaults are within min/max ranges

### Choices Not Displaying
- Ensure each choice is on a separate line
- Check for extra spaces or special characters
- Verify multiple choice type is selected correctly

### Required Fields Not Validating
- Confirm required checkbox is checked
- Test by leaving required fields empty
- Verify error messages appear appropriately

## Final Checklist

After creating all surveys:

- [ ] All 6 surveys created and enabled
- [ ] Variable names match playbook expectations
- [ ] Default values are sensible and working
- [ ] Required fields properly validated
- [ ] Multiple choice options complete
- [ ] Numeric ranges appropriate
- [ ] Survey preview works correctly
- [ ] Test launches successful
- [ ] All job templates have surveys enabled

## Support

If you encounter issues:
1. Review AAP documentation for surveys
2. Check the Quick Reference document for exact field values
3. Test with a simple survey first
4. Contact system administrators for AAP-specific help