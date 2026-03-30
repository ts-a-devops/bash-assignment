#!/bin/bash
mkdir -p logs
log_file="logs/system_report_$(date +%F).log"

echo "=== System Check Report ===" | tee -a "$log_file"
echo "Disk Usage:" | tee -a "$log_file"
df -h | tee -a "$log_file"

echo -e "\nMemory Usage:" | tee -a "$log_file"
free -m | tee -a "$log_file"

echo -e "\nCPU Load:" | tee -a "$log_file"
uptime | tee -a "$log_file"

# Check disk usage
disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$disk_usage" -gt 80 ]; then
    echo "WARNING: Disk usage exceeds 80%!" | tee -a "$log_file"
fi

echo -e "\nTotal running processes: $(ps aux | wc -l)" | tee -a "$log_file"
echo "Top 5 Memory-Consuming Processes:" | tee -a "$log_file"
ps aux --sort=-%mem | head -n 6 | tee -a "$log_file"
