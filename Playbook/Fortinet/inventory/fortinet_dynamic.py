#!/usr/bin/env python3
"""
AAP 2.5 Compatible Fortinet Inventory Script
This script provides dynamic inventory from external sources with AAP credential integration
"""

import json
import sys
import os
import argparse
from typing import Dict, Any, List

class FortinetInventory:
    """Dynamic inventory class for Fortinet devices with AAP integration"""
    
    def __init__(self):
        self.inventory = {
            '_meta': {
                'hostvars': {}
            },
            'all': {
                'children': ['fortinet']
            },
            'fortinet': {
                'hosts': [],
                'vars': {
                    'ansible_connection': 'httpapi',
                    'ansible_network_os': 'fortios',
                    'ansible_httpapi_use_ssl': True,
                    'ansible_httpapi_validate_certs': False,
                    'ansible_httpapi_port': 443,
                    'ansible_httpapi_timeout': 30,
                    # AAP credential integration
                    'ansible_user': '{{ fortinet_username | default("admin") }}',
                    'ansible_password': '{{ fortinet_password }}',
                    'vdom': 'root'
                }
            }
        }
        
        # Initialize group categories
        self.inventory.update({
            'production': {'hosts': []},
            'staging': {'hosts': []},
            'development': {'hosts': []},
            'firewalls': {'hosts': []},
            'routers': {'hosts': []},
            'datacenter_primary': {'hosts': []},
            'datacenter_secondary': {'hosts': []},
            'cloud_aws': {'hosts': []},
            'cloud_azure': {'hosts': []}
        })
        
        self.load_inventory()
    
    def load_inventory(self):
        """Load inventory from environment variables or external source"""
        
        # Example devices - in real implementation, this would come from:
        # - CMDB API calls
        # - CSV files
        # - External databases
        # - Environment variables from AAP
        
        devices = self._get_devices_from_source()
        
        for device in devices:
            hostname = device['hostname']
            self.inventory['fortinet']['hosts'].append(hostname)
            
            # Set host variables
            self.inventory['_meta']['hostvars'][hostname] = {
                'ansible_host': device.get('ip_address', ''),
                'device_type': device.get('type', 'firewall'),
                'environment': device.get('environment', 'production'),
                'location': device.get('location', 'dc1'),
                'vdom': device.get('vdom', 'root'),
                'device_model': device.get('model', 'FortiGate'),
                'firmware_version': device.get('firmware', 'unknown')
            }
            
            # Add to appropriate groups
            env = device.get('environment', 'production')
            if env in self.inventory:
                self.inventory[env]['hosts'].append(hostname)
            
            device_type = device.get('type', 'firewall')
            if device_type == 'firewall':
                self.inventory['firewalls']['hosts'].append(hostname)
            elif device_type == 'router':
                self.inventory['routers']['hosts'].append(hostname)
            
            location = device.get('location', 'dc1')
            if location == 'dc1':
                self.inventory['datacenter_primary']['hosts'].append(hostname)
            elif location == 'dc2':
                self.inventory['datacenter_secondary']['hosts'].append(hostname)
            elif location == 'aws':
                self.inventory['cloud_aws']['hosts'].append(hostname)
            elif location == 'azure':
                self.inventory['cloud_azure']['hosts'].append(hostname)
    
    def _get_devices_from_source(self) -> List[Dict[str, Any]]:
        """Get devices from external source or environment variables"""
        
        # Check for AAP custom credential injection
        aap_inventory = os.environ.get('AAP_FORTINET_INVENTORY')
        if aap_inventory:
            try:
                return json.loads(aap_inventory)
            except json.JSONDecodeError:
                pass
        
        # Default devices for demonstration
        return [
            {
                'hostname': 'fw-prod-01',
                'ip_address': os.environ.get('FORTINET_PROD_FW01_IP', '192.168.1.10'),
                'type': 'firewall',
                'environment': 'production',
                'location': 'dc1',
                'vdom': 'root',
                'model': 'FortiGate-100F',
                'firmware': '7.0.0'
            },
            {
                'hostname': 'fw-prod-02',
                'ip_address': os.environ.get('FORTINET_PROD_FW02_IP', '192.168.1.11'),
                'type': 'firewall',
                'environment': 'production',
                'location': 'dc2',
                'vdom': 'root',
                'model': 'FortiGate-100F',
                'firmware': '7.0.0'
            },
            {
                'hostname': 'fw-staging-01',
                'ip_address': os.environ.get('FORTINET_STAGING_FW01_IP', '192.168.2.10'),
                'type': 'firewall',
                'environment': 'staging',
                'location': 'dc1',
                'vdom': 'root',
                'model': 'FortiGate-60F',
                'firmware': '6.4.8'
            }
        ]
    
    def get_inventory(self) -> Dict[str, Any]:
        """Return the complete inventory"""
        return self.inventory
    
    def get_host(self, hostname: str) -> Dict[str, Any]:
        """Return variables for a specific host"""
        return self.inventory['_meta']['hostvars'].get(hostname, {})

def main():
    """Main execution function"""
    parser = argparse.ArgumentParser(description='Fortinet Dynamic Inventory for AAP 2.5')
    parser.add_argument('--list', action='store_true', help='List all groups and hosts')
    parser.add_argument('--host', help='Get variables for a specific host')
    
    args = parser.parse_args()
    
    inventory = FortinetInventory()
    
    if args.list:
        print(json.dumps(inventory.get_inventory(), indent=2))
    elif args.host:
        print(json.dumps(inventory.get_host(args.host), indent=2))
    else:
        print(json.dumps(inventory.get_inventory(), indent=2))

if __name__ == '__main__':
    main()
