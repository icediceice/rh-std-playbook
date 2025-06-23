#!/bin/bash
# AAP Setup Script for RHEL Server Provisioning

echo "==================================="
echo "AAP RHEL Server Provisioning Setup"
echo "==================================="

# Check if running on AAP controller
if [ ! -d "/var/lib/awx" ] && [ ! -d "/opt/ansible-automation-platform" ]; then
    echo "WARNING: This doesn't appear to be an AAP controller node."
    echo "Continue anyway? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
        exit 1
    fi
fi

# Create directory structure
echo "Creating project directory structure..."
PLAYBOOK_DIR="/var/lib/awx/projects/rhel-server-provisioning"
mkdir -p "$PLAYBOOK_DIR"

# Copy files
echo "Copying project files..."
cp -r ./* "$PLAYBOOK_DIR/"

# Set permissions
echo "Setting permissions..."
chown -R awx:awx "$PLAYBOOK_DIR"
chmod -R 755 "$PLAYBOOK_DIR"

# Install collections
echo "Installing required collections..."
cd "$PLAYBOOK_DIR"
ansible-galaxy collection install -r collections/requirements.yml -p ./collections/

# Refresh package lists
echo "Refreshing package lists..."
ansible-playbook playbooks/refresh-packages.yml

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. In AAP Web UI, create a new project pointing to: $PLAYBOOK_DIR"
echo "2. Create a new job template using: playbooks/provision-server.yml"
echo "3. Import the survey from: surveys/server-provisioning-survey.json"
echo "4. Create an inventory with your RHEL target servers"
echo "5. Add credentials for accessing target servers"
echo ""
echo "For detailed instructions, see: $PLAYBOOK_DIR/docs/INSTALLATION.md"