#!/bin/bash
# Script to refresh package lists from RHEL repositories

PLAYBOOK_DIR="$(dirname "$0")/.."

echo "Refreshing RHEL package lists..."
echo "This will update the package lists based on available RHEL repositories."

# Run the refresh playbook
ansible-playbook "$PLAYBOOK_DIR/playbooks/refresh-packages.yml" -i localhost,

echo "Package lists refreshed successfully!"
echo "The updated lists are available in: $PLAYBOOK_DIR/package-lists/"