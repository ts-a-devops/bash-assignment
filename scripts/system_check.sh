#!/usr/bin/env bash

sys_info() {
# Disk usage
df -h | awk 'NR > 1 && ($5 + 0) > 80 {print "Warning: $1 space exceeds 80%"}'
# Memory usage
free -m
# CPU load (uptime)
uptime
# Display top 5 memory-consuming processes
ps aux | awk ' NR > 1 && $4 > 0.0 {print $4} ' | sort -nr | head -5

# Count total running processes
ps aux | awk ' {count++} END {print count}'

}

sys_info > system_report.log