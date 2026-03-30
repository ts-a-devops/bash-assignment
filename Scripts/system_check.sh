#!/bin/bash

# 1. Setup logging with current date
mkdir -p logs
REPORT_FILE="logs/system_report_$(date +%Y-%m-%d).log"

{
    echo "=========================================="
    echo "System Report - $(date)"
    echo "=========================================="

    # 2. Disk Usage (df -h)
    echo -e "\n[Disk Usage]"
    df -h

    # 3. Memory Usage (free -m)
    echo -e "\n[Memory Usage]"
    free -m

    # 4. CPU Load (uptime)
    echo -e "\n[CPU Load]"
    uptime

    # 5. Total Running Processes
    echo -e "\n[Total Running Processes]"
    ps aux | wc -l

    # 6. Top 5 Memory-Consuming Processes
    echo -e "\n[Top 5 Memory-Consuming Processes]"
    ps aux --sort=-%mem | awk 'NR<=6 {print $0}'

    echo "=========================================="
} | tee -a "$REPORT_FILE"



# 7. Warning if disk usage exceeds 80%
# Checks the root partition (/) percentage
usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$usage" -gt 80 ]; then
    echo -e "\n*** WARNING: Disk usage is at ${usage}%! ***" | tee -a "$REPORT_FILE"
fi

echo -e "\nReport saved to: $REPORT_FILE"
