#!/bin/bash
# Quick patch script to add community.general to existing Fortinet EE image
# This extends the existing image rather than rebuilding from scratch

set -e

# Configuration
REGISTRY="${REGISTRY:-your-registry}"
EXISTING_IMAGE="${EXISTING_IMAGE:-fortinet-ee}"
EXISTING_TAG="${EXISTING_TAG:-latest}"
NEW_TAG="${NEW_TAG:-latest-patched}"

echo "========================================="
echo "Patching Fortinet Execution Environment"
echo "========================================="
echo "Extending: ${REGISTRY}/${EXISTING_IMAGE}:${EXISTING_TAG}"
echo "Creating: ${REGISTRY}/${EXISTING_IMAGE}:${NEW_TAG}"
echo ""

# Update the Dockerfile with the correct base image
sed -i "s|FROM your-registry/fortinet-ee:latest|FROM ${REGISTRY}/${EXISTING_IMAGE}:${EXISTING_TAG}|g" Dockerfile.extend

# Build the extended image
echo "Building extended image..."
podman build -f Dockerfile.extend -t ${REGISTRY}/${EXISTING_IMAGE}:${NEW_TAG} .

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Build successful!"
    echo ""
    
    # Test the mail module is available
    echo "Testing mail module availability..."
    podman run --rm ${REGISTRY}/${EXISTING_IMAGE}:${NEW_TAG} \
        ansible-doc community.general.mail > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✓ Mail module is available in the image"
    else
        echo "⚠ Warning: Could not verify mail module"
    fi
    
    echo ""
    echo "To push to registry:"
    echo "  podman push ${REGISTRY}/${EXISTING_IMAGE}:${NEW_TAG}"
    echo ""
    echo "To use this image in AAP, update your EE to:"
    echo "  ${REGISTRY}/${EXISTING_IMAGE}:${NEW_TAG}"
    echo ""
    echo "To also update the 'latest' tag:"
    echo "  podman tag ${REGISTRY}/${EXISTING_IMAGE}:${NEW_TAG} ${REGISTRY}/${EXISTING_IMAGE}:latest"
    echo "  podman push ${REGISTRY}/${EXISTING_IMAGE}:latest"
else
    echo "✗ Build failed!"
    exit 1
fi