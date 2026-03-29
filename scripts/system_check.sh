#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="logs/system_report_$DATE.log"

echo "===== SYSTEM REPORT ($DATE) =====" | tee -a $LOG_FILE

echo -e "\n--- Disk Usage ---" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

# ==== Check disk usage and warn if above 80% ====
echo -e "\n--- Disk Usage Warnings ---" | tee -a $LOG_FILE
df -h | awk 'NR>1 {print $5 " " $1}' | while read usage partition; do
    usage_value=$(echo $usage | sed 's/%//')
    if [ "$usage_value" -gt 80 ]; then
        WARNING="WARNING: $partition is at ${usage_value}% usage!"
        echo $WARNING | tee -a $LOG_FILE
    fi
done

echo -e "\n--- Memory Usage ---" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

echo -e "\n--- CPU Load ---" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

# ==== Count total running processes ====
PROCESS_COUNT=$(ps aux | wc -l)
echo -e "\nTotal Running Processes: $PROCESS_COUNT" | tee -a $LOG_FILE

# ==== Top 5 memory-consuming processes ====
echo -e "\n--- Top 5 Memory Consuming Processes ---" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE

echo -e "\n===== END OF REPORT =====" | tee -a $LOG_FILE
