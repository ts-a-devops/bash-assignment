#!/bin/bash
DATE=$(date +%Y-%m-%d)
LOG_FILE="logs/system_report_$DATE.log"

mkdir -p logs

{
    echo "--- System Check Report ---"
    
    echo "Disk Usage:"
    df -h
    
    echo -e "\nMemory Usage:"
    free -m
    
    echo -e "\nCPU Load:"
    uptime
    
    echo -e "\nTotal Running Processes:"
    ps aux | wc -l
    
    echo -e "\nTop 5 Memory-Consuming Processes:"
    ps aux --sort=-%mem | awk 'NR<=6 {print $0}'
    
    # Disk usage warning logic
    DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    if [ "$DISK_USAGE" -gt 80 ]; then
        echo -e "\nWARNING: Disk usage exceeds 80% (Current: $DISK_USAGE%)"
    fi
} | tee "$LOG_FILE"
