#!/usr/bin/env python3
"""
Script to update all AIX Management playbooks with AAP credential injection
Updates version numbers, adds AAP variables, and standardizes credential handling
"""

import os
import re
from pathlib import Path

# Define the playbooks to update
playbooks = [
    'aix_cpu_management.yml',
    'aix_memory_management.yml', 
    'aix_filesystem_management.yml',
    'aix_print_queue_management.yml',
    'aix_service_monitoring.yml'
]

# AAP variables template to insert
aap_variables = '''
    # AAP Job Information (automatically injected by AAP)
    aap_job_template: "{{ tower_job_template_name | default('N/A') }}"
    aap_job_id: "{{ tower_job_id | default('N/A') }}"
    aap_user: "{{ tower_user_name | default('N/A') }}"
    aap_inventory: "{{ tower_inventory_name | default('N/A') }}"
    
    # Change tracking for AAP
    change_reason: "{{ change_reason | default('PLACEHOLDER_REASON') }}"
    change_ticket: "{{ change_ticket | default('') }}"
    
    # Credential status for display
    credential_status: "{{ 'AAP Injected' if ansible_user is defined and ansible_user != '' else 'Manual Configuration' }}"
'''

# Enhanced pre_tasks template
enhanced_pre_tasks = '''
    - name: Display playbook execution information
      ansible.builtin.debug:
        msg: |
          =====================================
          {{ playbook_name }}
          =====================================
          Version: {{ playbook_version }}
          Target Hosts: {{ target_hosts | default(group_names | first | default('aix')) }}
          Batch Size: {{ batch_size | default('1') }}
          
          AAP Integration:
          - Job Template: {{ aap_job_template }}
          - Job ID: {{ aap_job_id }}
          - Executed By: {{ aap_user }}
          - Inventory: {{ aap_inventory }}
          
          Authentication:
          - User: {{ ansible_user | default('Not specified') }}
          - Credential Status: {{ credential_status }}
          
          Change Management:
          - Reason: {{ change_reason }}
          - Ticket: {{ change_ticket | default('Not provided') }}
          
          Execution Details:
          - Start Time: {{ ansible_date_time.iso8601 }}
          - Controller: {{ ansible_control_node | default('Unknown') }}
          =====================================
      tags: always
'''

# Post_tasks template
post_tasks_template = '''

  post_tasks:
    - name: Display playbook completion summary
      ansible.builtin.debug:
        msg: |
          =====================================
          {{ playbook_name }} - COMPLETED
          =====================================
          Execution Summary:
          - Job ID: {{ aap_job_id }}
          - Completed: {{ ansible_date_time.iso8601 }}
          - Status: Success
          - Processed Hosts: {{ ansible_play_hosts | length }}
          
          Change Tracking:
          - Ticket: {{ change_ticket | default('No ticket provided') }}
          - Reason: {{ change_reason }}
          
          Next Steps:
          - Review AAP job logs for detailed results
          - Verify changes on target systems if applicable
          - Update change management system if required
          =====================================
      tags: always
      run_once: true
'''

def update_playbook(playbook_path):
    """Update a single playbook with AAP credential injection"""
    
    with open(playbook_path, 'r') as f:
        content = f.read()
    
    playbook_name = os.path.basename(playbook_path).replace('.yml', '').replace('_', ' ').title()
    
    # Update version number
    content = re.sub(r'playbook_version: "[0-9.]+"', 'playbook_version: "2.0"', content)
    
    # Determine default reason based on playbook name
    if 'cpu' in playbook_path.lower():
        default_reason = 'Automated CPU monitoring and scaling'
    elif 'memory' in playbook_path.lower():
        default_reason = 'Automated memory monitoring and scaling'
    elif 'filesystem' in playbook_path.lower():
        default_reason = 'Automated filesystem monitoring and management'
    elif 'print' in playbook_path.lower():
        default_reason = 'Automated print queue monitoring and management'
    elif 'service' in playbook_path.lower():
        default_reason = 'Automated service monitoring and management'
    else:
        default_reason = 'Automated AIX system management'
    
    # Insert AAP variables after playbook_version
    aap_vars = aap_variables.replace('PLACEHOLDER_REASON', default_reason)
    
    # Look for the pattern where we need to insert AAP variables
    version_pattern = r'(playbook_version: "[0-9.]+"\s*\n)(.*?)(# Change tracking|# Override)'
    if re.search(version_pattern, content, re.DOTALL):
        content = re.sub(version_pattern, r'\1' + aap_vars + r'\3', content, flags=re.DOTALL)
    
    # Add post_tasks if not present
    if 'post_tasks:' not in content:
        content = content.rstrip() + post_tasks_template
    
    # Write back the updated content
    with open(playbook_path, 'w') as f:
        f.write(content)
    
    print(f"Updated {playbook_path}")

def main():
    """Main function to update all playbooks"""
    playbooks_dir = Path(__file__).parent / 'playbooks'
    
    for playbook in playbooks:
        playbook_path = playbooks_dir / playbook
        if playbook_path.exists():
            try:
                update_playbook(playbook_path)
            except Exception as e:
                print(f"Error updating {playbook}: {e}")
        else:
            print(f"Playbook not found: {playbook_path}")

if __name__ == "__main__":
    main()