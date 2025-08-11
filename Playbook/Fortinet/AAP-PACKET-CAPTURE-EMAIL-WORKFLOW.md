# AAP Packet Capture with Email Notification - Complete Setup Guide

## Overview
This guide provides step-by-step instructions for setting up a complete packet capture workflow in AAP 2.5 with automatic analysis and email notification capabilities.

## Prerequisites

1. **AAP Email Configuration**
   - Configure SMTP settings in AAP:
     ```
     Settings → System → Miscellaneous System
     - Email Host: smtp.your-domain.com
     - Email Port: 587 (or 25/465)
     - Email Username: your-email@domain.com
     - Email Password: ********
     - Email Use TLS: Yes/No based on your server
     ```

2. **Fortinet Credentials**
   - Create credential type for Fortinet API token
   - Store the API token or password

3. **Inventory Setup**
   - Add Fortinet devices to inventory
   - Set `fortinet_api_token` variable in host/group vars

## Option 1: Single Playbook Workflow (Simplest)

### Step 1: Create Job Template
1. Navigate to **Templates** → **Add** → **Job Template**
2. Configure:
   ```yaml
   Name: Fortinet - Packet Capture with Email
   Job Type: Run
   Inventory: Your Fortinet Inventory
   Project: Your Fortinet Project
   Playbook: playbooks/packet_capture_workflow.yml
   Credentials: 
     - Your Fortinet Credential
     - Machine Credential (for email)
   ```
3. Enable **Survey** and import `surveys/packet_capture_workflow-survey.json`
4. Save the template

### Step 2: Execute the Job
1. Launch the template
2. Fill in the survey:
   - Interface name
   - Capture filter
   - Email address (optional)
   - Other parameters
3. Job will:
   - Capture packets
   - Analyze the data
   - Send email report
   - Store results in AAP artifacts

## Option 2: Modular Workflow (More Flexible)

### Step 1: Create Individual Job Templates

#### A. Packet Capture Template
```yaml
Name: Fortinet - Packet Capture Only
Playbook: playbooks/enable_packet_capture.yml
Survey: surveys/enable_packet_capture-survey.json
```

#### B. Analysis Template
```yaml
Name: Fortinet - Analyze Capture
Playbook: playbooks/analyze_packet_capture.yml
Survey: surveys/analyze_packet_capture-survey.json
```

### Step 2: Create Workflow Template
1. Navigate to **Templates** → **Add** → **Workflow Template**
2. Name: `Fortinet - Capture and Analyze Workflow`
3. In the Workflow Visualizer:
   ```
   [Start] → [Packet Capture] → [Analyze Capture] → [Success]
                    ↓ (on failure)
                [Send Alert Email]
   ```

### Step 3: Configure Node Connections
1. Click on **Analyze Capture** node
2. Add to Extra Variables:
   ```yaml
   fortinet_packet_capture: "{{ fortinet_packet_capture }}"
   ```

## Option 3: Advanced Multi-Stage Workflow

### Workflow Structure
```
[Start]
   ↓
[Pre-Check Connectivity]
   ↓ (on success)
[Packet Capture]
   ↓
[Parallel Analysis]
   ├─[TCP Analysis]
   ├─[UDP Analysis]
   └─[ICMP Analysis]
   ↓
[Generate Report]
   ↓
[Send Email]
   ↓
[Store Long-term]
```

### Create Additional Playbooks

#### Pre-Check Playbook
```yaml
# playbooks/pre_capture_check.yml
---
- name: Pre-capture connectivity check
  hosts: "{{ target_hosts }}"
  tasks:
    - name: Verify Fortinet connectivity
      fortinet.fortios.fortios_monitor_fact:
        selector: 'system_status'
        access_token: "{{ fortinet_api_token }}"
      register: status_check
    
    - name: Fail if device not reachable
      fail:
        msg: "Device not reachable"
      when: status_check is failed
```

## Email Report Customization

### Custom Email Templates
Create custom email templates by modifying the email body in the playbook:

