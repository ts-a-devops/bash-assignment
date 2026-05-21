#!/bin/bash
# =============================================================================
# run_all.sh - Interactive menu to orchestrate the toolkit scripts
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")/scripts"
LOG_DIR="$(dirname "$0")/logs"
APP_LOG="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

# ── Helper: log to app log ────────────────────────────────────────────────────
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$APP_LOG"
}

# ── Helper: run a script with error handling ──────────────────────────────────
run_script() {
    local script="$1"
    shift
    local path="$SCRIPT_DIR/$script"

    if [[ ! -f "$path" ]]; then
        echo "  ✖  Script not found: $path"
        log "ERROR — script not found: $path"
        return 1
    fi

    log "RUNNING — $script $*"
    echo ""
    if bash "$path" "$@"; then
        log "SUCCESS — $script completed."
    else
        echo "  ⚠  '$script' exited with an error. Check logs for details."
        log "FAILED — $script exited non-zero."
    fi
    echo ""
}

# ── Menu Functions ────────────────────────────────────────────────────────────
run_all() {
    echo "  ── Running all scripts ──────────────────"
    log "MENU — Run All selected."

    echo ""
    echo "  [1/4] user_info.sh"
    run_script "user_info.sh"

    echo "  [2/4] system_check.sh"
    run_script "system_check.sh"

    echo "  [3/4] backup.sh"
    read -rp "  Enter directory to backup: " BACKUP_TARGET
    run_script "backup.sh" "$BACKUP_TARGET"

    echo "  [4/4] process_monitor.sh"
    run_script "process_monitor.sh"

    echo "  ✔  All scripts completed."
    log "MENU — Run All finished."
}

system_check() {
    log "MENU — System Check selected."
    run_script "system_check.sh"
}

run_backup() {
    log "MENU — Backup selected."
    read -rp "  Enter directory to backup: " BACKUP_TARGET
    run_script "backup.sh" "$BACKUP_TARGET"
}

# ── Draw Menu ─────────────────────────────────────────────────────────────────
show_menu() {
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║       DevOps Bash Toolkit — Menu         ║"
    echo "╠══════════════════════════════════════════╣"
    echo "║  1.  Run all scripts                     ║"
    echo "║  2.  System check                        ║"
    echo "║  3.  Backup a directory                  ║"
    echo "║  4.  Exit                                ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
}

# ── Main Loop ─────────────────────────────────────────────────────────────────
log "===== run_all.sh started ====="

while true; do
    show_menu
    read -rp "  Select an option [1-4]: " CHOICE

    case "$CHOICE" in
        1) run_all       ;;
        2) system_check  ;;
        3) run_backup    ;;
        4)
            echo "  Goodbye!"
            log "===== run_all.sh exited by user ====="
            exit 0
            ;;
        *)
            echo "  ✖  Invalid option '$CHOICE'. Please choose 1–4."
            log "MENU — invalid option: '$CHOICE'."
            ;;
    esac
done