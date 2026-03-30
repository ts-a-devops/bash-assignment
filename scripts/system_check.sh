#!/bin/bash

LOG_DIR="logs"
DATE=$(date +%Y%m%d)
LOG_FILE="$LOG_DIR/system_report_${DATE}.log"

mkdir -p "$LOG_DIR"

{
    echo "=== System Check Report ($(date)) ==="
    echo ""
    echo "Disk usage:"
    df -h
    echo ""
    echo "Memory usage:"
    free -m
    echo ""
    echo "CPU load:"
    uptime
    echo ""
    echo "Total running processes:"
    ps aux | wc -l
    echo ""
    echo "Top 5 memory-consuming processes:"
    ps aux --sort=-%mem | head -6 | tail -n +2
} | tee "$LOG_FILE"

if ( df -h > 80); then
    echo "Disk usage is above 80% on some mount point." >&2 | tee -a "$LOG_FILE"
fi
