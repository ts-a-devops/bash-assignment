#!/bin/bash
set -euo pipefail

log_file="logs/app.log"
scripts_dir="Scripts"
mkdir -p logs

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2" | tee -a "$log_file"; }

system_check() {
    log "INFO" "System check"
    if [ -f "$scripts_dir/system_check.sh" ]; then
        bash "$scripts_dir/system_check.sh"
    else
        df -h | head -4; free -m; uptime
        [ $(df -h / | awk 'NR==2{print $5}' | tr -d '%') -gt 80 ] && echo "⚠️ Disk >80%"
    fi
}

backup() {
    log "INFO" "Backup"
    if [ -f "$scripts_dir/backup.sh" ]; then
        bash "$scripts_dir/backup.sh"
    else
        mkdir -p backups
        f="backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz"
        tar -czf "$f" --exclude=backups --exclude=logs . 2>/dev/null && echo "✓ $f"
        cd backups 2>/dev/null && ls -1t *.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f && cd - > /dev/null
    fi
}

while true; do
    echo "1) System Check  2) Backup  3) Exit"
    read -p "Choose: " c
    case $c in
        1) system_check ;;
        2) backup ;;
        3) log "INFO" "Exit"; exit 0 ;;
        *) echo "Invalid" ;;
    esac
    read -p "Press Enter..."
done