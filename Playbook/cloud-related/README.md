# Cloud-Related Ansible Playbooks for AAP 2.5

This repository provides enterprise-grade, cloud-agnostic Ansible playbooks optimized for **Ansible Automation Platform (AAP) 2.5** web console and execution environments. The playbooks support provisioning, managing, and auditing resources across AWS, Azure, and GCP with comprehensive surveys and best practices.

## Key Features
- **AAP 2.5 Optimized**: Fully compatible with execution environments and web console
- **AAP Credential Integration**: Uses AAP credential store directly - no credential input required
- **Modular Roles**: Cloud-agnostic roles for servers, storage, networking, security, and auditing
- **Multi-Cloud Support**: Unified interface for AWS, Azure, and GCP operations
- **Dynamic Surveys**: Context-aware questions with help text and validation
- **Secure Authentication**: Direct integration with AAP credential store for maximum security
- **Execution Environment Ready**: Complete EE configuration with all dependencies
- **Email Reporting**: Optional SMTP-based reporting for unused resources
- **Workflow Orchestration**: End-to-end cloud environment setup automation

## AAP 2.5 Requirements

### Required Collections for Execution Environment
The following collections must be available in your execution environment:

```yaml
collections:
  # AWS Operations
  - amazon.aws (>=6.0.0)
  
  # Azure Operations  
  - azure.azcollection (>=1.19.0)
  
  # Google Cloud Operations
  - google.cloud (>=1.2.0)
  
  # Core Ansible Collections
  - ansible.posix (>=1.5.0)
  - ansible.utils (>=3.0.0)
  
  # Community Collections
  - community.general (>=8.0.0)
  - community.crypto (>=2.0.0)
  
  # Kubernetes (optional)
  - kubernetes.core (>=2.4.0)
```

### Python Dependencies
Your execution environment must include:
- `boto3>=1.26.0` (AWS)
- `azure-identity>=1.12.0` (Azure)  
- `google-auth>=2.15.0` (GCP)
- See `requirements.txt` for complete list

## Structure

```yaml
cloud-related/
  playbooks/
    cloud-auth.yml                        # Cloud authentication validation
    provision-server.yml                  # Server/VM provisioning  
    provision-pvc.yml                     # Storage/volume provisioning
    setup-cloud-env.yml                   # Network and security setup
    query-unused-resources.yml            # Resource auditing
    workflow_cloud_setup.yml              # Complete environment workflow
    multi_cloud_deployment_workflow.yml   # Advanced multi-cloud orchestration
  surveys/
    # Generic surveys
    cloud-auth-survey.json
    provision-server-survey.json
    provision-pvc-survey.json
    setup-cloud-env-survey.json
    query-unused-resources-survey.json
    workflow-cloud-setup-survey.json
    multi-cloud-workflow-survey.json
    # Environment-specific surveys
    aws-production-server-survey.json
    azure-staging-server-survey.json
    gcp-development-server-survey.json
  env-configs/
    aws-production.yml                    # AWS production configuration
    azure-staging.yml                     # Azure staging configuration
    gcp-development.yml                   # GCP development configuration
  tasks/
    deploy_single_environment.yml         # Single environment deployment
    validate_deployment.yml               # Post-deployment validation
    validate_*_credentials.yml            # Cloud-specific credential validation
  execution-environment.yml              # EE configuration
  requirements.yml                       # Ansible collections
  requirements.txt                       # Python packages
  bindep.txt                            # System dependencies
  ansible.cfg                           # Ansible configuration
  SURVEY-PERSISTENCE-GUIDE.md           # Detailed redeployment guide
```

## Getting Started

### 1. Authenticate to Your Cloud Provider
Run the authentication playbook to securely store and encrypt your credentials:
```sh
ansible-playbook playbooks/cloud-auth.yml
```
- Fill out the dynamic survey. Credentials will be encrypted and saved for reuse.

### 2. Provision Resources
You can provision servers, storage, and networks by running the respective playbooks:
```sh
ansible-playbook playbooks/provision-server.yml
ansible-playbook playbooks/provision-pvc.yml
ansible-playbook playbooks/setup-cloud-env.yml
```
- Each playbook will prompt you with a dynamic survey for the selected cloud provider.

