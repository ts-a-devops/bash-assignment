#!/bin/bash

LOG_DIR="logs"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

mkdir -p "$LOG_DIR"

{
    echo "=== SYSTEM REPORT ($DATE) ==="
    echo

    echo "--- Disk Usage (df -h) ---"
    df -h
    echo

    echo "--- Memory Usage (free -m) ---"
    free -m
    echo

    echo "--- CPU Load (uptime) ---"
    uptime
    echo

    # Warning if disk > 80%
    HIGH_DISK=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

    if [ "$HIGH_DISK" -gt 80 ]; then
        echo "⚠️ WARNING: Disk usage is above 80%!"
    fi

    echo
    echo "--- Total Processes ---"
    ps aux | wc -l

    echo
    echo "--- Top 5 Memory-Consuming Processes ---"
    ps aux --sort=-%mem | head -n 6

} | tee "$LOG_FILE"
