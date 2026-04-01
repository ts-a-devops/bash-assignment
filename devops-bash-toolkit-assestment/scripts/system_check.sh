#!/bin/bash
set -euo pipefail
REPORT="logs/system_report_$(date +%F).log"

{
    echo "--- System Report $(date) ---"
    echo "Disk Usage:" && df -h | grep '^/'
    echo "Memory Usage:" && free -m
    echo "CPU Load:" && uptime
    echo "Total Processes: $(ps aux | wc -l)"
    echo "Top 5 Memory Consumers:" && ps aux --sort=-%mem | head -n 6
} | tee -a "$REPORT"

# Warning logic
usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$usage" -gt 80 ]; then echo "WARNING: Disk usage at ${usage}%" | tee -a "$REPORT"; fi
