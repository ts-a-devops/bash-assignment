#!/bin/bash
set -e

# ===== FUNCTIONS =====

user_info() {
  echo "===== USER INFORMATION ====="
  echo "Username       : $(whoami)"
  echo "User ID        : $(id -u)"
  echo "Home Directory : $HOME"
  echo "Shell          : $SHELL"
  echo ""
  echo "Logged-in users:"
  who
}

system_check() {
  echo "===== SYSTEM CHECK ====="

  echo ""
  echo "[Uptime]"
  uptime

  echo ""
  echo "[Disk Usage]"
  df -h

  echo ""
  echo "[Memory Usage]"
  free -h

  echo ""
  echo "[CPU Info]"
  lscpu | grep "Model name"
}

file_manager() {
  echo "===== FILE MANAGER ====="
  echo "1) List files"
  echo "2) Create file"
  echo "3) Delete file"
  echo "4) Back"

  read -p "Choose an option: " option

  case $option in
    1)
      ls -lh
      ;;
    2)
      read -p "Enter file name: " filename
      [[ -z "$filename" ]] && { echo "Filename cannot be empty"; return; }
      touch "$filename"
      echo "File created: $filename"
      ;;
    3)
      read -p "Enter file name to delete: " filename
      if [[ -f "$filename" ]]; then
        rm -i "$filename"
      else
        echo "File not found"
      fi
      ;;
    4)
      return
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
}

backup() {
  echo "===== BACKUP TOOL ====="

  read -p "Enter source directory: " source
  read -p "Enter backup directory: " backup

  if [[ ! -d "$source" ]]; then
    echo "Error: Source directory does not exist"
    return
  fi

  mkdir -p "$backup"

  timestamp=$(date +%Y%m%d_%H%M%S)
  backup_file="$backup/backup_$timestamp.tar.gz"

  echo "[INFO] Creating backup..."
  tar -czf "$backup_file" "$source"

  echo "[SUCCESS] Backup created at: $backup_file"
}

process_monitor() {
  echo "===== PROCESS MONITOR ====="
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -10
}

# ===== MAIN MENU =====

while true; do
  echo ""
  echo "===== DEVOPS BASH TOOLKIT ====="
  echo "1) User Info"
  echo "2) System Check"
  echo "3) File Manager"
  echo "4) Backup"
  echo "5) Process Monitor"
  echo "6) Exit"

  read -p "Select an option: " choice

  case $choice in
    1) user_info ;;
    2) system_check ;;
    3) file_manager ;;
    4) backup ;;
    5) process_monitor ;;
    6) echo "Goodbye!"; exit 0 ;;
    *) echo "Invalid option" ;;
  esac
done
