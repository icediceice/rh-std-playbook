#!/bin/bash
# Simple build script for Fortinet Execution Environment

set -e

echo "Building Fortinet Execution Environment for AAP 2.5..."
echo "=================================================="

# Build with ansible-builder
ansible-builder build \
  --tag fortinet-ee:latest \
  --tag fortinet-ee:$(date +%Y%m%d) \
  --verbosity 2

echo ""
echo "Build complete! Verifying installation..."
echo "========================================="

# Quick verification
podman run --rm fortinet-ee:latest ansible-galaxy collection list | grep fortinet || {
  echo "WARNING: Fortinet collection not found in image!"
  exit 1
}

echo ""
echo "Success! Fortinet EE is ready."
echo ""
echo "To use in AAP 2.5:"
echo "1. Tag: podman tag fortinet-ee:latest your-registry/fortinet-ee:latest"
echo "2. Push: podman push your-registry/fortinet-ee:latest"
echo "3. Add to AAP: Administration > Execution Environments"