#!/bin/bash

# Ensure logs directory exists
mkdir -p logs

# Get current date
date=$(date +"%Y-%m-%d_%H-%M-%S")

log_file="logs/system_report_$date.log"

# Disk usage
echo "Disk Usage:" > "$log_file"
df -h >> "$log_file"

# Memory usage
echo -e "\nMemory Usage:" >> "$log_file"
free -m >> "$log_file"

# CPU load
echo -e "\nCPU Load:" >> "$log_file"
uptime >> "$log_file"

# Check disk usage warning
usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$usage" -gt 80 ]; then
    echo -e "\nWARNING: Disk usage is above 80%" >> "$log_file"
fi

# Count running processes
echo -e "\nTotal Running Processes:" >> "$log_file"
ps aux | wc -l >> "$log_file"

# Top 5 memory-consuming processes
echo -e "\nTop 5 Memory Consuming Processes:" >> "$log_file"
ps aux --sort=-%mem | head -6 >> "$log_file"

echo "System check completed. Report saved to $log_file"
