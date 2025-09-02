#!/bin/bash
# Helper script to build Fortinet EE from project root

echo "Building Fortinet Execution Environment..."
echo "========================================="
echo ""

# Change to execution-environment directory
cd execution-environment || {
    echo "ERROR: execution-environment directory not found!"
    echo "Please run this script from the Fortinet directory."
    exit 1
}

# Run the build
if [ -f "build.sh" ]; then
    ./build.sh
elif [ -f "rebuild-fortinet-ee.sh" ]; then
    ./rebuild-fortinet-ee.sh
else
    echo "ERROR: No build script found in execution-environment directory!"
    exit 1
fi