# DevOps Bash Toolkit Assessment

##  Overview

This project contains a collection of Bash scripts designed to perform basic DevOps tasks such as system monitoring, file management, backups, and process monitoring.

All scripts are located in the `scripts/` directory and include logging for tracking activities.

---

##  Project Structure

```
devops-bash-toolkit-assessment/
│
├── scripts/
│   ├── user_info.sh
│   ├── system_check.sh
│   ├── file_manager.sh
│   ├── backup.sh
│   ├── process_monitor.sh
│
├── logs/
├── backups/
├── README.md
```

---

## ⚙️Setup Instructions

1. Clone the repository:

```bash
git clone https://github.com/Henestoe/bash-assignment.git
cd bash-assignment
```

2. Make scripts executable:

```bash
chmod +x scripts/*.sh
```

---

##  Scripts and Usage

### 1. user_info.sh

Prompts user for personal information and categorizes age.

```bash
./scripts/user_info.sh
```

Features:

* Input validation
* Age categorization (Minor, Adult, Senior)
* Logs output to `logs/user_info.log`

---

### 2. system_check.sh

Displays system resource usage and generates a report.

```bash
./scripts/system_check.sh
```

Features:

* Disk, memory, and CPU usage
* Disk warning if usage exceeds 80%
* Process count and top memory processes
* Logs saved as `logs/system_report_<date>.log`

---

### 3. file_manager.sh

Performs basic file operations.

```bash
./scripts/file_manager.sh <command> [arguments]
```

Commands:

* `create filename`
* `delete filenam>`
* `list`
* `rename oldname newname`

Features:

* Prevents overwriting files
* Logs actions to `logs/file_manager.log`

---

### 4. backup.sh

Creates compressed backups of directories.

```bash
./scripts/backup.sh <directory>
```

Features:

* Validates directory existence
* Creates `.tar.gz` backups in `backups/`
* Keeps only the latest 5 backups
* Logs activity to `logs/backup.log`

---

### 5. process_monitor.sh (Optional)

Monitors and simulates restarting services.

```bash
./scripts/process_monitor.sh <process_name>
```

Features:

* Checks if process is running
* Simulates restart if stopped
* Uses predefined services list
* Logs results to `logs/process_monitor.log`

---

## 📝 Logging

All scripts generate logs stored in the `logs/` directory for tracking operations and debugging.

---

## 🧠 Concepts Demonstrated

* Bash scripting fundamentals
* File and directory management
* Process monitoring
* System resource inspection
* Logging and error handling
* Automation basics

---

## Notes

* Ensure scripts are run from the project root directory
* Some commands may vary depending on your operating system
* No root privileges are required for execution

---

# Author

Adeniyi Adegbola (Henestoe)