### 3. Query Unused Resources
Audit unused resources (e.g., stopped/unused VMs) and save the results:
```sh
ansible-playbook playbooks/query-unused-resources.yml
```
- Results are displayed and saved to a file for review.

### 4. Full Workflow
To run a full environment setup and audit in sequence:
```sh
ansible-playbook playbooks/workflow_cloud_setup.yml
```

## Security

- All credentials are managed through AAP credential store - no credentials stored in playbooks or surveys
- Sensitive fields in surveys are minimized since authentication is handled by AAP
- Direct integration with cloud provider APIs using AAP-managed credentials
- RBAC controls access to credentials and playbook execution

## Customization

- Modify playbooks directly to add new cloud resources or providers
- Update surveys to match your organization's requirements  
- Extend execution environment with additional collections as needed
- Customize workflow templates for your specific use cases

## Requirements
- Ansible 2.10+
- Ansible collections for AWS, Azure, and GCP (see requirements.yml if provided)
- Ansible Automation Platform (AAP) for survey and workflow features

## Support
For questions or contributions, please open an issue or pull request.

## Email Reporting
- To use the email reporting feature for unused resources, you must set the following variables (can be in your prefilled vars file or survey):

  - smtp_host: SMTP server hostname (e.g., smtp.gmail.com)
  - smtp_port: SMTP server port (default: 587)
  - smtp_username: SMTP username (if required)
  - smtp_password: SMTP password (if required)
  - report_email_to: Recipient email address
  - report_email_from: Sender email address

- Required Ansible collections (install with `ansible-galaxy collection install -r requirements.yml`):
  - amazon.aws
  - azure.azcollection
  - google.cloud
  - community.general

## Using with Ansible Automation Platform (AAP) 2.5 Web Console

These playbooks are specifically optimized for AAP 2.5 web console with complete execution environment support.

### 1. Execution Environment Setup

#### Building the Execution Environment
```bash
# Build using ansible-builder
ansible-builder build -t cloud-operations-ee:latest -v 3 .

# Or use podman/docker directly
podman build -f execution-environment.yml -t cloud-operations-ee:latest .
```

#### Required Files for EE
- `execution-environment.yml` - EE configuration
- `requirements.yml` - Ansible collections  
- `requirements.txt` - Python packages
- `bindep.txt` - System dependencies

### 2. AAP Project and Job Template Setup

#### Step 1: Create Project
1. Navigate to **Projects** in AAP web console
2. Click **Add** to create new project
3. Configure project source (Git, etc.) pointing to this repository
4. Select the execution environment: `cloud-operations-ee:latest`

#### Step 2: Create Credentials
Create credentials for each cloud provider:

**AWS Credential:**
- Type: Amazon Web Services
- Fields: Access Key ID, Secret Access Key, Session Token (optional)

**Azure Credential:**
- Type: Microsoft Azure Resource Manager  
- Fields: Client ID, Client Secret, Tenant ID, Subscription ID

**GCP Credential:**
- Type: Google Compute Engine
- Fields: Service Account JSON

#### Step 3: Create Job Templates
Create job templates for each playbook:

```yaml
# Example: Provision Server Job Template
Name: "Cloud - Provision Server"
Project: "Cloud Operations"
Playbook: "playbooks/provision-server.yml"
Inventory: "localhost" or your cloud inventory
Execution Environment: "cloud-operations-ee:latest"
Credentials: [AWS/Azure/GCP credential based on usage]
Survey: Enable and import "surveys/provision-server-survey.json"
Variables: 
  ansible_connection: local
  ansible_python_interpreter: "{{ ansible_playbook_python }}"
```

### 3. Survey Configuration

Each playbook includes an optimized survey with:
- **Dynamic questions** based on cloud provider selection
- **Input validation** and help text
- **Secure fields** for passwords and secrets
- **Default values** for common configurations

#### Importing Surveys
1. Go to Job Template
2. Click **Survey** tab
3. Toggle **Survey Enabled**
4. Import survey JSON or create manually
5. Preview survey to test user experience

### 4. Running Jobs

