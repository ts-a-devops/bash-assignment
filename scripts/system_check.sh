#!/bin/bash
# system_check.sh - System resource check with warnings and logging

set -euo pipefail

LOG_DIR="logs"
mkdir -p "$LOG_DIR"

DATE=$(date '+%Y%m%d_%H%M%S')
REPORT_FILE="${LOG_DIR}/system_report_${DATE}.log"

{
    echo "=== System Check Report - $(date '+%Y-%m-%d %H:%M:%S') ==="
    echo
    
    echo "=== Disk Usage ==="
    df -h
    
    echo
    echo "=== Memory Usage ==="
    free -m
    
    echo
    echo "=== CPU Load ==="
    uptime
    
    echo
    echo "=== Total Running Processes ==="
    ps -e | wc -l
    
    echo
    echo "=== Top 5 Memory-Consuming Processes ==="
    ps aux --sort=-%mem | head -n 6
    
    echo
    echo "=== Disk Usage Warnings ==="
    # Check root filesystem (/) usage
    DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if (( DISK_USAGE > 80 )); then
        echo "WARNING: Disk usage on / is ${DISK_USAGE}% (exceeds 80%)"
    else
        echo "Disk usage on / is ${DISK_USAGE}% (OK)"
    fi
    
} | tee "$REPORT_FILE"

echo "System report saved to $REPORT_FILE"
