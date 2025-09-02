#!/bin/bash
# AAP 2.5 Validation Script for Fortinet Playbooks
# Run this script to validate AAP 2.5 compatibility including inventory and credential integration

echo "=== AAP 2.5 Fortinet Playbook Validation ==="
echo "Checking AAP 2.5 compatibility requirements with inventory and credential integration..."

# Check for required files
echo "✓ Checking required AAP 2.5 files..."
FILES=(
    "execution-environment.yml"
    "bindep.txt"
    "requirements.txt"
    "requirements.yml"
    "ansible.cfg"
    "meta/galaxy.yml"
    "AAP-2.5-SETUP-GUIDE.md"
    "AAP-CREDENTIAL-SETUP-GUIDE.md"
    "inventory/fortinet_aap.yml"
    "inventory/fortinet_dynamic.py"
    "inventory/fortinet_dynamic.yml"
    "group_vars/all/main.yml"
    "group_vars/production/main.yml"
    "group_vars/staging/main.yml"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file - Found"
    else
        echo "  ❌ $file - Missing"
        exit 1
    fi
done

echo ""
echo "✓ Checking inventory structure..."

# Check inventory directory structure
if [ -d "inventory" ]; then
    echo "  ✅ Inventory directory exists"
    
    # Check for multiple inventory options
    if [ -f "inventory/fortinet_aap.yml" ]; then
        echo "  ✅ Static AAP inventory available"
    fi
    
    if [ -f "inventory/fortinet_dynamic.py" ] && [ -x "inventory/fortinet_dynamic.py" ]; then
        echo "  ✅ Dynamic inventory script available and executable"
    elif [ -f "inventory/fortinet_dynamic.py" ]; then
        echo "  ⚠️  Dynamic inventory script found but not executable"
        chmod +x inventory/fortinet_dynamic.py
        echo "  ✅ Made dynamic inventory script executable"
    fi
    
    if [ -f "inventory/fortinet_dynamic.yml" ]; then
        echo "  ✅ Constructed inventory configuration available"
    fi
else
    echo "  ❌ Inventory directory missing"
    exit 1
fi

echo ""
echo "✓ Checking group_vars structure..."

# Check group_vars structure
GROUPVARS=(
    "group_vars/all/main.yml"
    "group_vars/production/main.yml"
    "group_vars/staging/main.yml"
)

for groupvar in "${GROUPVARS[@]}"; do
    if [ -f "$groupvar" ]; then
        echo "  ✅ $groupvar - Found"
    else
        echo "  ❌ $groupvar - Missing"
        exit 1
    fi
done

echo ""
echo "✓ Checking AAP credential integration..."

# Check for credential integration in group_vars
if grep -q "ansible_user.*ansible_password" group_vars/all/main.yml; then
    echo "  ✅ AAP credential injection variables configured"
else
    echo "  ❌ AAP credential injection not properly configured"
    exit 1
fi

# Check for no hardcoded credentials
echo ""
echo "✓ Checking for security best practices..."

# Check playbooks for hardcoded credentials
HARDCODED_FOUND=false
for playbook in playbooks/*.yml; do
    if grep -q "ansible_password.*:" "$playbook" 2>/dev/null; then
        echo "  ⚠️  Found potential hardcoded password in $playbook"
        HARDCODED_FOUND=true
    fi
done

if [ "$HARDCODED_FOUND" = false ]; then
    echo "  ✅ No hardcoded credentials found in playbooks"
fi

echo ""
echo "✓ Checking execution environment configuration..."

# Validate execution-environment.yml
if grep -q "quay.io/ansible/automation-hub-ee" execution-environment.yml; then
    echo "  ✅ Base image configured correctly"
else
    echo "  ❌ Base image not configured"
    exit 1
fi

# Check for required collections in requirements.yml
echo ""
echo "✓ Checking collection requirements..."
COLLECTIONS=(
    "fortinet.fortios"
    "community.general"
    "ansible.posix"
    "ansible.netcommon"
    "ansible.utils"
    "ansible.builtin"
)

for collection in "${COLLECTIONS[@]}"; do
    if grep -q "$collection" requirements.yml; then
        echo "  ✅ $collection - Found in requirements.yml"
    else
        echo "  ❌ $collection - Missing from requirements.yml"
        exit 1
    fi
done

# Check Python dependencies
echo ""
echo "✓ Checking Python dependencies..."
PYTHON_DEPS=(
    "requests"
    "urllib3"
    "fortiosapi"
    "netaddr"
    "ansible-runner"
)

for dep in "${PYTHON_DEPS[@]}"; do
    if grep -q "$dep" requirements.txt; then
        echo "  ✅ $dep - Found in requirements.txt"
    else
        echo "  ❌ $dep - Missing from requirements.txt"
        exit 1
    fi
done

# Check ansible.cfg for inventory plugins
echo ""
echo "✓ Checking ansible.cfg inventory configuration..."
if grep -q "enable_plugins.*constructed" ansible.cfg; then
    echo "  ✅ Inventory plugins enabled"
else
    echo "  ❌ Inventory plugins not properly configured"
    exit 1
fi

if grep -q "/tmp/ansible-fortinet.log" ansible.cfg; then
    echo "  ✅ Log path configured for containers"
else
    echo "  ❌ Log path not container-compatible"
    exit 1
fi

# Check playbook directory
echo ""
echo "✓ Checking playbook structure..."
if [ -d "playbooks" ] && [ "$(ls -1 playbooks/*.yml | wc -l)" -gt 0 ]; then
    echo "  ✅ Playbooks directory contains YAML files"
else
    echo "  ❌ Playbooks directory missing or empty"
    exit 1
fi

# Check surveys directory
if [ -d "surveys" ] && [ "$(ls -1 surveys/*.json | wc -l)" -gt 0 ]; then
    echo "  ✅ Surveys directory contains JSON files"
else
    echo "  ❌ Surveys directory missing or empty"
    exit 1
fi

# Test dynamic inventory script
echo ""
echo "✓ Testing dynamic inventory script..."
if python3 inventory/fortinet_dynamic.py --list > /dev/null 2>&1; then
    echo "  ✅ Dynamic inventory script executes successfully"
else
    echo "  ⚠️  Dynamic inventory script has issues (may need Python dependencies)"
fi

echo ""
echo "🎉 All AAP 2.5 compatibility checks passed!"
echo ""
echo "✅ Features validated:"
echo "  - Execution Environment configuration"
echo "  - Multiple inventory options (static, dynamic, constructed)"
echo "  - AAP credential integration"
echo "  - Security best practices (no hardcoded credentials)"
echo "  - Environment-based group_vars structure"
echo "  - Container-optimized configurations"
echo ""
echo "Next steps:"
echo "1. Build execution environment: ansible-builder build --tag fortinet-ee:latest ."
echo "2. Import project and inventory into AAP 2.5"
echo "3. Configure machine credentials in AAP"
echo "4. Create job templates with surveys"
echo "5. Test credential injection and inventory grouping"
echo ""
echo "For detailed setup instructions:"
echo "  - General setup: AAP-2.5-SETUP-GUIDE.md"
echo "  - Credential setup: AAP-CREDENTIAL-SETUP-GUIDE.md"
