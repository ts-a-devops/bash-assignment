#!/bin/bash

# variables
DATE=$(date +%Y%m%d)
LOG_FILE="$(dirname "$0")/../logs/system_report_${DATE}.log"


echo "--- System Check Report ---" | tee -a "${LOG_FILE}"

# Display Disk Usage
echo -e "\n[Disk Usage]" | tee -a "${LOG_FILE}"
df -h | tee -a "${LOG_FILE}"

# Display Memory Usage
echo -e "\n[Memory Usage]" | tee -a "${LOG_FILE}"
 free -m | tee -a "${LOG_FILE}"

# Display CPU Load
echo -e "\n[CPU Load]" | tee -a "${LOG_FILE}"
uptime | tee -a "${LOG_FILE}"

# Count total running processes
echo -e "\n[Total Running Processes]" | tee -a "${LOG_FILE}"
 ps aux | wc -l | tee -a "${LOG_FILE}"

# Display top 5 memory-consuming processes
echo -e "\n[Top 5 Memory-Consuming Processes]" | tee -a "${LOG_FILE}"
ps aux --sort=-%mem | head -n 6 | tee -a "${LOG_FILE}"

# Warn if disk usage exceeds 80%
usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')


if (( ${usage} > 80 ))
then
    echo -e "\nWARNING: Disk usage is high at ${usage}%!" | tee -a "${LOG_FILE}"
    else
        echo -e "\nDisk usage is healthy at ${usage}%." | tee -a "${LOG_FILE}"
        fi

        echo -e "\nReport saved to ${LOG_FILE}"
