#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="../logs/app.log"

log_and_run() {
    "$@" | tee -a "$LOG_FILE"
}

run_all() {
    log_and_run bash file_manager.sh list
    log_and_run bash system_check.sh
    log_and_run bash backup.sh .
    log_and_run bash process_monitor.sh
    log_and_run bash user_info.sh
}

show_menu() {
    cat <<EOF
==== MENU ====
1) Run all tasks
2) System check
3) Backup current directory
4) Exit
==============
EOF
}

handle_choice() {
    case "$1" in
        1) run_all ;;
        2) log_and_run bash system_check.sh ;;
        3) log_and_run bash backup.sh . ;;
        4) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
}

main() {
    while true; do
        show_menu
        read -rp "Choose option: " choice
        handle_choice "$choice"
    done
}

main
