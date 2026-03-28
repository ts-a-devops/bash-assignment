#!/usr/bin/env bash
# =============================================================================
# run_all.sh — Interactive menu to run toolkit scripts. Handles failures
#              gracefully and logs all actions to logs/app.log.
# =============================================================================
set -euo pipefail

# ── Paths ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/app.log"

# ── Ensure log directory exists ───────────────────────────────────────────────
mkdir -p "$LOG_DIR"

# ── Logging helper ────────────────────────────────────────────────────────────
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# ── Run a script safely, catching failures ────────────────────────────────────
run_script() {
    local script_path="$1"
    local script_name
    script_name="$(basename "$script_path")"

    # Verify the script exists and is executable
    if [[ ! -f "$script_path" ]]; then
        log "ERROR" "Script not found: '$script_path'"
        echo "  ✗  Script '$script_name' not found." >&2
        return 1
    fi

    if [[ ! -x "$script_path" ]]; then
        log "WARN" "'$script_name' is not executable. Attempting chmod +x..."
        chmod +x "$script_path"
    fi

    log "INFO" "Running: $script_name"
    echo ""
    echo "  ▶  Running $script_name..."
    echo "  ─────────────────────────────────────────"

    # Run the script; capture exit code without triggering set -e
    if bash "$script_path"; then
        log "INFO" "$script_name completed successfully."
        echo "  ✔  $script_name finished."
    else
        local exit_code=$?
        log "ERROR" "$script_name failed with exit code $exit_code."
        echo "  ✗  $script_name encountered an error (exit code: $exit_code)." >&2
    fi
}

# ── Run all scripts ───────────────────────────────────────────────────────────
run_all() {
    log "INFO" "Running all scripts..."
    run_script "$SCRIPTS_DIR/user_info.sh"
    run_script "$SCRIPTS_DIR/system_check.sh"

    # Prompt for backup target directory
    echo ""
    read -rp "  Enter directory to back up (for backup.sh): " backup_target
    if [[ -n "$backup_target" ]]; then
        bash "$SCRIPTS_DIR/backup.sh" "$backup_target" || \
            log "ERROR" "backup.sh failed for target: '$backup_target'"
    else
        log "WARN" "No backup target provided. Skipping backup.sh."
        echo "  ⚠  Skipping backup — no directory provided."
    fi

    run_script "$SCRIPTS_DIR/process_monitor.sh"
    log "INFO" "All scripts completed."
}

# ── System check ──────────────────────────────────────────────────────────────
run_system_check() {
    run_script "$SCRIPTS_DIR/system_check.sh"
}

# ── Backup ────────────────────────────────────────────────────────────────────
run_backup() {
    echo ""
    read -rp "  Enter directory to back up: " backup_target

    if [[ -z "$backup_target" ]]; then
        log "WARN" "No backup target provided."
        echo "  ✗  No directory entered. Returning to menu." >&2
        return
    fi

    if [[ ! -f "$SCRIPTS_DIR/backup.sh" ]]; then
        log "ERROR" "backup.sh not found."
        echo "  ✗  backup.sh not found." >&2
        return 1
    fi

    log "INFO" "Running backup.sh for target: '$backup_target'"
    bash "$SCRIPTS_DIR/backup.sh" "$backup_target" || \
        log "ERROR" "backup.sh failed for target: '$backup_target'"
}

# ── Display menu ──────────────────────────────────────────────────────────────
show_menu() {
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║      DevOps Bash Toolkit Menu        ║"
    echo "╠══════════════════════════════════════╣"
    echo "║  1. Run All Scripts                  ║"
    echo "║  2. System Check                     ║"
    echo "║  3. Backup a Directory               ║"
    echo "║  4. Exit                             ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
}

# ── Main loop ─────────────────────────────────────────────────────────────────
main() {
    log "INFO" "=== run_all.sh started ==="

    while true; do
        show_menu
        read -rp "  Select an option [1-4]: " choice

        case "$choice" in
            1)
                log "INFO" "User selected: Run All Scripts"
                run_all
                ;;
            2)
                log "INFO" "User selected: System Check"
                run_system_check
                ;;
            3)
                log "INFO" "User selected: Backup"
                run_backup
                ;;
            4)
                log "INFO" "User selected: Exit"
                echo ""
                echo "  Goodbye. Logs saved to: $LOG_FILE"
                echo ""
                break
                ;;
            *)
                log "WARN" "Invalid menu selection: '$choice'"
                echo "  ⚠  Invalid option. Please enter 1, 2, 3, or 4." >&2
                ;;
        esac
    done

    log "INFO" "=== run_all.sh exited ==="
}

main "$@"
