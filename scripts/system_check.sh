#!/bin/bash
# This is the system check script

mkdir -p logs

echo "System Check Report"

echo "1. Disk Usage:"
df -h

echo -e "\n2. Memory Usage:"
free -m

echo -e "\n3. CPU Load:"
uptime

# Count how many processes are running
total=$(ps aux | wc -l)
echo -e "\nTotal running processes: $total"

# Show top 5 programs using most memory
echo -e "\nTop 5 programs using memory:"
ps aux --sort=-%mem | head -n 6

# Warning if disk is almost full
usage=$(df / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
if [ "$usage" -ge 80 ]; then
    echo "WARNING: Your disk is ${usage}% full!"
fi

# Save report with date in filename
date_now=$(date +%Y%m%d_%H%M)
report_file="logs/system_report_${date_now}.log"

{
    echo "System Report - $(date)"
    df -h
    echo -e "\nMemory:"
    free -m
    echo -e "\nCPU Load:"
    uptime
    echo -e "\nTotal Processes: $total"
} > "$report_file"

echo "Report saved as $report_file"