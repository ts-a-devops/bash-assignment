#!/bin/bash

#make sure the logs folder exists
mkdir -p logs 

#build today's date
today=$(date +%Y-%m-%d)
log_file="logs/system_report_$today.log"

exec > >(tee -a "$log_file") 2>&1

#start report (creates/overwrites the file with this first line)
echo "System Report for $today"  
echo "" 

#disk usage
echo  "--- Disk Usage ---" 
df -h 
echo "" 

#warning if disk is over 80&
disk_usage=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')
if (( "$disk_usage" > 80 )); then
   echo "WARNING: Disk Usage is above 80%! ("$disk_usage"%)"
   echo ""
fi

#memory usage
echo "--- Memory Usage ---"
free -m
echo ""

#memory usage
echo "--- CPU Uptime ---"
uptime
echo ""

#total running processes
echo "--- Total Running Proccess ---"
process_count=$(ps aux | wc -l)
echo "--- Total Running Processes: $process_count ---"
echo ""

#top 5 memory consuming proccesses
echo "--- Top 5 Memory-Consuming Processes ---"
ps aux --sort=-%mem | head -n 6
echo ""

echo "Report saved to $log_file"
