#!/bin/bash
# ─────────────────────────────────────────
#  run_all.sh - Interactive menu to run scripts
# ─────────────────────────────────────────

set -euo pipefail

# ── Log file ──
LOG_FILE="logs/app.log"

# ── Create logs folder if it doesn't exist ──
mkdir -p logs

# ── Timestamp ──
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# ── Function to print and log ──
log() {
  echo "$1" | tee -a "$LOG_FILE"
}

# ─────────────────────────────────────────
# FUNCTION: Display Menu
# ─────────────────────────────────────────
show_menu() {
  clear
  echo "========================================="
  echo "       DEVOPS BASH TOOLKIT MENU          "
  echo "========================================="
  echo "  1. Run All Scripts"
  echo "  2. System Check"
  echo "  3. Backup"
  echo "  4. Exit"
  echo "========================================="
  read -p "  Enter your choice [1-4]: " CHOICE
}

# ─────────────────────────────────────────
# FUNCTION: Run All Scripts
# ─────────────────────────────────────────
run_all() {
  log "[$TIMESTAMP] INFO: Running all scripts..."
  echo ""

  # ── user_info.sh ──
  log "[$TIMESTAMP] INFO: Running user_info.sh..."
  if bash scripts/user_info.sh; then
    log "[$TIMESTAMP] SUCCESS: user_info.sh completed."
  else
    log "[$TIMESTAMP] ERROR: user_info.sh failed."
  fi

  echo ""

  # ── system_check.sh ──
  log "[$TIMESTAMP] INFO: Running system_check.sh..."
  if bash scripts/system_check.sh; then
    log "[$TIMESTAMP] SUCCESS: system_check.sh completed."
  else
    log "[$TIMESTAMP] ERROR: system_check.sh failed."
  fi

  echo ""

  # ── file_manager.sh ──
  log "[$TIMESTAMP] INFO: Running file_manager.sh..."
  if bash scripts/file_manager.sh list .; then
    log "[$TIMESTAMP] SUCCESS: file_manager.sh completed."
  else
    log "[$TIMESTAMP] ERROR: file_manager.sh failed."
  fi

  echo ""

  # ── backup.sh ──
  log "[$TIMESTAMP] INFO: Running backup.sh..."
  if bash scripts/backup.sh .; then
    log "[$TIMESTAMP] SUCCESS: backup.sh completed."
  else
    log "[$TIMESTAMP] ERROR: backup.sh failed."
  fi

  echo ""

  # ── process_monitor.sh ──
  log "[$TIMESTAMP] INFO: Running process_monitor.sh..."
  if bash scripts/process_monitor.sh; then
    log "[$TIMESTAMP] SUCCESS: process_monitor.sh completed."
  else
    log "[$TIMESTAMP] ERROR: process_monitor.sh failed."
  fi

  echo ""
  log "[$TIMESTAMP] INFO: All scripts completed."
}

# ─────────────────────────────────────────
# FUNCTION: System Check
# ─────────────────────────────────────────
run_system_check() {
  log "[$TIMESTAMP] INFO: Running system_check.sh..."
  echo ""

  if bash scripts/system_check.sh; then
    log "[$TIMESTAMP] SUCCESS: system_check.sh completed successfully."
  else
    log "[$TIMESTAMP] ERROR: system_check.sh encountered an error."
  fi
}

# ─────────────────────────────────────────
# FUNCTION: Backup
# ─────────────────────────────────────────
run_backup() {
  echo ""
  read -p "Enter the directory to backup: " BACKUP_TARGET

  # ── Validate directory ──
  if [[ -z "$BACKUP_TARGET" ]]; then
    log "[$TIMESTAMP] ERROR: No directory entered for backup."
    echo "Error: No directory provided."
    return 1
  fi

  if [[ ! -d "$BACKUP_TARGET" ]]; then
    log "[$TIMESTAMP] ERROR: Directory '$BACKUP_TARGET' does not exist."
    echo "Error: Directory '$BACKUP_TARGET' does not exist."
    return 1
  fi

  log "[$TIMESTAMP] INFO: Running backup.sh for '$BACKUP_TARGET'..."

  if bash scripts/backup.sh "$BACKUP_TARGET"; then
    log "[$TIMESTAMP] SUCCESS: backup.sh completed for '$BACKUP_TARGET'."
  else
    log "[$TIMESTAMP] ERROR: backup.sh failed for '$BACKUP_TARGET'."
  fi
}

# ─────────────────────────────────────────
# FUNCTION: Exit
# ─────────────────────────────────────────
exit_app() {
  echo ""
  log "[$TIMESTAMP] INFO: Exiting DevOps Bash Toolkit. Goodbye!"
  echo ""
  exit 0
}

# ─────────────────────────────────────────
# MAIN LOOP
# ─────────────────────────────────────────
log "========================================="
log "  APP STARTED - $TIMESTAMP"
log "========================================="

while true; do
  # ── Show menu and get choice ──
  show_menu

  case $CHOICE in
    1)
      echo ""
      log "[$TIMESTAMP] INFO: Option 1 selected - Run All Scripts"
      run_all
      echo ""
      read -p "Press ENTER to return to menu..." PAUSE
      ;;
    2)
      echo ""
      log "[$TIMESTAMP] INFO: Option 2 selected - System Check"
      run_system_check
      echo ""
      read -p "Press ENTER to return to menu..." PAUSE
      ;;
    3)
      echo ""
      log "[$TIMESTAMP] INFO: Option 3 selected - Backup"
      run_backup
      echo ""
      read -p "Press ENTER to return to menu..." PAUSE
      ;;
    4)
      exit_app
      ;;
    *)
      echo ""
      log "[$TIMESTAMP] WARNING: Invalid option '$CHOICE' selected."
      echo "Invalid choice. Please enter a number between 1 and 4."
      echo ""
      read -p "Press ENTER to return to menu..." PAUSE
      ;;
  esac

done
