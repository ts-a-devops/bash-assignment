#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/app.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

SCRIPT_DIR="scripts"

run_script() {
    local script="$1"
    log "Running: ${script}"
    if [[ -x "${SCRIPT_DIR}/${script}" ]]; then
        "${SCRIPT_DIR}/${script}" || log "WARNING: ${script} exited with error"
    else
        log "ERROR: Script not found or not executable: ${script}"
        echo "Error: ${script} not found."
    fi
}

while true; do
    echo
    echo "=== Automation Menu ==="
    echo "1. Run All Scripts"
    echo "2. System Check"
    echo "3. Backup (provide directory)"
    echo "4. User Info"
    echo "5. File Manager (demo)"
    echo "6. Process Monitor (nginx example)"
    echo "7. Exit"
    echo -n "Choose an option: "
    read -r choice

    case "${choice}" in
        1)
            log "Running all core scripts..."
            run_script "user_info.sh"      # interactive
            run_script "system_check.sh"
            # Note: backup and file_manager need args, so skipped in "all" or prompt
            echo "Run backup and file operations manually for full coverage."
            ;;
        2)
            run_script "system_check.sh"
            ;;
        3)
            echo -n "Enter directory to backup: "
            read -r dir
            run_script "backup.sh" "${dir}"   # passing arg
            ;;
        4)
            run_script "user_info.sh"
            ;;
        5)
            echo "File Manager demo:"
            "${SCRIPT_DIR}/file_manager.sh" list .
            ;;
        6)
            run_script "process_monitor.sh" "nginx"  # or any service
            ;;
        7)
            log "Exiting menu."
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
