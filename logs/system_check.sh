#!/bin/bash

date=(date +"%Y-%m-%d")
log_file="logs/systems_report_$date.log"

echo "===== SYSTEM CHECK REPORT ($date) =====" | tee -a "$log_file"

echo -e "\nDisk Usage:" | tee -a "$log_file"
df -h | tee -a "$log_file"

echo -e "\nDisk Warnings:" | tee -a "$log_file"
df -h | awk 'NR>1 {gsub("%",""); if ($5 > 80) print "Warning: " $1 " is at " $5

echo -e "\nMemory Usage (MB):" | tee -a "$log_file"
free -m | tee -a "$log_file"

echo -e "\nCPU Load:" | tee -a "$log_file"
uptime | tee -a "$log_file"

echo -e "\n===== END OF REPORT =====" | tee -a "$log_file" 
