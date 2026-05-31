et -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app.log"

mkdir -p "$LOG_DIR"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

run_all() {
    log_action "Running all scripts"

    bash scripts/system_check.sh

    read -rp "Enter directory to back up: " dir
    bash scripts/backup.sh "$dir"

    echo "All tasks completed."
}

system_check() {
    log_action "Running system check"
    bash scripts/system_check.sh
}

backup_menu() {
    read -rp "Enter directory to back up: " dir

    log_action "Running backup for $dir"

    if bash scripts/backup.sh "$dir"; then
        echo "Backup completed."
    else
        echo "Backup failed."
        log_action "Backup failed for $dir"
    fi
}

while true; do
    echo
    echo "===== DevOps Bash Toolkit ====="
    echo "1. Run all"
    echo "2. System check"
    echo "3. Backup"
    echo "4. Exit"
    echo

    read -rp "Choose an option: " choice

    case $choice in
        1)
            run_all
            ;;
        2)
            system_check
            ;;
        3)
            backup_menu
            ;;
        4)
            log_action "Application exited"
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done
