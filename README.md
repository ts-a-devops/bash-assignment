
# 🚀 DevOps Bash Toolkit Assessment

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/your-username/devops-bash-toolkit/grade.yml)
![GitHub repo size](https://img.shields.io/github/repo-size/your-username/devops-bash-toolkit)
![GitHub last commit](https://img.shields.io/github/last-commit/your-username/devops-bash-toolkit)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## 📌 Overview

This assignment tests your **DevOps fundamentals**:

- Bash scripting  
- Git workflow (branching, commits, pull requests)  
- Automation mindset  
- System monitoring and logging  

You will build a **real-world automation toolkit** and submit it via a **Pull Request (PR)**.

---

## 📁 Project Structure

```text
devops-bash-toolkit-assestment/
│
├── scripts/
│   ├── user_info.sh
│   ├── system_check.sh
│   ├── file_manager.sh
│   ├── backup.sh
│   ├── process_monitor.sh
│
├── run_all.sh              # OPTIONAL (Bonus)
│
├── README.md
```

🧑‍💻 Getting Started
1. Fork the Repository

Click the Fork button on GitHub.

2. Clone Your Fork
```bash
git clone <your-fork-url>
cd devops-bash-toolkit
```

3. Create a Feature Branch
```bash
git checkout -b feature/<your-name>
```

4. Complete the Scripts
Implement all required scripts inside:
```bash
scripts/
```

5. Make Scripts Executable
```bash
chmod +x scripts/*.sh
```

6. Commit Your Work
```bash
git add .
git commit -m "feat: complete bash scripts"
```

7. Push to GitHub
```bash
git push origin feature/<your-name>
```

8. Create Pull Request

Open a Pull Request to the main repository.


🧠 Assignment Tasks
--------------------------------------------------------------------------------
🔹 A. user_info.sh
Requirements

* Prompt the user for:

  * Name

  * Age

  * Country

* Validate:

  * Age must be numeric

* Output:

  * A greeting message

* Age category:

  * Minor (<18)

  * Adult (18–65)

  * Senior (65+)

* Handle missing or invalid input gracefully

* Save output to:
```bash
logs/user_info.log
```
---
🔹 B. system_check.sh
Requirements

* Display:

  * Disk usage (df -h)

  * Memory usage (free -m)

  * CPU load (uptime)

* Warn if disk usage exceeds 80%

* Save report to:
```bash
logs/system_report_<date>.log
```
* Count total running processes

* Display top 5 memory-consuming processes
---
🔹 C. file_manager.sh
Requirements

* Support the following commands:

  * create

  * delete

  * list

  * rename

* Example usage:
```bash
./file_manager.sh create file.txt
```
* Prevent overwriting existing files

* Log all actions to:
```bash
logs/file_manager.log
```
---
🔹 D. backup.sh
Requirements

* Accept a directory as input

* Validate that the directory exists

* Create a compressed backup:
```bash
backup_<timestamp>.tar.gz
```
* Store backups in:
```bash
backups/
```
* Keep only the last 5 backups (delete older ones)

* Log backup activity
---
⭐ E. process_monitor.sh(Optional Bonus)
Requirements

* Accept a process name as input

* Check if the process is running

* If NOT running:

  * Attempt restart (or simulate restart)

* Output:

  * Running

  * Stopped

  * Restarted

* Use an array:
```bash
services=("nginx" "ssh" "docker")
```
* Log monitoring results
---
⭐ F. run_all.sh (Optional Bonus)
Requirements

Provide an interactive menu:
1. Run all
2. System check
3. Backup
4. Exit
* Use functions to organize logic

* Call scripts from the scripts/ directory

* Include:
  ```bash
  set -euo pipefail
  ```
* Log all actions to:
```bash
logs/app.log
```
* Handle script failures gracefully
  
**Submission link:** [CLICK HERE](https://forms.gle/jrhpKjXsQXZxLopN6)
# DevOps Bash Toolkit Assessment

## Overview
This project contains Bash scripts that demonstrate DevOps fundamentals including:
- Bash scripting
- System monitoring
- Logging
- File management
- Backup automation
- Git workflow

## Scripts

### 1. user_info.sh
Prompts the user for name, age, and country.
Validates age input and classifies user as Minor, Adult, or Senior.
Logs output to `logs/user_info.log`.

### 2. system_check.sh
Displays:
- Disk usage
- Memory usage
- CPU load
- Disk usage warnings above 80%
- Total running processes
- Top 5 memory-consuming processes

Logs output to `logs/system_report_<date>.log`.

### 3. file_manager.sh
Supports:
- create
- delete
- list
- rename

Logs actions to `logs/file_manager.log`.

### 4. backup.sh
Creates compressed backups of a given directory in `backups/`.
Keeps only the latest 5 backups.
Logs actions to `logs/backup.log`.

### 5. process_monitor.sh
Optional bonus script.
Checks if a monitored process is running and simulates restart if not.
Logs actions to `logs/process_monitor.log`.

### 6. run_all.sh
Optional bonus script with interactive menu.
Uses `set -euo pipefail` and logs actions to `logs/app.log`.

## How to Run

```bash
./scripts/user_info.sh
./scripts/system_check.sh
./scripts/file_manager.sh create test.txt
./scripts/file_manager.sh list
./scripts/file_manager.sh rename test.txt new.txt
./scripts/file_manager.sh delete new.txt
./scripts/backup.sh scripts
./scripts/process_monitor.sh nginx
./run_all.sh