#### From AAP Web Console:
1. Navigate to **Templates**
2. Click the **Launch** button for desired job template
3. Fill out the survey form (first time)
4. Click **Launch** to start execution
5. Monitor progress in real-time via **Jobs** view

#### Survey Persistence & Redeployment:
AAP 2.5 supports reusing previous survey answers for consistent deployments:

**Save Survey Configuration:**
1. After successful job completion, go to **Jobs** → **Completed Job**
2. Click **Relaunch** to see saved survey values
3. Or use **Launch with Survey** to modify and save new values

**Multi-Cloud Deployment Strategy:**
```yaml
# Example: Separate configurations for different environments
AWS Production:
  - Job Template: "Cloud-AWS-Production"
  - Survey Config: Saved with AWS-specific values
  - Relaunch: Uses saved AWS config without survey

Azure Staging:
  - Job Template: "Cloud-Azure-Staging" 
  - Survey Config: Saved with Azure-specific values
  - Relaunch: Uses saved Azure config without survey

GCP Development:
  - Job Template: "Cloud-GCP-Development"
  - Survey Config: Saved with GCP-specific values
  - Relaunch: Uses saved GCP config without survey
```

**Automated Redeployment:**
- Use **Job Template Extra Variables** to override survey defaults
- Create **Workflow Templates** with pre-configured values
- Use **AAP API** for programmatic deployment with saved configs

#### Job Output Features:
- Real-time log streaming
- Error highlighting and problem detection
- Downloadable logs and artifacts
- Email notifications on completion/failure

### 5. Best Practices for AAP 2.5

#### Execution Environment Best Practices:
- Use specific collection versions in `requirements.yml`
- Pin Python package versions in `requirements.txt`
- Test EE builds in development before production
- Use multi-stage builds for optimization

#### Playbook Best Practices:
- Always use `hosts: all` instead of `localhost`
- Leverage `ansible.builtin.*` for core modules
- Use fully qualified collection names (e.g., `amazon.aws.ec2_instance`)
- Implement proper error handling with `block/rescue`
- Use `vars_files` for external variable loading

#### Survey Best Practices:
- Use `type: password` for all sensitive fields
- Provide `help_text` for complex fields
- Set appropriate `default` values
- Use `when` conditions for cloud-specific questions
- Test surveys thoroughly before production use

#### Security Best Practices:
- **Use AAP Credential Store**: All cloud credentials are managed through AAP - never hardcode in playbooks
- **No Credential Input**: Surveys don't collect credentials - they come from AAP credential assignments
- **RBAC Access Control**: Use AAP's role-based access to control who can execute playbooks
- **Credential Rotation**: Regularly rotate cloud credentials through AAP credential management
- **Least Privilege**: Assign only necessary cloud permissions to service accounts/users

### 6. Multi-Cloud Deployment Strategy

#### Setup for Multiple Cloud Environments

**Option 1: Separate Job Templates per Cloud**
Create dedicated job templates for each cloud provider:

```yaml
Job Templates:
  "AWS-Production-Server":
    Playbook: "playbooks/provision-server.yml"
    Credentials: [AWS-Prod-Cred]
    Extra Variables:
      cloud_provider: "aws"
      environment: "production"
      region: "us-east-1"
  
  "Azure-Staging-Server":
    Playbook: "playbooks/provision-server.yml" 
    Credentials: [Azure-Staging-Cred]
    Extra Variables:
      cloud_provider: "azure"
      environment: "staging"
      region: "eastus"
  
  "GCP-Development-Server":
    Playbook: "playbooks/provision-server.yml"
    Credentials: [GCP-Dev-Cred]
    Extra Variables:
      cloud_provider: "gcp"
      environment: "development"
      region: "us-central1"
```

**Option 2: Single Template with Dynamic Configuration**
Use one job template with environment-specific extra variables:

```yaml
Job Template: "Multi-Cloud-Server-Provisioning"
Survey Variables:
  - cloud_provider (aws/azure/gcp)
  - environment (dev/staging/prod)
  - deployment_config (predefined config name)

Extra Variables (Environment Specific):
  aws_prod:
    region: "us-east-1"
    instance_type: "t3.large"
    vpc_cidr: "10.0.0.0/16"
  
  azure_staging:
    region: "eastus"
    instance_type: "Standard_B2s"
    vpc_cidr: "10.1.0.0/16"
  
  gcp_dev:
    region: "us-central1"
    instance_type: "n1-standard-1"
    vpc_cidr: "10.2.0.0/16"
```

