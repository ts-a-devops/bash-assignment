#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Get current date
current_date=$(date +%Y-%m-%d)
log_file="logs/system_report_$current_date.log"

echo "===== SYSTEM CHECK ====="

# Disk usage
echo "=== Disk Usage ==="
df -h

# Warn if disk usage exceeds 80%
disk_usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$disk_usage" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%!"
fi

# Memory usage
echo ""
echo "=== Memory Usage ==="
free -m

# CPU load
echo ""
echo "=== CPU Load ==="
uptime

# Total running processes
echo ""
echo "=== Total Running Processes ==="
ps aux | wc -l

# Top 5 memory consuming processes
echo ""
echo "=== Top 5 Memory Consuming Processes ==="
ps aux --sort=-%mem | head -6

# Save report to log
{
    echo "===== SYSTEM REPORT ($current_date) ====="
    df -h
    free -m
    uptime
} >> "$log_file"

echo "Report saved to $log_file"
