# Multi-Cloud Survey Persistence & Redeployment - Quick Start Guide

This guide demonstrates how to use survey persistence and redeployment features for multi-cloud environments with AAP 2.5.

## Quick Implementation Steps

### 1. Initial Setup - Create Environment-Specific Job Templates

**Step 1: Create AWS Production Template**
```yaml
Name: "AWS-Production-Server"
Project: "Cloud Operations"
Playbook: "playbooks/provision-server.yml"
Execution Environment: "cloud-operations-ee:latest"
Credentials: [AWS-Production-Credential]
Survey: Import "surveys/aws-production-server-survey.json"
Extra Variables:
  @env-configs/aws-production.yml
```

**Step 2: Create Azure Staging Template**
```yaml
Name: "Azure-Staging-Server"
Project: "Cloud Operations"
Playbook: "playbooks/provision-server.yml"
Execution Environment: "cloud-operations-ee:latest"
Credentials: [Azure-Staging-Credential]
Survey: Import "surveys/azure-staging-server-survey.json"
Extra Variables:
  @env-configs/azure-staging.yml
```

**Step 3: Create GCP Development Template**
```yaml
Name: "GCP-Development-Server"
Project: "Cloud Operations"
Playbook: "playbooks/provision-server.yml"
Execution Environment: "cloud-operations-ee:latest"
Credentials: [GCP-Development-Credential]
Survey: Import "surveys/gcp-development-server-survey.json"
Extra Variables:
  @env-configs/gcp-development.yml
```

### 2. First-Time Deployment

**Deploy to AWS Production:**
1. Navigate to Templates → "AWS-Production-Server"
2. Click **Launch**
3. Fill out the survey:
   - Server Name: "web-server-prod-01"
   - Instance Type: "t3.large"
   - Region: "us-east-1"
   - Additional settings as needed
4. Click **Launch**
5. AAP saves survey responses automatically

**Deploy to Azure Staging:**
1. Navigate to Templates → "Azure-Staging-Server"
2. Click **Launch**
3. Fill out the survey:
   - Server Name: "web-server-staging-01"
   - VM Size: "Standard_B2ms"
   - Location: "eastus"
   - Additional settings as needed
4. Click **Launch**
5. AAP saves survey responses automatically

### 3. Redeployment Scenarios

#### Scenario A: Exact Redeployment (Same Configuration)

**Redeploy AWS Production Server:**
1. Navigate to **Jobs** → Find completed AWS deployment job
2. Click **Relaunch**
3. Job runs immediately with identical configuration
4. No survey required - uses saved values

**Result:** Creates identical server with same configuration

#### Scenario B: Modified Redeployment

**Scale Out Azure Staging:**
1. Navigate to Templates → "Azure-Staging-Server"
2. Click **Launch**
3. Survey shows last-used values as defaults
4. Modify only necessary fields:
   - Server Name: "web-server-staging-02" (changed)
   - VM Size: "Standard_B2ms" (unchanged)
   - Location: "eastus" (unchanged)
5. Click **Launch**

**Result:** Creates new server with modified name, same other settings

#### Scenario C: Bulk Multi-Cloud Redeployment

**Using Multi-Cloud Workflow:**
1. Navigate to Templates → "Multi-Cloud-Deployment"
2. Click **Launch**
3. Fill out workflow survey:
   - Deployment Strategy: "parallel"
   - Environments: ["aws_prod", "azure_staging", "gcp_dev"]
   - Provision Servers: "yes"
   - Enable Monitoring: "yes"
4. Click **Launch**

**Result:** Deploys to all three clouds simultaneously

### 4. Advanced Redeployment Patterns

#### Blue-Green Deployment Pattern

**Phase 1: Deploy to Staging (Green)**
```yaml
Workflow: "Blue-Green-Deployment"
Step 1: Deploy to Azure Staging (Green environment)
Step 2: Run validation tests
Step 3: Performance testing
```

**Phase 2: Promote to Production (Blue)**
```yaml
Step 4: Deploy to AWS Production with staging configuration
Step 5: Gradual traffic switching
Step 6: Monitor and validate
```

**Phase 3: Rollback if Needed**
```yaml
Step 7: Quick rollback to previous production version
Step 8: Traffic switching back to stable version
```

