 #!/bin/bash

# 1. Create the logs directory and set the filename with today's date
mkdir -p logs
REPORT_FILE="logs/system_report_$(date +%Y-%m-%d).log"

# 2. Collect Data
disk_usage=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//')
cpu_load=$(uptime)
mem_usage=$(free -m)
total_processes=$(ps aux | wc -l)
top_processes=$(ps aux --sort=-%mem | head -n 6)

# 3. Start the Report Output
{
    echo "=========================================="
    echo "SYSTEM CHECK REPORT - $(date)"
    echo "=========================================="

    echo -e "\n--- CPU Load ---"
    echo "$cpu_load"

    echo -e "\n--- Memory Usage (MB) ---"
    echo "$mem_usage"

    echo -e "\n--- Total Running Processes ---"
    echo "$total_processes"

    echo -e "\n--- Top 5 Memory Consuming Processes ---"
    echo "$top_processes"

    echo -e "\n--- Disk Usage Check ---"
    df -h /
    
    # 4. Warning Logic for Disk Usage
    if [ "$disk_usage" -gt 80 ]; then
        echo "!!! WARNING: Disk usage is at ${disk_usage}% (Exceeds 80% threshold) !!!"
    else
        echo "Disk usage is healthy (${disk_usage}%)."
    fi
    echo "=========================================="
} | tee "$REPORT_FILE"

echo -e "\nReport saved to: $REPORT_FILE"
