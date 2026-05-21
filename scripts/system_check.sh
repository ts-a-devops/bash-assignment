#!/bin/bash

mkdir -p logs

echo "=== System Health Check ==="

DATE=$(date +%Y%m%d_%H%M%S)
LOGFILE="logs/system_report_${DATE}.log"

{
    echo "=== System Report - $(date) ==="
    echo "Disk Usage:"
    df -h
    echo -e "\nMemory Usage:"
    if command -v free &> /dev/null
    then
        free -m
    else
        echo "Memory stats tool (free) not available on this system."
    fi
    vm_stat | perl -ne 'print "$1: ",$2*4096/1024/1024,"\n" if /([^:]+):\s+(\d+)/'
    echo -e "\nCPU Load:"
    uptime
    
    echo -e "\nTotal Running Processes: $(ps aux | wc -l)"
    echo -e "\nTop 5 Memory Consuming Processes:"
    ps -amcwwwxo pmem,pid,ppid,user,command | head -n 6
} | tee "$LOGFILE"

# Disk usage warning
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')

if (( DISK_USAGE > 80 ))
then
    echo "WARNING: Disk usage is high ($DISK_USAGE%)!" | tee -a "$LOGFILE"
fi

echo "System report saved to $LOGFILE"