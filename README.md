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


## ✅ Implementation Summary

I have successfully implemented all the required scripts and both bonus scripts as per the requirements.

## 📋 Scripts Implemented

### Required Scripts
- **`scripts/user_info.sh`** — Prompts for name, age, country with validation, determines age category, and logs to `logs/user_info.log`
- **`scripts/system_check.sh`** — Shows disk usage (with >80% warnings), memory, CPU load, total processes, top 5 memory consumers, and saves dated report
- **`scripts/file_manager.sh`** — Supports `create`, `delete`, `list`, `rename` with proper validation and logging to `logs/file_manager.log`
- **`scripts/backup.sh`** — Creates compressed timestamped backups, stores in `backups/`, keeps only the last 5 backups, and logs activity

### Bonus Scripts
- **`scripts/process_monitor.sh`** — Monitors processes (default services or specific one), shows status, and simulates restart
- **`run_all.sh`** — Interactive menu to run all scripts or individual ones with centralized logging

## 🚀 Usage

```bash
# Make all scripts executable
chmod +x scripts/*.sh run_all.sh

# Run individual script
./scripts/user_info.sh

# Run the full interactive menu
./run_all.sh
