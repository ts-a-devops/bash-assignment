#!/bin/bash

# Set log file with date
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="logs/system_report_$DATE.log"

echo "===== SYSTEM REPORT ($DATE) =====" | tee -a "$LOG_FILE"

# Disk usage
echo -e "\n--- Disk Usage ---" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

# Check for disk usage > 80%
echo -e "\n--- Disk Usage Warnings ---" | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {print $5 " " $6}' | while read usage mount; do
    percent=${usage%\%}
    if (( percent > 80 )); then
        warning="WARNING: Disk usage on $mount is ${percent}%"
        echo "$warning" | tee -a "$LOG_FILE"
    fi
done

# Memory usage
echo -e "\n--- Memory Usage ---" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

# CPU load
echo -e "\n--- CPU Load ---" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

# Total running processes
echo -e "\n--- Total Running Processes ---" | tee -a "$LOG_FILE"
process_count=$(ps aux | wc -l)
echo "Total processes: $process_count" | tee -a "$LOG_FILE"

# Top 5 memory-consuming processes
echo -e "\n--- Top 5 Memory-Consuming Processes ---" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo -e "\n===== END OF REPORT =====" | tee -a "$LOG_FILE"



