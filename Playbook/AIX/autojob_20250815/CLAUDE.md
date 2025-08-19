# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an AIX system administration automation toolkit consisting of Korn Shell (ksh) and Bourne Shell (sh) scripts. The project implements automated monitoring and self-healing capabilities for IBM AIX Unix systems.

## Commands and Development Workflow

### Running Scripts

Scripts are designed to run as root/admin and typically executed via cron jobs:

```bash
# Disk space monitoring and auto-expansion
./1.increase_fs-disk_services/checkspace.ksh.sith

# CPU load monitoring (runs continuously)
./2.add-cpu_services/chk_load_soul.sh

# Memory/paging space monitoring and auto-addition
./3.add-memory_services/local_auto-check_lsps.ksh

# Print queue monitoring and auto-restart
./4.print-queue_services/auto_enable_queue_rev1.0.ksh

# Zabbix agent monitoring and restart
./5.zabbix_services/script_auto_check-zabbix_agent_restart.sh
```

### Testing Scripts

Before deploying to production:
1. Verify configuration files exist and are readable
2. Check log directory permissions: `/bigc/log/`
3. Test email notifications are configured
4. Verify SSH keys for HMC access (for CPU/memory scripts)
5. Run scripts with temporary log redirects to verify behavior

### Key Configuration Files

- **Disk thresholds**: `/bigc/script/checkspace.cfg` (format: `filesystem,threshold_percentage`)
- **CPU monitoring**: `/usr/enterprise/souls/conf/poll.conf` and `load_soul.conf`
- **Email recipients**: Hardcoded in scripts (command_center_alert@bigc.co.th)

## Architecture and Design Patterns

### Service Structure

Each numbered directory represents an independent monitoring service:
- **1.increase_fs-disk_services**: Monitors filesystem usage, auto-increases by 2% when threshold exceeded
- **2.add-cpu_services**: Monitors CPU load, auto-adds virtual CPUs via HMC
- **3.add-memory_services**: Monitors paging space, auto-adds 512MB memory via HMC
- **4.print-queue_services**: Monitors print spooler, auto-restarts queues when DOWN
- **5.zabbix_services**: Monitors Zabbix agent, auto-restarts when high workload detected

### Common Script Pattern

All scripts follow this workflow:
1. Check system state/metrics
2. Compare against thresholds
3. Take automated remediation action if needed
4. Log all actions to `/bigc/log/`
5. Send email notifications on actions taken

### AIX-Specific Commands Used

- `lsps`: List paging space information
- `chfs`: Change filesystem size
- `lparstat`: LPAR (logical partition) statistics
- `lssrc`/`startsrc`: Service management
- HMC commands via SSH: `chhwres` (change hardware resources)

### Integration Points

- **IBM HMC**: Hardware Management Console for PowerVM resource allocation
- **Zabbix**: Monitoring agent integration
- **Souls Framework**: Custom monitoring framework (reads from `/usr/enterprise/souls/conf/`)
- **Email Alerts**: Sends to EIS Command Center team

## Important Considerations

- Scripts require root/admin privileges
- Designed for AIX operating system only
- Assumes `/bigc/` directory structure exists
- SSH keys must be configured for passwordless HMC access
- Scripts implement automatic system changes - use with caution in development
- No built-in rollback mechanisms - changes are permanent