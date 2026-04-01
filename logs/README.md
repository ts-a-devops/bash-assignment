# DevOps Bash Toolkit

A collection of Bash automation scripts covering system monitoring, file management, backups, and process control.

# Project Structure

```
devops-bash-toolkit/
├── scripts/
│   ├── user_info.sh        # Collect & validate user details
│   ├── system_check.sh     # Disk / memory / CPU / process report
│   ├── file_manager.sh     # Create, delete, list, rename files
│   ├── backup.sh           # Compressed backup with auto-rotation
│   └── process_monitor.sh  # Monitor & restart processes (bonus)
├── run_all.sh              # Interactive menu runner (bonus)
├── logs/                   # Auto-created at runtime
├── backups/                # Auto-created by backup.sh
└── README.md


# Quick Start

-bash
# Clone and enter
git clone <your-fork-url>
cd devops-bash-toolkit

# Make all scripts executable
chmod +x scripts/*.sh run_all.sh

# Launch the interactive menu
./run_all.sh


---

# Scripts

# A. `user_info.sh`
Prompts for name, age, and country. Validates age is numeric and classifies the user as Minor / Adult / Senior.

-bash
./scripts/user_info.sh


Output saved to `logs/user_info.log`.



# B. `system_check.sh`
Displays disk usage, memory, CPU load, total running processes, and the top 5 memory-consuming processes. Warns if any filesystem exceeds 80% usage.

-bash
./scripts/system_check.sh


Report saved to `logs/system_report_<timestamp>.log`.



# C. `file_manager.sh`
Supports `create`, `delete`, `list`, and `rename` operations. Prevents overwriting existing files.

-bash
./scripts/file_manager.sh create notes.txt
./scripts/file_manager.sh rename notes.txt journal.txt
./scripts/file_manager.sh list .
./scripts/file_manager.sh delete journal.txt


Actions logged to `logs/file_manager.log`.



# D. `backup.sh`
Accepts a source directory, creates a `backup_<timestamp>.tar.gz` in `backups/`, and automatically removes older backups beyond the last 5.

-bash
./scripts/backup.sh ./scripts


Activity logged to `logs/backup.log`.



 E. `process_monitor.sh` *(Bonus)*
Checks whether one or more processes are running. If stopped, attempts a restart via `systemctl` → `service` → simulation fallback.

-bash
# Monitor specific process(es)
./scripts/process_monitor.sh nginx

# Monitor default services array: nginx, ssh, docker
./scripts/process_monitor.sh


Results logged to `logs/process_monitor.log`.



# F. `run_all.sh` *(Bonus)*
Interactive numbered menu to run any script without typing paths.

-bash
./run_all.sh


All actions logged to `logs/app.log`. Uses `set -euo pipefail` and handles script failures gracefully.


# Git Workflow

-bash
git checkout -b feature/<your-name>
git add .
git commit -m "feat: complete bash scripts"
git push origin feature/<your-name>
# Then open a Pull Request on GitHub


# Logs Reference

 File | Written by 

 `logs/user_info.log` | user_info.sh |
 `logs/system_report_*.log` | system_check.sh |
 `logs/file_manager.log` | file_manager.sh |
 `logs/backup.log` | backup.sh |
 `logs/process_monitor.log` | process_monitor.sh |
 `logs/app.log` | run_all.sh |
