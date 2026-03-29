#!/bin/bash

mkdir -p logs
DATE=$(date +%Y-%m-%d)

echo "=== SYSTEM CHECK ===" | tee logs/system_report_$DATE.log
echo "Disk Usage:" | tee -a logs/system_report_$DATE.log
df -h | tee -a logs/system_report_$DATE.log
echo -e "\nMemory Usage:" | tee -a logs/system_report_$DATE.log
free -m | tee -a logs/system_report_$DATE.log
echo -e "\nCPU Load:" | tee -a logs/system_report_$DATE.log
uptime | tee -a logs/system_report_$DATE.log
echo -e "\nTotal Running Processes:" | tee -a logs/system_report_$DATE.log
ps aux | wc -l | tee -a logs/system_report_$DATE.log
echo -e "\nTop 5 Memory Consuming Processes:" | tee -a logs/system_report_$DATE.log
ps aux --sort=-%mem | head -6 | tee -a logs/system_report_$DATE.log
