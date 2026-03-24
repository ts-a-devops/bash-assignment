#!/bin/bash

# Create log file with date
log_file="logs/system_report_$(date +%Y-%m-%d_%H-%M-%S).log"

echo "===== SYSTEM HEALTH REPORT =====" | tee -a "$log_file"
echo "Generated on: $(date)" | tee -a "$log_file"
echo "" | tee -a "$log_file"

# Disk Usage
echo "=== Disk Usage ===" | tee -a "$log_file"
df -h | tee -a "$log_file"

echo "" | tee -a "$log_file"

# Check disk usage warning (>80%)
echo "=== Disk Usage Warning Check ===" | tee -a "$log_file"
df -h | awk 'NR>1 {print $5 " " $6}' | while read usage mount; do
    usage_percent=${usage%\%}
    if [ "$usage_percent" -gt 80 ]; then
        echo "WARNING: Disk usage on $mount is at ${usage_percent}%" | tee -a "$log_file"
    fi
done

echo "" | tee -a "$log_file"

# Memory Usage
echo "=== Memory Usage ===" | tee -a "$log_file"
free -m | tee -a "$log_file"

echo "" | tee -a "$log_file"

# CPU Load
echo "=== CPU Load ===" | tee -a "$log_file"
uptime | tee -a "$log_file"

echo "" | tee -a "$log_file"

# Total running processes
echo "=== Total Running Processes ===" | tee -a "$log_file"
ps aux | wc -l | tee -a "$log_file"

echo "" | tee -a "$log_file"

# Top 5 memory-consuming processes
echo "=== Top 5 Memory Consuming Processes ===" | tee -a "$log_file"
ps aux --sort=-%mem | head -n 6 | tee -a "$log_file"

echo "" | tee -a "$log_file"

echo "===== END OF REPORT =====" | tee -a "$log_file"
