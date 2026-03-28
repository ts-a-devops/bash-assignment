#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Get current date
date=$(date +%Y-%m-%d)

# Display disk usage
echo "=== Disk Usage ==="
df -h

# Warn if disk usage exceeds 80%
disk_usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$disk_usage" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%!"
fi

# Display memory usage
echo ""
echo "=== Memory Usage ==="
free -m

# Display CPU load
echo ""
echo "=== CPU Load ==="
uptime

# Count total running processes
echo ""
echo "=== Total Running Processes ==="
ps aux | wc -l

# Display top 5 memory consuming processes
echo ""
echo "=== Top 5 Memory Consuming Processes ==="
ps aux --sort=-%mem | head -6

# Save report to log
echo "System report saved to logs/system_report_$date.log"
df -h > logs/system_report_$date.log
free -m >> logs/system_report_$date.log
uptime >> logs/system_report_$date.log
