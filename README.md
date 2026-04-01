## DevOps Bash Toolkit Assessment

This project provides a small Bash toolkit that covers user input handling, system checks, file management, backups, and optional process monitoring.

## Project Structure

```text
devops-bash-toolkit-assestment/
├── backups/
├── logs/
├── run_all.sh
├── README.md
└── scripts/
    ├── backup.sh
    ├── file_manager.sh
    ├── process_monitor.sh
    ├── system_check.sh
    └── user_info.sh
```

## Setup

Make the scripts executable:

```bash
chmod +x scripts/*.sh run_all.sh
```

## Usage

### user_info.sh

```bash
./scripts/user_info.sh
```

Prompts for name, age, and country, validates the age, classifies the user, and logs the output to `logs/user_info.log`.

### system_check.sh

```bash
./scripts/system_check.sh
```

Generates a system report with disk usage, memory, CPU load, process count, top memory consumers, and disk warnings. Reports are saved in `logs/`.

### file_manager.sh

```bash
./scripts/file_manager.sh create notes.txt
./scripts/file_manager.sh list .
./scripts/file_manager.sh rename notes.txt notes-old.txt
./scripts/file_manager.sh delete notes-old.txt
```

All actions are logged to `logs/file_manager.log`.

### backup.sh

```bash
./scripts/backup.sh /path/to/directory
```

Creates a compressed backup in `backups/`, logs the action, and keeps only the 5 newest archives.

### process_monitor.sh

```bash
./scripts/process_monitor.sh nginx
```

Checks whether a process is running and attempts a restart for known services when possible.

### run_all.sh

```bash
./run_all.sh
```

Displays an interactive menu for running the system check and backup
workflow. Activity is logged to `logs/app.log`.

## Git Workflow

```bash
git checkout -b feature/your-name
git add .
git commit -m "feat: complete bash scripts"
git push origin feature/your-name
```
# devops-bash-toolkit-assessment
