#!/bin/bash

mkdir -p logs

date_stamp=$(date +%Y-%m-%d)
log_file="logs/system_report_$date_stamp.log"

echo "=== Disk Usage ===" | tee -a "$log_file"
df -h | tee -a "$log_file"

echo "" | tee -a "$log_file"
echo "=== Memory Usage ===" | tee -a "$log_file"
free -m | tee -a "$log_file"

echo "" | tee -a "$log_file"
echo "=== CPU Load ===" | tee -a "$log_file"
uptime | tee -a "$log_file"

echo "" | tee -a "$log_file"
echo "=== Disk Warning Check ===" | tee -a "$log_file"
df -h | awk 'NR>1 {gsub(/%/,"",$5); if($5+0 > 80) print "WARNING: "$1" is "$5"% full"}' | tee -a "$log_file"

echo "" | tee -a "$log_file"
echo "=== Running Processes ===" | tee -a "$log_file"
echo "Total: $(ps aux | wc -l)" | tee -a "$log_file"

echo "" | tee -a "$log_file"
echo "=== Top 5 Memory Processes ===" | tee -a "$log_file"
ps aux --sort=-%mem | head -6 | tee -a "$log_file"
