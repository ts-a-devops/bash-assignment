        A
User Info Script
Prompts for:
Name
Age
Country
Validates:
Age must be numeric
Categorizes age:
Minor (<18)
Adult (18–65)
Senior (65+)
Saves output to logs/user_info.log
========================================

        B
System Monitoring
Displays:
Disk usage (df -h)
Memory usage (free -m)
CPU load (uptime)
Warns if disk usage exceeds 80%
Counts total running processes
Shows top 5 memory-consuming processes
Saves report to logs/system_report_<timestamp>.log
==================================================

            C
File Manager

Supports the following commands:

./file_manager.sh create file.txt
./file_manager.sh delete file.txt
./file_manager.sh list
./file_manager.sh rename old.txt new.txt

Features:

Prevents overwriting existing files
Handles invalid input gracefully
Logs all actions to logs/file_manager.log
==========================================

        D
Backup Automation
Accepts a directory as input
Validates directory existence
Creates compressed backups:
backup_<timestamp>.tar.gz
Stores backups in backups/
Keeps only the latest 5 backups
Logs all backup activities
===============================

        E
Process Monitoring
Accepts a process name as input
Checks if process is running
If not running:
Attempts restart (simulated)
Outputs:
Running
Stopped
Restarted
Uses predefined services array:
services=("nginx" "ssh" "docker")
Logs monitoring results
============================

        F
Interactive CLI Menu (run_all.sh)

Menu Options:

1) Run all
2) System check
3) Backup
4) Exit

Features:

Uses functions for modular design
Calls scripts from scripts/ directory
Includes safe Bash settings:
set -euo pipefail
Handles errors using trap
Logs all actions to logs/app.log