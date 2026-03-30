#!/bin/bash

# System Check Script
# Displays system information and saves report

date=$(date +%Y-%m-%d)
log_file="../logs/system_report_${date}.log"

mkdir -p ../logs



# Display Disk Usage
echo "Disk Usage:"
echo "Disk Usage:" >> "$log_file"
df -h >> "$log_file"
echo "" >> "$log_file"

# Check if disk usage exceeds 80%
disk_usage=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$disk_usage" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%!" >> "$log_file"
else
    echo "Disk usage is OK ($disk_usage%)" >> "$log_file"
fi
echo "" >> "$log_file"

# Display Memory Usage (macOS version)
echo "Memory Usage:"
echo "Memory Usage:" >> "$log_file"
vm_stat >> "$log_file"
echo "" >> "$log_file"

# Display CPU Load
echo "CPU Load:"
echo "CPU Load:" >> "$log_file"
uptime >> "$log_file"
echo "" >> "$log_file"

# Count total running processes
echo "Running Processes:"
total_processes=$(ps -A | wc -l)
total=$((total_processes - 1))
echo "Total running processes: $total"
echo "Total running processes: $total" >> "$log_file"
echo "" >> "$log_file"

# Display top 5 memory-consuming processes (macOS version)
echo "Top 5 Memory-Consuming Processes:"
echo "Top 5 Memory-Consuming Processes:" >> "$log_file"
ps -Am -o %mem,rss,comm | head -6 | tail -5 >> "$log_file"

echo ""
echo "Report saved to: $log_file"
