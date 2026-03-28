# DevOps Bash Toolkit — Detailed Usage Guide

This guide explains every script in the toolkit, how to run each one, what
output to expect, where logs are stored, and how the optional scripts work.

---

## Table of Contents

1. [Project Structure](#project-structure)
2. [Getting Started](#getting-started)
3. [user_info.sh](#user_infosh)
4. [system_check.sh](#system_checksh)
5. [file_manager.sh](#file_managersh)
6. [backup.sh](#backupsh)
7. [process_monitor.sh (optional)](#process_monitorsh-optional)
8. [run_all.sh (optional bonus)](#run_allsh-optional-bonus)
9. [Logs Reference](#logs-reference)
10. [Backups Reference](#backups-reference)

---

## Project Structure

```
devops-bash-toolkit-assessment/
├── scripts/
│   ├── user_info.sh          # Collects and validates user info
│   ├── system_check.sh       # System health report
│   ├── file_manager.sh       # File CRUD operations
│   ├── backup.sh             # Directory backup with rotation
│   └── process_monitor.sh    # Process status checker (optional)
├── run_all.sh                # Interactive menu launcher (optional)
├── README.md                 # Assignment overview
├── README_EXPLAINED.md       # This file
├── logs/                     # All log files are written here
└── backups/                  # Compressed backups are stored here
```

---

## Getting Started

### 1. Make all scripts executable

```bash
chmod +x scripts/*.sh run_all.sh
```

### 2. Run any script directly

```bash
./scripts/user_info.sh
./scripts/system_check.sh
./scripts/file_manager.sh create notes.txt
./scripts/backup.sh /path/to/directory
./scripts/process_monitor.sh nginx
```

### 3. Or use the interactive menu

```bash
./run_all.sh
```

---

## user_info.sh

### Purpose

Interactively collects a user's name, age, and country. Validates that the age
is a whole number between 0 and 130, then categorises the user as Minor, Adult,
or Senior. All input and results are logged with timestamps.

### How to run

```bash
./scripts/user_info.sh
```

### Example session

```
╔══════════════════════════════════╗
║       User Information Form      ║
╚══════════════════════════════════╝

Enter your name: Alice
Enter your age: 17
Enter your country: Canada

──────────────────────────────────────
  Hello, Alice! Welcome from Canada.
  Age: 17  →  Category: Minor
──────────────────────────────────────
```

### Age categories

| Age range | Category |
|-----------|----------|
| 0 – 17    | Minor    |
| 18 – 65   | Adult    |
| 66 +      | Senior   |

### Invalid input handling

- Empty name or country: prompts again until a value is entered.
- Non-numeric age (e.g. `abc`, `12.5`): shows a warning and re-prompts.
- Age outside 0–130: treated as invalid.

### Log file

```
logs/user_info.log
```

Sample log entry:

```
[2025-06-01 10:23:45] [INFO] Name entered: Alice
[2025-06-01 10:23:47] [INFO] Age entered: 17
[2025-06-01 10:23:49] [INFO] Country entered: Canada
[2025-06-01 10:23:49] [INFO] Result — Name: Alice | Age: 17 | Country: Canada | Category: Minor
```

---

## system_check.sh

### Purpose

Generates a full system health report covering disk usage, memory, CPU load,
total process count, and the top 5 memory-consuming processes. Issues a warning
if any filesystem exceeds 80% usage.

### How to run

```bash
./scripts/system_check.sh
```

### Example output

```
  System Check Report — 2025-06-01 10:30:00

════════════════════════════════════════
  DISK USAGE
════════════════════════════════════════
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   43G  4.5G  91% /
  ⚠  WARNING: / is at 91% capacity!

════════════════════════════════════════
  MEMORY USAGE (MB)
════════════════════════════════════════
              total        used        free
Mem:          15987        8120        7867
Swap:          2047           0        2047

════════════════════════════════════════
  CPU LOAD (uptime)
════════════════════════════════════════
 10:30:00 up 3 days,  2:15,  2 users,  load average: 0.45, 0.38, 0.32

════════════════════════════════════════
  TOTAL RUNNING PROCESSES
════════════════════════════════════════
  Total processes: 214

════════════════════════════════════════
  TOP 5 MEMORY-CONSUMING PROCESSES
════════════════════════════════════════
PID        %CPU     %MEM     COMMAND
1234       2.1      5.3      firefox
5678       0.5      3.1      code
...
```

### Disk warning threshold

The threshold is set at the top of the script:

```bash
DISK_WARN_THRESHOLD=80
```

Change this value to adjust when warnings are triggered.

### Log file

A new log file is created for each day:

```
logs/system_report_YYYY-MM-DD.log
```

---

## file_manager.sh

### Purpose

Provides four file operations — create, delete, list, and rename — with
overwrite protection and full action logging.

### How to run

```bash
./scripts/file_manager.sh <command> [arguments]
```

### Commands

#### create

Creates a new empty file. Fails if the file already exists.

```bash
./scripts/file_manager.sh create notes.txt
# ✔  File 'notes.txt' created successfully.
```

#### delete

Removes a file. Fails if the file does not exist.

```bash
./scripts/file_manager.sh delete notes.txt
# ✔  File 'notes.txt' deleted successfully.
```

#### list

Lists the contents of a directory (defaults to current directory).

```bash
./scripts/file_manager.sh list
./scripts/file_manager.sh list /tmp
```

#### rename

Renames a file. Fails if the source does not exist or the destination already
exists.

```bash
./scripts/file_manager.sh rename old.txt new.txt
# ✔  Renamed 'old.txt' to 'new.txt' successfully.
```

### Error examples

```bash
./scripts/file_manager.sh create notes.txt   # file already exists
# ✗  'notes.txt' already exists. Use a different name or delete it first.

./scripts/file_manager.sh delete ghost.txt   # file not found
# ✗  'ghost.txt' not found.

./scripts/file_manager.sh                    # no command given
# Usage: ...
```

### Log file

```
logs/file_manager.log
```

Sample entries:

```
[2025-06-01 11:00:01] [INFO] === file_manager.sh called with command: 'create' ===
[2025-06-01 11:00:01] [INFO] Created file: 'notes.txt'
[2025-06-01 11:05:10] [ERROR] Create failed — 'notes.txt' already exists.
```

---

## backup.sh

### Purpose

Creates a timestamped `.tar.gz` archive of a specified directory and stores it
in `backups/`. Automatically deletes the oldest backups when more than 5 exist.

### How to run

```bash
./scripts/backup.sh <directory_to_backup>
```

### Example

```bash
./scripts/backup.sh /home/user/projects

#   ⏳  Backing up '/home/user/projects'...
#   ✔  Backup created: backup_projects_20250601_113045.tar.gz (12M)
```

### Archive naming

```
backup_<dirname>_<YYYYMMDD_HHMMSS>.tar.gz
```

### Backup rotation

Only the 5 most recent backups are kept. When a new backup is created and the
total exceeds 5, the oldest files are removed automatically:

```
  🗑   Removing 1 old backup(s)...
    ✗  Removed: backup_projects_20250520_090000.tar.gz
```

### Error handling

```bash
./scripts/backup.sh /nonexistent/path
# ✗  Directory '/nonexistent/path' not found.
```

### Log file

```
logs/backup.log
```

Sample entries:

```
[2025-06-01 11:30:45] [INFO] Starting backup of '/home/user/projects' → '.../backups/backup_projects_20250601_113045.tar.gz'
[2025-06-01 11:30:47] [INFO] Backup created: 'backup_projects_20250601_113045.tar.gz' (size: 12M)
[2025-06-01 11:30:47] [INFO] Backup count (3) within limit (5). No pruning needed.
```

---

## process_monitor.sh (optional)

### Purpose

Checks whether a named process is running. If it is stopped, the script
attempts a restart via `systemctl`. In environments without systemd or root
access, a simulated restart message is shown. Can monitor a single process or
iterate over a default list.

### How to run

```bash
# Monitor a single process
./scripts/process_monitor.sh nginx

# Monitor all default services (nginx, ssh, docker)
./scripts/process_monitor.sh
```

### Default services array

Defined at the top of the script:

```bash
services=("nginx" "ssh" "docker")
```

Add or remove entries to customise which services are monitored by default.

### Example output

```
╔══════════════════════════════════╗
║       Process Monitor            ║
╚══════════════════════════════════╝

  Checking: nginx
  ─────────────────────────────────
  ✔  Status: RUNNING  (PID: 1042)

  Checking: docker
  ─────────────────────────────────
  ✗  Status: STOPPED
  ⚠  Simulated restart for 'docker' (no systemctl access or service not found).
  ✗  Status after restart: STILL STOPPED
```

### Log file

```
logs/process_monitor.log
```

Sample entries:

```
[2025-06-01 12:00:00] [INFO] 'nginx' is RUNNING (PID: 1042)
[2025-06-01 12:00:01] [WARN] 'docker' is STOPPED. Attempting restart...
[2025-06-01 12:00:01] [WARN] Could not restart 'docker' via systemctl. Simulating restart.
[2025-06-01 12:00:01] [ERROR] 'docker' could not be restarted.
```

---

## run_all.sh (optional bonus)

### Purpose

Provides an interactive terminal menu to run any combination of toolkit scripts
without remembering individual commands. Handles script failures gracefully and
logs every action.

### How to run

```bash
./run_all.sh
```

### Menu

```
╔══════════════════════════════════════╗
║      DevOps Bash Toolkit Menu        ║
╠══════════════════════════════════════╣
║  1. Run All Scripts                  ║
║  2. System Check                     ║
║  3. Backup a Directory               ║
║  4. Exit                             ║
╚══════════════════════════════════════╝

  Select an option [1-4]:
```

### Option details

| Option | Action |
|--------|--------|
| 1      | Runs user_info.sh, system_check.sh, prompts for backup target, then process_monitor.sh |
| 2      | Runs system_check.sh only |
| 3      | Prompts for a directory and runs backup.sh |
| 4      | Exits the menu |

### Failure handling

If a script exits with a non-zero code, `run_all.sh` logs the error and
continues rather than crashing the entire session.

### Log file

```
logs/app.log
```

Sample entries:

```
[2025-06-01 13:00:00] [INFO] === run_all.sh started ===
[2025-06-01 13:00:05] [INFO] User selected: System Check
[2025-06-01 13:00:05] [INFO] Running: system_check.sh
[2025-06-01 13:00:07] [INFO] system_check.sh completed successfully.
[2025-06-01 13:01:00] [INFO] User selected: Exit
[2025-06-01 13:01:00] [INFO] === run_all.sh exited ===
```

---

## Logs Reference

| Log file                          | Written by           |
|-----------------------------------|----------------------|
| `logs/user_info.log`              | user_info.sh         |
| `logs/system_report_YYYY-MM-DD.log` | system_check.sh    |
| `logs/file_manager.log`           | file_manager.sh      |
| `logs/backup.log`                 | backup.sh            |
| `logs/process_monitor.log`        | process_monitor.sh   |
| `logs/app.log`                    | run_all.sh           |

All log entries follow this format:

```
[YYYY-MM-DD HH:MM:SS] [LEVEL] Message
```

Levels used: `INFO`, `WARN`, `ERROR`.

---

## Backups Reference

All backups are stored in:

```
backups/
```

Archive naming convention:

```
backup_<source_directory_name>_<YYYYMMDD_HHMMSS>.tar.gz
```

Only the 5 most recent backups are retained. Older ones are deleted
automatically each time `backup.sh` runs.

To restore a backup manually:

```bash
tar -xzf backups/backup_mydir_20250601_113045.tar.gz -C /restore/path/
```
