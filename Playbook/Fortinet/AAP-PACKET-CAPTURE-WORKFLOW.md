# AAP Packet Capture Workflow Guide

## Overview
The packet capture playbooks have been updated to work with AAP's persistent storage mechanisms, avoiding the ephemeral nature of Execution Environment containers.

## How Data Persistence Works in AAP

### Method 1: Using set_stats (Recommended)
The playbooks now use Ansible's `set_stats` module to store capture data as artifacts that persist across job runs and can be accessed:
- Via AAP API
- In workflow job templates (data passes between jobs)
- In the AAP UI under job artifacts

### Method 2: Using Custom Facts
The playbooks also set cacheable facts that can be retrieved in subsequent runs against the same hosts.

## Setting Up the Workflow

### Step 1: Create Job Templates

1. **Packet Capture Job Template**
   - Name: `Fortinet - Packet Capture`
   - Playbook: `playbooks/enable_packet_capture.yml`
   - Survey: Enable and import `surveys/enable_packet_capture-survey.json`
   - Credentials: Fortinet API token or password

2. **Analysis Job Template**
   - Name: `Fortinet - Analyze Packet Capture`
   - Playbook: `playbooks/analyze_packet_capture.yml`
   - Survey: Enable and import `surveys/analyze_packet_capture-survey.json`
   - Extra Variables: (Set in workflow, see below)

### Step 2: Create Workflow Template

1. Create a new Workflow Template:
   - Name: `Fortinet - Capture and Analyze Packets`

2. Add nodes:
   - Node 1: `Fortinet - Packet Capture`
   - Node 2: `Fortinet - Analyze Packet Capture`
   - Link: On Success from Node 1 to Node 2

3. Configure data passing between jobs:
   - In the workflow visualizer, click on Node 2
   - Add extra variables:
   ```yaml
   fortinet_packet_capture: "{{ fortinet_packet_capture }}"
   ```

## Accessing Capture Data

### Via AAP API
```bash
# Get job artifacts
curl -u admin:password \
  https://aap.example.com/api/v2/jobs/{job_id}/artifacts/
```

### In Subsequent Jobs
The data is automatically available in workflow jobs through the `fortinet_packet_capture` variable.

### Example Data Structure
```yaml
fortinet_packet_capture:
  status: "success"
  hostname: "fortinet-fw01"
  interface: "wan1"
  filter: "host 192.168.1.1"
  timestamp: "2024-01-15T10:30:00Z"
  vdom: "root"
  packet_count: 100
  capture_output: "... actual packet data ..."
  capture_result_meta: "... metadata ..."
```

## Using the Data in Other Playbooks

Any playbook in the workflow can access the capture data:

```yaml
- name: Use capture data from previous job
  debug:
    msg: "Capture from {{ fortinet_packet_capture.hostname }} at {{ fortinet_packet_capture.timestamp }}"
  when: fortinet_packet_capture is defined
```

## Alternative: Using AAP Collections API

For long-term storage, you can also push the data to AAP's database using the AWX collection:

```yaml
- name: Store capture data in AAP database
  awx.awx.job_template:
    name: "Capture_{{ ansible_date_time.epoch }}"
    extra_vars: "{{ fortinet_packet_capture | to_json }}"
    # ... other parameters
```

## Troubleshooting

1. **Data not passing between jobs**: Ensure the workflow template has the correct extra_vars configuration
2. **No artifacts shown**: Check that `set_stats` is configured with `aggregate: true`
3. **Email not sending**: Verify SMTP settings in AAP configuration

## Benefits of This Approach

1. **No filesystem dependencies**: Data persists in AAP's database, not in ephemeral containers
2. **Workflow integration**: Data seamlessly passes between jobs
3. **API accessible**: Capture data can be retrieved programmatically
4. **Audit trail**: All captures are logged in AAP job history
5. **Scalable**: Works across multiple execution nodes

## Example Use Cases

1. **Automated Troubleshooting**: Capture packets when VPN issues are detected
2. **Compliance Reporting**: Regular packet captures with analysis reports
3. **Performance Monitoring**: Scheduled captures to detect network issues
4. **Incident Response**: On-demand captures with immediate analysis