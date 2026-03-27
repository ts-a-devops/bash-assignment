#!/bin/bash
# scripts/system_check.sh
DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="logs/system_report_$DATE.log"

# Create logs directory if it doesn't exist
mkdir -p logs

{
    echo "--- System Report ($DATE) ---"
    echo "----------------------------"
    
    echo "1. Disk Usage:"
    df -h /
    
    # Warning for Disk Usage > 80%
    # This checks the percentage used on the root partition
    usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')
    if [ "$usage" -gt 80 ]; then
        echo "⚠️  WARNING: Disk usage is critically high at ${usage}%!"
    else
        echo "Disk usage is healthy (${usage}%)."
    fi

    echo -e "\n2. Memory Usage (MB):"
    free -m

    echo -e "\n3. CPU Load & Uptime:"
    uptime

    echo -e "\n4. Total Running Processes: $(ps ax | wc -l)"

    echo -e "\n5. Top 5 Memory-Consuming Processes:"
    # Shows PID, Command, and % Memory
    ps -eo pid,cmd,%mem --sort=-%mem | head -n 6
} | tee "$LOG_FILE"

echo -e "\nReport saved to: $LOG_FILE"