#### Survey Configuration Persistence

**Method 1: AAP Survey Persistence (Built-in)**
1. Run job template with survey
2. AAP automatically saves last survey values
3. Use **Relaunch** button to deploy with same config
4. Modify only necessary fields for different environments

**Method 2: Extra Variables Override**
1. Set default values in Job Template Extra Variables
2. Survey values override defaults when provided
3. Skip survey for automated deployments using saved configs

#### Deployment Workflows

**Scenario 1: Initial Multi-Cloud Setup**
```yaml
Workflow: "Multi-Cloud-Initial-Deployment"
1. AWS Environment Setup
2. Azure Environment Setup  
3. GCP Environment Setup
4. Cross-Cloud Network Peering (Optional)
5. Multi-Cloud Monitoring Setup
```

**Scenario 2: Environment-Specific Deployment**
```yaml
Workflow: "Environment-Specific-Deployment"
1. Survey Input: Select cloud_provider + environment
2. Validate Credentials for Selected Cloud
3. Setup Environment (if needed)
4. Provision Resources
5. Configure Monitoring
6. Send Notification
```

**Scenario 3: Disaster Recovery Deployment**
```yaml
Workflow: "DR-Failover-Deployment"
1. Detect Primary Cloud Failure
2. Launch DR Environment on Secondary Cloud
3. Restore Data from Backups
4. Update DNS/Load Balancer
5. Notify Operations Team
```

### 7. Monitoring and Troubleshooting

#### Common Issues and Solutions:

**Collection Not Found:**
- Verify collection is listed in `requirements.yml`
- Rebuild execution environment
- Check collection version compatibility

**Authentication Failures:**
- Verify credentials in AAP credential store
- Check cloud provider permissions
- Validate credential field mapping

**Module Import Errors:**
- Check Python dependencies in `requirements.txt`
- Verify system packages in `bindep.txt`
- Review execution environment build logs

#### Debugging Tools:
- Use `ansible.builtin.debug` for variable inspection
- Enable verbose logging with `-vvv` in job template
- Review job artifacts and stdout
- Check execution environment logs

### 8. Performance Optimization

#### For Large Environments:
- Use `async` tasks for long-running operations
- Implement `throttle` for API rate limiting
- Use `batch` processing for bulk operations
- Enable fact caching for repeated runs

#### Resource Management:
- Set appropriate job timeouts
- Configure concurrent job limits
- Monitor execution environment resource usage
- Implement cleanup tasks for temporary resources

---

## 🔄 **AAP 2.5 Credential Store Integration**

This project has been **optimized for AAP 2.5** with direct credential store integration:

### ✅ **Key Changes Made:**

**🔐 Authentication Refactor:**
- **Removed credential collection** from surveys and playbooks
- **Direct AAP integration** - credentials come from AAP credential store
- **Enhanced security** - no credential storage in playbooks or files
- **Simplified surveys** - removed all authentication input fields

**🎯 Playbook Optimization:**
- **Direct module calls** instead of custom roles for better performance
- **Fully qualified collection names** for AAP 2.5 compatibility  
- **Proper error handling** and validation
- **AAP credential injection** - credentials automatically available

**📋 Survey Streamlining:**
- **Removed authentication fields** - handled by AAP credentials
- **Added help text** and validation for better user experience
- **Optimized field types** and defaults
- **Conditional logic** for cloud-specific questions

**🗂️ Structure Cleanup:**
- **Removed unused roles** directory (using direct modules)
- **Removed credential files** and prefilled vars
- **Streamlined file structure** for AAP deployment
- **Updated documentation** with AAP-specific guidance

### 🚀 **Ready for Production:**
- ✅ **AAP 2.5 Web Console** ready
- ✅ **Execution Environment** configured  
- ✅ **Credential Store** integrated
- ✅ **Survey optimization** complete
- ✅ **Security best practices** implemented

---
This project is designed for rapid, secure, and flexible cloud automation with AAP 2.5. Enjoy!
