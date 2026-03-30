#!/bin/bash
# system_check.sh - System health check with warnings

mkdir -p logs
DATE=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="logs/system_report_$DATE.log"

echo "System Check Report - $DATE" > "$LOG_FILE"

# Disk usage
echo "Disk Usage:" >> "$LOG_FILE"
df -h >> "$LOG_FILE"
disk_used=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$disk_used" -gt 80 ]; then
	echo "Warning: Disk usage exceeds 80%!" >> "$LOG_FILE"
fi

# Memory usage
echo -e "\nMemory Usage:" >> "$LOG_FILE"
free -m >> "$LOG_FILE"

# CPU load
echo -e "\nCPU Load:" >> "$LOG_FILE"
uptime >> "$LOG_FILE"

# Total running processes
echo -e "\nTotal Running Processes:" >> "$LOG_FILE"
ps aux | wc -l >> "$LOG_FILE"

# Top 5 memory-consuming processes
echo -e "\nTop 5 Memory Consuming Processes:" >> "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 >> "$LOG_FILE"

echo "System check completed. Report saved to $LOG_FILE"
