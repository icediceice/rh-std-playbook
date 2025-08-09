#!/bin/bash
# Fortinet Execution Environment Rebuild Script for AAP 2.5
# This script builds a custom EE with all required Fortinet collections and dependencies

set -e

# Configuration
EE_NAME="fortinet-ee"
EE_TAG="latest"
REGISTRY="${REGISTRY:-quay.io/your-org}"  # Update with your registry
BUILD_ARGS=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Fortinet Execution Environment Builder for AAP 2.5 ===${NC}"
echo

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"
command -v ansible-builder >/dev/null 2>&1 || { echo -e "${RED}ERROR: ansible-builder is not installed. Install with: pip install ansible-builder${NC}"; exit 1; }
command -v podman >/dev/null 2>&1 || command -v docker >/dev/null 2>&1 || { echo -e "${RED}ERROR: Neither podman nor docker is installed${NC}"; exit 1; }

# Determine container runtime
if command -v podman >/dev/null 2>&1; then
    CONTAINER_RUNTIME="podman"
else
    CONTAINER_RUNTIME="docker"
fi
echo -e "${GREEN}Using container runtime: ${CONTAINER_RUNTIME}${NC}"

# Clean up old images (optional)
read -p "Do you want to remove old images first? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Removing old images...${NC}"
    ${CONTAINER_RUNTIME} rmi ${EE_NAME}:${EE_TAG} 2>/dev/null || true
    ${CONTAINER_RUNTIME} rmi ${EE_NAME}:build 2>/dev/null || true
fi

# Validate files exist
echo -e "${YELLOW}Validating configuration files...${NC}"
for file in execution-environment.yml requirements.yml requirements.txt bindep.txt; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}ERROR: Required file $file not found${NC}"
        exit 1
    fi
done
echo -e "${GREEN}All configuration files found${NC}"

# Build the execution environment
echo -e "${YELLOW}Building execution environment...${NC}"
echo -e "${YELLOW}This may take several minutes...${NC}"

ansible-builder build \
    --tag ${EE_NAME}:${EE_TAG} \
    --tag ${EE_NAME}:$(date +%Y%m%d-%H%M%S) \
    --file execution-environment.yml \
    --container-runtime ${CONTAINER_RUNTIME} \
    --verbosity 3 \
    ${BUILD_ARGS}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build completed successfully!${NC}"
    
    # Verify the build
    echo -e "${YELLOW}Verifying the build...${NC}"
    ${CONTAINER_RUNTIME} run --rm ${EE_NAME}:${EE_TAG} ansible-galaxy collection list | grep fortinet
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Fortinet collection verified in the image!${NC}"
    else
        echo -e "${RED}WARNING: Fortinet collection not found in the image${NC}"
    fi
    
    # Display image info
    echo -e "${YELLOW}Image information:${NC}"
    ${CONTAINER_RUNTIME} images | grep ${EE_NAME}
    
    # Provide next steps
    echo
    echo -e "${GREEN}=== Next Steps ===${NC}"
    echo "1. Tag the image for your registry:"
    echo "   ${CONTAINER_RUNTIME} tag ${EE_NAME}:${EE_TAG} ${REGISTRY}/${EE_NAME}:${EE_TAG}"
    echo
    echo "2. Push to your registry:"
    echo "   ${CONTAINER_RUNTIME} push ${REGISTRY}/${EE_NAME}:${EE_TAG}"
    echo
    echo "3. Update AAP 2.5:"
    echo "   - Go to Administration → Execution Environments"
    echo "   - Add/Update the EE with image: ${REGISTRY}/${EE_NAME}:${EE_TAG}"
    echo "   - Set pull credentials if needed"
    echo
    echo "4. Update your Job Templates to use this EE"
    
    # Optional: Test the image
    echo
    read -p "Do you want to test the image with a sample playbook? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Creating test playbook...${NC}"
        cat > test-ee.yml << 'EOF'
---
- name: Test Fortinet EE
  hosts: localhost
  gather_facts: no
  tasks:
    - name: List installed collections
      command: ansible-galaxy collection list
      register: collections
    
    - name: Display Fortinet collection
      debug:
        msg: "{{ collections.stdout_lines | select('match', '.*fortinet.*') | list }}"
    
    - name: Test Fortinet module import
      fortinet.fortios.fortios_system_global:
        vdom: root
      check_mode: yes
      ignore_errors: yes
      register: module_test
    
    - name: Check module availability
      debug:
        msg: "Fortinet module is {{ 'available' if module_test is not failed else 'not available' }}"
EOF
        
        echo -e "${YELLOW}Running test playbook...${NC}"
        ${CONTAINER_RUNTIME} run --rm -v $(pwd)/test-ee.yml:/tmp/test-ee.yml:Z \
            ${EE_NAME}:${EE_TAG} \
            ansible-playbook /tmp/test-ee.yml
        
        rm -f test-ee.yml
    fi
    
else
    echo -e "${RED}Build failed! Check the output above for errors.${NC}"
    exit 1
fi

echo
echo -e "${GREEN}Script completed!${NC}"