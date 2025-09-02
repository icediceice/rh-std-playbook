#!/bin/bash
# Build script for ee-aix execution environment
# Builds directly using Docker without ansible-builder

set -e

# Configuration
IMAGE_NAME="ee-aix"
TAG="latest"
REGISTRY="localhost"

echo "Building AIX Management Execution Environment..."
echo "Image: ${REGISTRY}/${IMAGE_NAME}:${TAG}"

# Build the container image using podman
podman build -t "${REGISTRY}/${IMAGE_NAME}:${TAG}" .

# Verify the build
echo "Verifying the build..."
podman run --rm "${REGISTRY}/${IMAGE_NAME}:${TAG}" ansible --version
podman run --rm "${REGISTRY}/${IMAGE_NAME}:${TAG}" ansible-galaxy collection list

echo "Build completed successfully!"
echo "Image: ${REGISTRY}/${IMAGE_NAME}:${TAG}"