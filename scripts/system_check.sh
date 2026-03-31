#!/bin/bash

# Exit on error
set -e

# Ensure logs directory exists
mkdir -p ../logs

# Log file with date
LOG_FILE="../logs/system_report_$(date +%F).log"

echo "===== System Health Check ====="

# Disk Usage
echo "---- Disk Usage ----"
df -h | tee -a "$LOG_FILE"

# Check for disk usage > 80%
echo -e "\n---- Disk Usage Warnings ----" | tee -a "$LOG_FILE"
df -h | awk 'NR>1 {print $5 " " $1}' | while read output;
do
	    usage=$(echo $output | awk '{print $1}' | sed 's/%//')
	        partition=$(echo $output | awk '{print $2}')

		    if [ "$usage" -gt 80 ]; then
			            echo "WARNING: $partition is at ${usage}% usage" | tee -a "$LOG_FILE"
				        fi
				done

				# Memory Usage
				echo -e "\n---- Memory Usage ----" | tee -a "$LOG_FILE"
				free -m | tee -a "$LOG_FILE"

				# CPU Load
				echo -e "\n---- CPU Load ----" | tee -a "$LOG_FILE"
				uptime | tee -a "$LOG_FILE"

				# Total running processes
				echo -e "\n---- Process Count ----" | tee -a "$LOG_FILE"
				ps aux | wc -l | awk '{print "Total running processes: " $1}' | tee -a "$LOG_FILE"

				# Top 5 memory-consuming processes
				echo -e "\n---- Top 5 Memory Consuming Processes ----" | tee -a "$LOG_FILE"
				ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

				echo -e "\nSystem check complete. Report saved to $LOG_FILE"