```yaml
# In your playbook vars:
email_template: |
  <html>
  <body>
    <h2>Packet Capture Report</h2>
    <table border="1">
      <tr><td>Host</td><td>{{ inventory_hostname }}</td></tr>
      <tr><td>Status</td><td>{{ capture_status }}</td></tr>
      <!-- Add more rows -->
    </table>
  </body>
  </html>
```

### Multiple Recipients
```yaml
send_email: "admin@company.com,network-team@company.com"
```

## Scheduling and Automation

### Schedule Regular Captures
1. In Job Template, click **Schedules**
2. Add Schedule:
   ```
   Name: Daily Network Capture
   Start Date/Time: Today 02:00
   Repeat Frequency: Daily
   ```

### Event-Driven Captures
Use AAP's webhook feature:
1. Enable webhooks in job template
2. Trigger from monitoring system:
   ```bash
   curl -X POST https://aap.company.com/api/v2/job_templates/123/webhook/ \
     -H "Content-Type: application/json" \
     -d '{"extra_vars": {"interface_name": "wan1", "send_email": "oncall@company.com"}}'
   ```

## Troubleshooting

### Email Not Sending
1. Check AAP email configuration
2. Verify `delegate_to: localhost` in mail task
3. Check job output for mail task errors
4. Test with:
   ```yaml
   - name: Test email
     mail:
       to: test@company.com
       subject: "Test"
       body: "Test email"
     delegate_to: localhost
   ```

### Capture Data Not Persisting
1. Verify `set_stats` has `aggregate: true`
2. Check workflow extra_vars configuration
3. Use API to verify artifacts:
   ```bash
   curl -u admin:password \
     https://aap.company.com/api/v2/jobs/{job_id}/artifacts/
   ```

### Workflow Data Not Passing
1. Ensure variable names match exactly
2. Check workflow node configuration
3. Add debug task to verify data:
   ```yaml
   - debug:
       var: fortinet_packet_capture
   ```

## Best Practices

1. **Security**
   - Use encrypted credentials
   - Limit email recipients to authorized personnel
   - Sanitize capture output before emailing

2. **Performance**
   - Limit capture count for regular monitoring
   - Use specific filters to reduce data volume
   - Schedule captures during low-traffic periods

3. **Data Management**
   - Set up artifact retention policies
   - Export critical captures to external storage
   - Document capture purposes in email subjects

4. **Alerting**
   - Set up separate workflows for different severity levels
   - Use conditional email sending based on analysis results
   - Integrate with ticketing systems for issue tracking

## Example Use Cases

### 1. VPN Troubleshooting Workflow
```yaml
Survey Questions:
- VPN Name: {{ vpn_name }}
- Peer IP: {{ peer_ip }}
- Email: {{ support_email }}

Filter: "host {{ peer_ip }} and (port 500 or port 4500 or esp)"
```

### 2. Application Performance Monitoring
```yaml
Survey Questions:
- Application Server: {{ app_server }}
- Application Port: {{ app_port }}
- Email: {{ app_team_email }}

Filter: "host {{ app_server }} and port {{ app_port }}"
```

### 3. Security Incident Response
```yaml
Survey Questions:
- Suspicious IP: {{ suspicious_ip }}
- Time Window: {{ capture_timeout }}
- Security Team Email: {{ security_email }}

Filter: "host {{ suspicious_ip }}"
Capture Count: 10000
```

## Integration with Other Tools

### ServiceNow Integration
```yaml
- name: Create ServiceNow incident if issues found
  uri:
    url: "https://instance.service-now.com/api/now/table/incident"
    method: POST
    body_format: json
    body:
      short_description: "Network issues detected on {{ inventory_hostname }}"
      description: "{{ analysis_summary | to_nice_json }}"
  when: analysis_summary.issues_detected | select | list | length > 0
```

### Slack Notification
```yaml
- name: Send Slack notification
  uri:
    url: "{{ slack_webhook_url }}"
    method: POST
    body_format: json
    body:
      text: "Packet capture completed on {{ inventory_hostname }}"
      attachments:
        - color: "{{ 'danger' if capture_status == 'failed' else 'good' }}"
          text: "{{ analysis_summary.recommendations }}"
```

## Conclusion
This workflow provides a complete solution for packet capture, analysis, and notification in AAP 2.5. The modular design allows for easy customization and extension based on specific requirements.