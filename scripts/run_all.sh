#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────
#  run_all.sh – Interactive menu for the toolkit
# ─────────────────────────────────────────

SCRIPT_DIR="$(dirname "$0")/scripts"
LOG_DIR="$(dirname "$0")/logs"
LOG_FILE="$LOG_DIR/app.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

run_script() {
    local SCRIPT="$SCRIPT_DIR/$1"
    shift
    if [[ ! -f "$SCRIPT" ]]; then
        log "ERROR: Script '$SCRIPT' not found."
        echo "❌ Script not found: $SCRIPT"
        return 1
    fi
    log "Running: $SCRIPT $*"
    bash "$SCRIPT" "$@" || {
        log "ERROR: '$SCRIPT' exited with an error."
        echo "⚠️  Script encountered an error."
    }
}

# ── Menu Functions ───────────────────────
run_all() {
    log "ACTION: Run All Scripts"
    echo "🚀 Running all scripts..."
    run_script "user_info.sh"
    run_script "system_check.sh"
    read -rp "Enter a directory to back up: " BACKUP_TARGET
    run_script "backup.sh" "$BACKUP_TARGET"
    run_script "process_monitor.sh"
    echo "✅ All scripts completed."
    log "ACTION: Run All — completed"
}

system_check() {
    log "ACTION: System Check"
    run_script "system_check.sh"
}

backup_menu() {
    read -rp "Enter the directory to back up: " BACKUP_TARGET
    log "ACTION: Backup '$BACKUP_TARGET'"
    run_script "backup.sh" "$BACKUP_TARGET"
}

# ── Interactive Menu ─────────────────────
while true; do
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║      DevOps Bash Toolkit Menu        ║"
    echo "╠══════════════════════════════════════╣"
    echo "║  1. Run All Scripts                  ║"
    echo "║  2. System Check                     ║"
    echo "║  3. Backup a Directory               ║"
    echo "║  4. Exit                             ║"
    echo "╚══════════════════════════════════════╝"
    read -rp "Choose an option [1-4]: " CHOICE

    case "$CHOICE" in
        1) run_all ;;
        2) system_check ;;
        3) backup_menu ;;
        4)
            log "ACTION: Exit — user quit the menu."
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "⚠️  Invalid option. Please choose 1–4."
            log "WARNING: Invalid menu choice '$CHOICE'"
            ;;
    esac
done

