# AAP 2.5 Multi-Cloud Survey Persistence & Redeployment Guide

This guide provides comprehensive instructions for implementing survey persistence and redeployment strategies for multi-cloud environments using Ansible Automation Platform (AAP) 2.5.

## Table of Contents

1. [Survey Persistence Strategies](#survey-persistence-strategies)
2. [Environment-Specific Job Templates](#environment-specific-job-templates)
3. [Redeployment Workflows](#redeployment-workflows)
4. [Survey Configuration Examples](#survey-configuration-examples)
5. [Advanced Deployment Patterns](#advanced-deployment-patterns)
6. [Troubleshooting](#troubleshooting)

## Survey Persistence Strategies

### Strategy 1: AAP Built-in Survey Persistence

AAP 2.5 automatically saves the last used survey values for each job template. This enables easy redeployment with the same configuration.

**Implementation:**
1. Create job template with survey enabled
2. Run the job template and fill out the survey
3. AAP automatically saves the survey responses
4. Use **Relaunch** button to redeploy with saved values
5. Use **Launch with Survey** to modify values before deployment

**Benefits:**
- No additional configuration required
- Immediate access to last-used values
- Built into AAP workflow

**Limitations:**
- Only stores the most recent survey response
- No versioning of survey configurations

### Strategy 2: Environment-Specific Job Templates

Create separate job templates for each cloud environment with pre-configured extra variables.

**Implementation:**

#### AWS Production Job Template
```yaml
Job Template: "AWS-Production-Server-Provisioning"
Playbook: "playbooks/provision-server.yml"
Credentials: [AWS-Production-Credential]
Survey: "surveys/aws-production-server-survey.json"
Extra Variables:
  cloud_provider: "aws"
  environment: "production"
  region: "us-east-1"
  instance_type: "t3.large"
  vpc_cidr: "10.0.0.0/16"
  # Include environment config
  @env-configs/aws-production.yml
```

#### Azure Staging Job Template
```yaml
Job Template: "Azure-Staging-Server-Provisioning"
Playbook: "playbooks/provision-server.yml"
Credentials: [Azure-Staging-Credential]
Survey: "surveys/azure-staging-server-survey.json"
Extra Variables:
  cloud_provider: "azure"
  environment: "staging"
  location: "eastus"
  vm_size: "Standard_B2ms"
  # Include environment config
  @env-configs/azure-staging.yml
```

#### GCP Development Job Template
```yaml
Job Template: "GCP-Development-Server-Provisioning"
Playbook: "playbooks/provision-server.yml"
Credentials: [GCP-Development-Credential]
Survey: "surveys/gcp-development-server-survey.json"
Extra Variables:
  cloud_provider: "gcp"
  environment: "development"
  zone: "us-central1-a"
  machine_type: "e2-medium"
  # Include environment config
  @env-configs/gcp-development.yml
```

### Strategy 3: Workflow Templates with Configuration Sets

Create workflow templates that chain multiple job templates with predefined configurations.

**Multi-Cloud Deployment Workflow:**
```yaml
Workflow Template: "Multi-Cloud-Environment-Deployment"
Survey: "surveys/multi-cloud-workflow-survey.json"

Workflow Steps:
1. AWS Production Setup
   - Job Template: "AWS-Production-Server-Provisioning"
   - Run Condition: "environments_to_deploy contains 'aws_prod'"
   
2. Azure Staging Setup
   - Job Template: "Azure-Staging-Server-Provisioning"
   - Run Condition: "environments_to_deploy contains 'azure_staging'"
   
3. GCP Development Setup
   - Job Template: "GCP-Development-Server-Provisioning"
   - Run Condition: "environments_to_deploy contains 'gcp_dev'"
   
4. Cross-Cloud Networking (Optional)
   - Job Template: "Cross-Cloud-VPN-Setup"
   - Run Condition: "enable_cross_cloud_networking == 'yes'"
   
5. Monitoring Setup
   - Job Template: "Multi-Cloud-Monitoring-Setup"
   - Run Condition: "enable_monitoring == 'yes'"
```

## Environment-Specific Job Templates

### Creating Environment-Specific Templates

Each environment should have its own job template with optimized surveys and default values:

#### 1. AWS Production Template Setup

**Extra Variables:**
```yaml
# Load environment configuration
@env-configs/aws-production.yml

# Override survey defaults for production
security_level: "high"
backup_enabled: true
monitoring_level: "detailed"
auto_scaling_enabled: true
```

**Survey Configuration:**
- Use `surveys/aws-production-server-survey.json`
- Production-optimized instance types
- Required backup and monitoring settings
- Enhanced security options

#### 2. Azure Staging Template Setup

**Extra Variables:**
```yaml
# Load environment configuration
@env-configs/azure-staging.yml

# Override survey defaults for staging
security_level: "medium"
backup_enabled: true
monitoring_level: "basic"
auto_scaling_enabled: false
cost_optimization: true
```

**Survey Configuration:**
- Use `surveys/azure-staging-server-survey.json`
- Cost-optimized VM sizes
- Staging-appropriate backup policies
- Development-friendly settings

#### 3. GCP Development Template Setup

**Extra Variables:**
```yaml
# Load environment configuration
@env-configs/gcp-development.yml

# Override survey defaults for development
security_level: "basic"
backup_enabled: false
monitoring_level: "minimal"
auto_scaling_enabled: false
preemptible_instances: true
```

**Survey Configuration:**
- Use `surveys/gcp-development-server-survey.json`
- Cost-optimized with preemptible instances
- Development tools pre-installed
- Minimal monitoring and backup

## Redeployment Workflows

### 1. Immediate Redeployment

**Using AAP Web Console:**
1. Navigate to **Jobs** → **Completed Jobs**
2. Find the successful deployment job
3. Click **Relaunch** button
4. Job runs with identical configuration
5. No survey required - uses saved values

**Using AAP API:**
```bash
# Get the job ID from a successful deployment
JOB_ID=12345

# Relaunch the job with same configuration
curl -X POST \
  "${AAP_URL}/api/v2/jobs/${JOB_ID}/relaunch/" \
  -H "Authorization: Bearer ${AAP_TOKEN}" \
  -H "Content-Type: application/json"
```

### 2. Modified Redeployment

**Using AAP Web Console:**
1. Navigate to **Templates** → Select job template
2. Click **Launch** button
3. Survey shows last-used values as defaults
4. Modify only necessary fields
5. Launch with updated configuration

**Using AAP API:**
```bash
# Launch job template with modified survey values
curl -X POST \
  "${AAP_URL}/api/v2/job_templates/${TEMPLATE_ID}/launch/" \
  -H "Authorization: Bearer ${AAP_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "extra_vars": {
      "server_name": "new-server-name",
      "instance_type": "t3.xlarge"
    }
  }'
```

### 3. Bulk Redeployment

**Workflow Template Approach:**
```yaml
Workflow Template: "Bulk-Redeployment"
Input: Environment list and configuration updates

Steps:
1. Load saved configurations for each environment
2. Apply configuration updates/overrides
3. Deploy to each environment in parallel or sequence
4. Validate deployments
5. Send consolidated report
```

**Example Survey for Bulk Redeployment:**
```json
[
  {
    "variable": "environments_to_redeploy",
    "question_name": "Environments to Redeploy",
    "type": "multiselect",
    "choices": ["aws_prod", "azure_staging", "gcp_dev"],
    "required": true
  },
  {
    "variable": "configuration_updates",
    "question_name": "Configuration Updates (JSON)",
    "type": "textarea",
    "help_text": "JSON object with configuration updates to apply"
  },
  {
    "variable": "deployment_mode",
    "question_name": "Deployment Mode",
    "type": "multiplechoice",
    "choices": ["parallel", "sequential"],
    "default": "sequential"
  }
]
```

## Survey Configuration Examples

### Environment-Aware Survey Logic

**Dynamic Survey Example:**
```json
[
  {
    "variable": "deployment_type",
    "question_name": "Deployment Type",
    "type": "multiplechoice",
    "choices": ["new_deployment", "redeployment", "scale_out"],
    "required": true
  },
  {
    "variable": "source_deployment_id",
    "question_name": "Source Deployment Job ID",
    "type": "text",
    "required": true,
    "when": "deployment_type == 'redeployment'",
    "help_text": "Job ID to copy configuration from"
  },
  {
    "variable": "scale_factor",
    "question_name": "Scale Factor",
    "type": "integer",
    "min": 1,
    "max": 10,
    "default": 2,
    "required": true,
    "when": "deployment_type == 'scale_out'",
    "help_text": "Number of additional instances to create"
  }
]
```

### Configuration Template Survey

**Template-Based Configuration:**
```json
[
  {
    "variable": "config_template",
    "question_name": "Configuration Template",
    "type": "multiplechoice",
    "choices": [
      "web_server_template",
      "database_server_template", 
      "application_server_template",
      "custom_configuration"
    ],
    "required": true,
    "help_text": "Pre-defined configuration template"
  },
  {
    "variable": "custom_config_json",
    "question_name": "Custom Configuration (JSON)",
    "type": "textarea",
    "required": false,
    "when": "config_template == 'custom_configuration'",
    "help_text": "Custom configuration in JSON format"
  }
]
```

## Advanced Deployment Patterns

### 1. Blue-Green Deployment

**Workflow Steps:**
1. **Green Environment Deployment** (Staging)
   - Deploy to staging environment
   - Run validation tests
   - Performance testing
   
2. **Traffic Switch Preparation**
   - Update load balancer configuration
   - Prepare DNS updates
   - Backup current production state
   
3. **Blue Environment Deployment** (Production)
   - Deploy to production with green configuration
   - Gradual traffic switching
   - Monitor performance metrics
   
4. **Rollback Capability**
   - Keep previous version available
   - Quick rollback mechanism
   - Automated health checks

**Survey Configuration:**
```json
[
  {
    "variable": "deployment_phase",
    "question_name": "Deployment Phase",
    "type": "multiplechoice",
    "choices": ["green_deploy", "blue_deploy", "traffic_switch", "rollback"],
    "required": true
  },
  {
    "variable": "traffic_percentage",
    "question_name": "Traffic Percentage to New Version",
    "type": "integer",
    "min": 0,
    "max": 100,
    "default": 10,
    "when": "deployment_phase == 'traffic_switch'"
  }
]
```

### 2. Canary Deployment

**Implementation:**
1. Deploy new version to small subset of infrastructure
2. Monitor metrics and performance
3. Gradually increase deployment percentage
4. Full rollout or rollback based on metrics

### 3. Rolling Deployment

**Implementation:**
1. Deploy to one availability zone at a time
2. Validate each zone before proceeding
3. Maintain service availability throughout process
4. Automatic rollback on failure

## Configuration Management

### Environment Configuration Files

Store environment-specific configurations in separate files:

```
env-configs/
├── aws-production.yml      # AWS production settings
├── azure-staging.yml       # Azure staging settings
├── gcp-development.yml     # GCP development settings
├── common.yml              # Shared configuration
└── templates/
    ├── web-server.yml      # Web server template
    ├── database.yml        # Database server template
    └── application.yml     # Application server template
```

### Survey Response Storage

**AAP Database:**
- AAP stores survey responses in its database
- Accessible via API for automation
- Can be exported for backup/migration

**External Storage:**
- Export survey configurations to Git repository
- Store in external configuration management system
- Version control for survey responses

## Troubleshooting

### Common Issues

#### 1. Survey Values Not Persisting

**Symptoms:**
- Survey shows empty fields on relaunch
- Extra variables not being applied

**Solutions:**
```yaml
# Ensure survey is properly enabled in job template
Survey Enabled: true

# Check extra variables format
Extra Variables:
  variable_name: "value"
  # Not: variable_name = "value"

# Verify survey field names match playbook variables
Survey Variable: "server_name"
Playbook Variable: "{{ server_name }}"
```

#### 2. Environment-Specific Configuration Not Loading

**Symptoms:**
- Wrong configuration applied to environment
- Default values used instead of environment-specific

**Solutions:**
```yaml
# Use proper file inclusion in extra variables
@env-configs/aws-production.yml

# Verify file path is relative to project root
# Check file permissions in AAP execution environment

# Use include_vars in playbook for dynamic loading
- name: Load environment configuration
  include_vars: "env-configs/{{ cloud_provider }}-{{ environment }}.yml"
```

#### 3. Workflow Template Conditionals Not Working

**Symptoms:**
- Workflow steps running when they shouldn't
- Conditions not evaluating correctly

**Solutions:**
```yaml
# Use proper Jinja2 syntax in workflow conditions
Correct: environments_to_deploy is contains('aws_prod')
Wrong: environments_to_deploy == 'aws_prod'

# For multiple choice surveys with lists
Correct: "'aws_prod' in environments_to_deploy"
Wrong: "environments_to_deploy == 'aws_prod'"
```

### Best Practices

1. **Survey Design:**
   - Use clear, descriptive question names
   - Provide helpful help_text for complex fields
   - Set appropriate defaults for each environment
   - Use conditional logic to show relevant fields only

2. **Configuration Management:**
   - Store environment configurations in version control
   - Use descriptive naming conventions
   - Document configuration dependencies
   - Implement configuration validation

3. **Deployment Workflows:**
   - Always include validation steps
   - Implement proper error handling
   - Use meaningful job names and descriptions
   - Enable logging and monitoring

4. **Security:**
   - Never store credentials in surveys or extra variables
   - Use AAP credential store for all authentication
   - Implement proper RBAC for different environments
   - Regular credential rotation

5. **Testing:**
   - Test surveys in development environment first
   - Validate workflow conditionals thoroughly
   - Implement dry-run capabilities
   - Use staging environments for complex workflows

---

This guide provides a comprehensive approach to implementing survey persistence and redeployment strategies for multi-cloud environments. The combination of AAP's built-in survey persistence, environment-specific job templates, and workflow orchestration provides a robust foundation for managing complex cloud deployments.
