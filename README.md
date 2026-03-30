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

## 🧠 Assignment Tasks

🔹 A. user_info.sh
Requirements

- Prompt the user for:
  - Name

  - Age

  - Country

- Validate:
  - Age must be numeric

- Output:
  - A greeting message

- Age category:
  - Minor (<18)

  - Adult (18–65)

  - Senior (65+)

- Handle missing or invalid input gracefully

- Save output to:

```bash
logs/user_info.log
```

---

🔹 B. system_check.sh
Requirements

- Display:
  - Disk usage (df -h)

  - Memory usage (free -m)

  - CPU load (uptime)

- Warn if disk usage exceeds 80%

- Save report to:

```bash
logs/system_report_<date>.log
```

- Count total running processes

- Display top 5 memory-consuming processes

---

🔹 C. file_manager.sh
Requirements

- Support the following commands:
  - create

  - delete

  - list

  - rename

- Example usage:

```bash
./file_manager.sh create file.txt
```

- Prevent overwriting existing files

- Log all actions to:

```bash
logs/file_manager.log
```

---

🔹 D. backup.sh
Requirements

- Accept a directory as input

- Validate that the directory exists

- Create a compressed backup:

```bash
backup_<timestamp>.tar.gz
```

- Store backups in:

```bash
backups/
```

- Keep only the last 5 backups (delete older ones)

- Log backup activity

---

⭐ E. process_monitor.sh(Optional Bonus)
Requirements

- Accept a process name as input

- Check if the process is running

- If NOT running:
  - Attempt restart (or simulate restart)

- Output:
  - Running

  - Stopped

  - Restarted

- Use an array:

```bash
services=("nginx" "ssh" "docker")
```

- Log monitoring results

---

⭐ F. run_all.sh (Optional Bonus)
Requirements

Provide an interactive menu:

1. Run all
2. System check
3. Backup
4. Exit

- Use functions to organize logic

- Call scripts from the scripts/ directory

- Include:
  ```bash
  set -euo pipefail
  ```
- Log all actions to:

```bash
logs/app.log
```

- Handle script failures gracefully

**Submission link:** [CLICK HERE](https://forms.gle/jrhpKjXsQXZxLopN6)

---

## ✅ Implementation Notes (This Repo)

All required scripts are implemented:

- `scripts/user_info.sh`
- `scripts/system_check.sh`
- `scripts/file_manager.sh`
- `scripts/backup.sh`
- `scripts/process_monitor.sh` (bonus)
- `run_all.sh` (bonus)

---

## 🔧 Correct Git Setup (If You Cloned The Source Directly)

If you cloned from the upstream assignment repo instead of your fork, update `origin` to your own GitHub repo URL:

```bash
git remote -v
git remote set-url origin <your-fork-url>
git remote -v
```

Optional: keep the source assignment repo as `upstream` for pulling updates:

```bash
git remote add upstream https://github.com/ts-a-devops/bash-assignment.git
git remote -v
```

Create your feature branch using your name:

```bash
git checkout -b feature/awe-joseph-olaitan
```

Commit message to use:

```bash
git add scripts run_all.sh README.md
git commit -m "feat: complete bash toolkit scripts"
git push -u origin feature/awe-joseph-olaitan
```

---

## ▶️ How To Run (By Platform)

### macOS / Linux

```bash
chmod +x scripts/*.sh run_all.sh
./scripts/user_info.sh
./scripts/system_check.sh
./scripts/file_manager.sh create file.txt
./scripts/backup.sh .
./scripts/process_monitor.sh nginx
./run_all.sh
```

### Windows (PowerShell + Git Bash/WSL installed)

`chmod` is not a PowerShell command. Run scripts through Bash:

```powershell
bash ./scripts/user_info.sh
bash ./scripts/system_check.sh
bash ./scripts/file_manager.sh create file.txt
bash ./scripts/backup.sh .
bash ./scripts/process_monitor.sh nginx
bash ./run_all.sh
```

If `bash` is not available, install one of:

- Git for Windows (Git Bash)
- WSL with Ubuntu

If you get this error in PowerShell:

`execvpe(/bin/bash) failed: No such file or directory`

your `bash` command is pointing to WSL launcher (`C:\Windows\System32\bash.exe`) without a Linux distro. Use Git Bash directly or call Git Bash executable explicitly:

```powershell
& "C:\Program Files\Git\bin\bash.exe" -lc "cd '/c/Users/ADMIN/Projects/bash-assignment' && ./scripts/user_info.sh"
& "C:\Program Files\Git\bin\bash.exe" -lc "cd '/c/Users/ADMIN/Projects/bash-assignment' && ./scripts/system_check.sh"
& "C:\Program Files\Git\bin\bash.exe" -lc "cd '/c/Users/ADMIN/Projects/bash-assignment' && ./scripts/file_manager.sh create file.txt"
& "C:\Program Files\Git\bin\bash.exe" -lc "cd '/c/Users/ADMIN/Projects/bash-assignment' && ./scripts/backup.sh ."
& "C:\Program Files\Git\bin\bash.exe" -lc "cd '/c/Users/ADMIN/Projects/bash-assignment' && ./scripts/process_monitor.sh nginx"
& "C:\Program Files\Git\bin\bash.exe" -lc "cd '/c/Users/ADMIN/Projects/bash-assignment' && ./run_all.sh"
```

If running `./scripts/*.sh` opens a new Git Bash window each time, that is a Windows file association behavior for `.sh` files. To keep everything in one terminal session, run inside a Git Bash terminal and execute commands there.

---

## 🛠️ Cross-Platform Fixes Applied

- `system_check.sh`
  - Uses `free -m` on Linux.
  - Falls back to `vm_stat` on macOS.
  - Uses a portable process listing for top memory usage when GNU `ps --sort` is unavailable.

- `backup.sh`
  - Avoids backing up `backups/` and `logs/` into the archive when source is project root.
  - Replaced `mapfile` with a portable cleanup pipeline so it works on macOS default Bash.

---

## 📷 Execution Screenshots

### macOS Log 1

![macOS Log 1](macOS_log.png)

### macOS Log 2

![macOS Log 2](macOS_log2.png)

### Windows Log

![Windows Log](windows_log.png)
