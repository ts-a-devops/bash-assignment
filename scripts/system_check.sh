#!/bin/bash

# Define the date and log file path
# The <date> format ensures a new log is created each day
DATE=$(date +%Y-%m-%d)
LOG_FILE="../logs/system_report_$DATE.log"

# Ensure the logs directory exists
mkdir -p ../logs

{
    echo "------------------------------------------"
    echo "System Report Generated on: $(date)"
    echo "------------------------------------------"

    echo -e "\n[Disk Usage]"
    df -h

    echo -e "\n[Memory Usage]"
    free -m

    echo -e "\n[CPU Load]"
    uptime

    # --- DISK WARNING LOGIC ---
    # This grabs the usage % of the root (/) partition
    # awk '{print $5}' picks the 5th column (the percentage)
    # sed 's/%//' removes the '%' symbol so we can compare it as a number
    DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

    if [ "$DISK_USAGE" -gt 80 ]; then
        echo -e "\n⚠️  WARNING: Disk usage is above 80% (Current: ${DISK_USAGE}%)"
    else
        echo -e "\n✅ Disk usage is within safe limits (${DISK_USAGE}%)."
    fi

    echo -e "\n[Process Stats]"
    echo "Total running processes: $(ps aux | wc -l)"
    echo "Top 5 Memory-Consuming Processes:"
    ps aux --sort=-%mem | head -n 6

} | tee -a "$LOG_FILE"
