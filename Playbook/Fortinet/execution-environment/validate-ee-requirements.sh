#!/bin/bash
# Validate EE requirements before building

echo "=== Validating Execution Environment Requirements ==="
echo

# Check Python dependencies
echo "Checking Python dependencies..."
if [ -f requirements.txt ]; then
    while IFS= read -r line; do
        if [[ ! "$line" =~ ^# && -n "$line" ]]; then
            echo "  ✓ $line"
        fi
    done < requirements.txt
else
    echo "  ✗ requirements.txt not found!"
fi
echo

# Check Ansible collections
echo "Checking Ansible collections..."
if [ -f requirements.yml ]; then
    echo "Collections required:"
    grep -E "^\s*- name:" requirements.yml | sed 's/.*name: /  ✓ /'
else
    echo "  ✗ requirements.yml not found!"
fi
echo

# Check system dependencies
echo "Checking system dependencies..."
if [ -f bindep.txt ]; then
    echo "System packages required:"
    grep -v "^#" bindep.txt | grep -v "^$" | head -10 | sed 's/^/  ✓ /'
else
    echo "  ✗ bindep.txt not found!"
fi
echo

# Check for ansible-builder
echo "Checking build tools..."
if command -v ansible-builder &> /dev/null; then
    echo "  ✓ ansible-builder $(ansible-builder --version | head -1)"
else
    echo "  ✗ ansible-builder not installed"
    echo "    Install with: pip install ansible-builder"
fi

# Check container runtime
if command -v podman &> /dev/null; then
    echo "  ✓ podman $(podman --version)"
elif command -v docker &> /dev/null; then
    echo "  ✓ docker $(docker --version)"
else
    echo "  ✗ No container runtime found (need podman or docker)"
fi
echo

echo "=== Validation Complete ==="