#### Rolling Update Pattern

**Deploy Across Multiple Zones:**
```yaml
Workflow: "Rolling-Update-Deployment"
Step 1: Deploy to Zone A
Step 2: Validate Zone A deployment
Step 3: Deploy to Zone B (if Zone A successful)
Step 4: Validate Zone B deployment
Step 5: Deploy to Zone C (if Zone B successful)
```

### 5. Configuration Management

#### Environment Configuration Files

**AWS Production (env-configs/aws-production.yml):**
```yaml
cloud_provider: "aws"
environment: "production"
region: "us-east-1"
default_instance_type: "t3.large"
default_tags:
  Environment: "Production"
  ManagedBy: "Ansible"
  BackupPolicy: "Daily"
```

**Azure Staging (env-configs/azure-staging.yml):**
```yaml
cloud_provider: "azure"
environment: "staging"
location: "eastus"
default_vm_size: "Standard_B2ms"
default_tags:
  Environment: "Staging"
  ManagedBy: "Ansible"
  BackupPolicy: "Weekly"
```

#### Survey Templates

**Production Survey (aws-production-server-survey.json):**
- Production-optimized instance types
- Required backup and monitoring
- Enhanced security options
- High availability settings

**Staging Survey (azure-staging-server-survey.json):**
- Cost-optimized VM sizes
- Development-friendly settings
- Optional backup policies
- Flexible security configurations

**Development Survey (gcp-development-server-survey.json):**
- Cost-optimized preemptible instances
- Development tools pre-installed
- Minimal monitoring and backup
- Rapid deployment options

### 6. API Integration for Automation

#### Relaunch Previous Deployment

```bash
#!/bin/bash
# Relaunch successful AWS production deployment

JOB_ID=12345  # Get from previous successful job
AAP_URL="https://your-aap-instance.com"
AAP_TOKEN="your-api-token"

curl -X POST "${AAP_URL}/api/v2/jobs/${JOB_ID}/relaunch/" \
  -H "Authorization: Bearer ${AAP_TOKEN}" \
  -H "Content-Type: application/json"
```

#### Launch with Configuration Override

```bash
#!/bin/bash
# Launch job template with modified configuration

TEMPLATE_ID=67890  # AWS Production template ID
AAP_URL="https://your-aap-instance.com"
AAP_TOKEN="your-api-token"

curl -X POST "${AAP_URL}/api/v2/job_templates/${TEMPLATE_ID}/launch/" \
  -H "Authorization: Bearer ${AAP_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "extra_vars": {
      "server_name": "web-server-prod-02",
      "instance_type": "t3.xlarge"
    }
  }'
```

### 7. Monitoring and Validation

#### Post-Deployment Validation

**Automatic Validation:**
- Infrastructure health checks
- Service connectivity tests
- Performance baseline validation
- Security compliance verification

**Manual Validation:**
- Application functionality testing
- User acceptance testing
- Performance testing
- Security penetration testing

#### Deployment Reporting

**AAP Job Reports:**
- Real-time deployment logs
- Error reporting and debugging
- Performance metrics
- Resource utilization

**Custom Reports:**
- Multi-cloud deployment summary
- Cost analysis reports
- Compliance validation reports
- Change management documentation

### 8. Best Practices Summary

#### Survey Design
✅ Use clear, descriptive question names
✅ Provide helpful help_text for complex fields
✅ Set appropriate defaults for each environment
✅ Use conditional logic to show relevant fields only

#### Configuration Management
✅ Store environment configurations in version control
✅ Use descriptive naming conventions
✅ Document configuration dependencies
✅ Implement configuration validation

#### Deployment Strategy
✅ Always include validation steps
✅ Implement proper error handling
✅ Use meaningful job names and descriptions
✅ Enable comprehensive logging and monitoring

#### Security
✅ Never store credentials in surveys or variables
✅ Use AAP credential store for all authentication
✅ Implement proper RBAC for environments
✅ Regular credential rotation and access review

---

This quick start guide provides practical examples for implementing survey persistence and redeployment across multiple cloud environments. The combination of environment-specific job templates, automated survey persistence, and workflow orchestration enables efficient and secure multi-cloud operations.
