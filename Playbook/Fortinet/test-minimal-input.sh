#!/bin/bash
# Test script to verify the playbook works with minimal input

echo "Testing minimal input - only target_hosts provided:"
echo "ansible-playbook playbooks/enable_packet_capture.yml -e \"target_hosts=fw-target-01\" --check"
echo ""
echo "Testing with common parameters:"
echo "ansible-playbook playbooks/enable_packet_capture.yml -e \"target_hosts=fw-target-01\" -e \"interface_name=wan1\" -e \"capture_count=25\" --check"
echo ""
echo "All other parameters will use sensible defaults:"
echo "- interface_name: any"
echo "- capture_filter: 'host any'"  
echo "- capture_count: 50"
echo "- capture_timeout: 30 seconds"
echo "- vdom: root"
echo "- send_email: '' (disabled)"
echo "- email_subject: 'Fortinet Packet Capture Report - <hostname>'"