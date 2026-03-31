# 🚀 DevOps Bash Toolkit Assessment

This project is a collection of Bash scripts designed to demonstrate core DevOps fundamentals including automation, system monitoring, logging, and efficient command-line operations.

It was built as part of a DevOps assessment to showcase practical skills in:
- Bash scripting
- Git workflow (branching, commits, pull requests)
- System monitoring and logging
- Automation mindset

---

## 📁 Project Structure


.
├── scripts/
│ ├── user_info.sh
│ ├── system_check.sh
│ ├── file_manager.sh
│ ├── backup.sh
│ ├── process_monitor.sh
│
├── logs/
├── backups/
├── run_all.sh
├── .gitignore
└── README.md


---

## ⚙️ Setup Instructions

Clone the repository:

```bash
git clone <your-fork-url>
cd devops-bash-toolkit

Make scripts executable:

chmod +x scripts/*.sh
chmod +x run_all.sh
🧠 Scripts Overview
🔹 user_info.sh

Prompts user for name, age, and country

Validates input (age must be numeric)

Categorizes age:

Minor (<18)

Adult (18–65)

Senior (65+)

Logs output to logs/user_info.log

🔹 system_check.sh

Displays:

Disk usage (df -h)

Memory usage (free -m)

CPU load (uptime)

Warns if disk usage exceeds 80%

Counts total running processes

Shows top 5 memory-consuming processes

Logs output to logs/system_report_<date>.log

🔹 file_manager.sh

Supports the following commands:

./scripts/file_manager.sh create file.txt
./scripts/file_manager.sh delete file.txt
./scripts/file_manager.sh list
./scripts/file_manager.sh rename old.txt new.txt

Features:

Prevents overwriting existing files

Handles missing files gracefully

Logs all actions to logs/file_manager.log

🔹 backup.sh

Accepts a directory as input

Validates directory existence

Creates compressed backups:

backup_<timestamp>.tar.gz

Stores backups in backups/

Retains only the last 5 backups

Logs activity to logs/backup.log

⭐ process_monitor.sh (Bonus)

Monitors services:

nginx, ssh, docker

Accepts optional process name input

Checks if process is running

Attempts restart if stopped (or simulates)

Logs results to logs/process_monitor.log

⭐ run_all.sh (Bonus)

Interactive menu:

Run all scripts

System check

Backup

Exit

Uses functions and structured logic

Implements strict error handling:

set -euo pipefail

Logs all actions to logs/app.log

📊 Logging

All scripts log their output and activities to the logs/ directory for traceability and debugging.

🧪 Example Usage
./scripts/user_info.sh
./scripts/system_check.sh
./scripts/file_manager.sh list
./scripts/backup.sh scripts
./run_all.sh
🛠️ Technologies Used

Bash (Shell Scripting)

Linux Utilities (df, free, ps, tar, awk)

Git & GitHub

🚀 Key Highlights

Input validation and error handling

Modular script design

Logging and monitoring implementation

Automated backup with retention policy

Interactive CLI tool

👨 Author

Adedeji Olajoto
DevOps Engineer

📌 Notes

Ensure you run scripts from the project root directory

Some operations (e.g., restarting services) may require sudo
