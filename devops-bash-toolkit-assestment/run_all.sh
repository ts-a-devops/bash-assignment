#!/bin/bash

set -euo pipefail

Applog="logs/app.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$Applog"
}


run_script() {
    script_name=$1
    shift

    if [[ -f "scripts/$script_name" ]]; then
        log "Running $script_name"

        if bash "scripts/$script_name" "$@"; then
            log "$script_name executed successfully"
        else
            log "$script_name failed"
        fi
    else
        log "ERROR: scripts/$script_name not found"
    fi
}

run_all() {
    log "Running all scripts"
    for script in scripts/*.sh; do
        run_script "$(basename "$script")"
    done
}

system_check() {
    run_script "system_check.sh"
}

backup() {
    run_script "backup.sh"
}

show_menu() {
    echo ""
    echo "=== MENU ==="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo "============"
}

main() {
    while true; do
        show_menu
        read -rp "Choose an option: " choice

        case $choice in
            1) 
                run_all
                ;;
            2)
                system_check
                ;;
            3)
                backup
                ;;
            4)
                log "Exiting Application"
                exit 0
                ;;
            *)
                echo "Invalid Option"
                ;;
        esac
    done
}

main
