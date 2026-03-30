#!/bin/bash

# 1. Get the current date for the log filename
DATE=$(date +%Y-%m-%d)
LOG_FILE="logs/system_report_$DATE.log"

echo "--- System Check Report ($DATE) ---" | tee -a $LOG_FILE

# 2. Check Disk Usage
echo "Checking Disk Usage..." | tee -a $LOG_FILE
df -h | grep '^/dev/' | tee -a $LOG_FILE

# 3. Check Memory Usage (in Megabytes)
echo -e "\nChecking Memory Usage..." | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

# 4. Check CPU Load and Uptime
echo -e "\nChecking CPU Load..." | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

# 5. Count Total Running Processes
PROCESS_COUNT=$(ps aux | wc -l)
echo -e "\nTotal Running Processes: $PROCESS_COUNT" | tee -a $LOG_FILE

# 6. Top 5 Memory Consuming Processes
echo -e "\nTop 5 Memory-Consuming Processes:" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE

# 7. Bonus: Disk Usage Warning (Checks if any disk is over 80%)
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo -e "\nWARNING: Disk usage is above 80%! ($DISK_USAGE%)" | tee -a $LOG_FILE
else
    echo -e "\nDisk usage is healthy ($DISK_USAGE%)." | tee -a $LOG_FILE
fi

echo -e "\nReport saved to $LOG_FILE"

