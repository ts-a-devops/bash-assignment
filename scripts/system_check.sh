#!/bin/bash

mkdir -p logs

log_file="logs/system_report_$(date +%F).log"

echo "System report - $(date)" >> "$log_file"

echo "Disk Usage - $(date)" >> "$log_file"
df -h >> "$log_file"

echo "Memory Usage:" >> "$log_file"
free -m >> "$log_file"

echo "CPU load" >> "$log_file"
uptime >> "$log_file"

echo "Total Processes" >> "$log_file"
ps aux | wc -l >> "$log_file"

echo "Top 5 Memory processes" >> "$log_file"
ps aux --sort=-%mem | head -n 6 >> "$log_file"

if df -h | awk '$5+0 > 80 {print}' | grep -q .; then
echo "Warning: Disk usage above 80%" | tee -a "$log_file"
fi

echo "Result saved to $log_file"



