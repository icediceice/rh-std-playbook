# Changelog

All notable changes to the AIX Management playbooks will be documented in this file.

## [1.0.0] - 2025-08-19

### Added
- Initial release of AIX Management playbooks for AAP 2.5
- Complete migration from original shell scripts to Ansible playbooks
- Five core management roles:
  - Filesystem management with auto-expansion
  - CPU management with HMC integration
  - Memory management with HMC integration  
  - Print queue management with auto-restart
  - Service monitoring with auto-restart
- AAP 2.5 integration features:
  - Credential injection support
  - Interactive surveys for all playbooks
  - Custom execution environment definition
  - Change tracking and audit capabilities
- Email notification system with SMTP credential injection
- Comprehensive logging and error handling
- Standardized directory structure following AAP best practices
- Complete documentation and setup guides

### Changed
- Modernized original AIX shell scripts into idempotent Ansible tasks
- Replaced hardcoded credentials with AAP credential injection
- Enhanced error handling and logging capabilities
- Improved email notifications with structured templates
- Added comprehensive survey definitions for user interaction

### Security
- Implemented AAP credential injection for all sensitive data
- Removed hardcoded passwords and connection strings
- Added vault integration for secure secret management
- Enhanced SSH key-based authentication support

### Documentation
- Added comprehensive README with setup instructions
- Created role-specific documentation
- Included troubleshooting guide
- Added migration guide from original scripts