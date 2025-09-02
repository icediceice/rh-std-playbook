# AAP Credential Setup for AIX Management

## Machine Credential Configuration

### 1. Create Machine Credential in AAP

1. Navigate to **Resources** → **Credentials**
2. Click **Add**
3. Fill in the details:
   - **Name**: `AIX Machine Credential`
   - **Organization**: Your organization
   - **Credential Type**: `Machine`

### 2. Credential Fields

| Field | Description | Example |
|-------|-------------|---------|
| **Username** | AIX system user | `root` or `ansible_user` |
| **Password** | User password | Your AIX user password |
| **Privilege Escalation Method** | Usually `sudo` | `sudo` |
| **Privilege Escalation Username** | Target escalation user | `root` |
| **Privilege Escalation Password** | Sudo/su password | Same as password if needed |

### 3. Job Template Configuration

1. Navigate to **Resources** → **Templates**
2. Create/Edit Job Template
3. In **Credentials** section, select your `AIX Machine Credential`
4. Set **Inventory** to your AIX inventory
5. Set **Playbook** to `playbooks/aix_connectivity_test.yml`

### 4. AAP Credential Injection Variables

When AAP runs the playbook, these variables are automatically injected:

```yaml
# Automatically injected by AAP Machine Credential:
ansible_user: "username_from_credential"
ansible_password: "password_from_credential"  
ansible_ssh_pass: "password_from_credential"
ansible_become_pass: "privilege_escalation_password"

# AAP Job Information:
tower_job_template_name: "Job Template Name"
tower_job_id: "12345"
tower_user_name: "aap_user"
```

### 5. Inventory Configuration

Your inventory file (`inventory/aix_hosts.yml`) should only contain:

```yaml
all:
  hosts:
    aix-host1:
      ansible_host: 192.168.1.100
    aix-host2:
      ansible_host: 192.168.1.101
  vars:
    # Connection settings
    ansible_connection: ssh
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
    ansible_python_interpreter: /usr/bin/python3
```

**Note**: Do NOT put passwords in inventory when using AAP credential injection!

### 6. Testing the Setup

1. Run the connectivity test playbook from AAP
2. Check the job output for:
   - ✅ Credential Status: "Injected"
   - ✅ Test User shows your credential username
   - ✅ All connectivity tests pass

### 7. Troubleshooting

| Issue | Solution |
|-------|----------|
| Authentication fails | Verify username/password in credential |
| Permission denied | Check privilege escalation settings |
| Connection timeout | Verify network connectivity and SSH access |
| Python not found | Set correct `ansible_python_interpreter` in inventory |

### 8. Security Best Practices

- ✅ Use dedicated service accounts for automation
- ✅ Apply principle of least privilege
- ✅ Rotate passwords regularly
- ✅ Use SSH keys when possible (Machine credential supports this too)
- ✅ Monitor credential usage through AAP logs