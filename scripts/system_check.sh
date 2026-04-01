#!/bin/bash

date=$(date +%d-%m-%y)

# log files
LOG_FILE="logs/system_report_$date.log"

echo "==== SYSTEM REPORT FOR $date ====" | tee -a $LOG_FILE

# Disk usuage 
echo "==== Disk Usuage ====" | tee -a $LOG_FILE

df -h | tee -a $LOG_FILE

# Memory usuage 
echo "==== Memory usuage ====" | tee -a $LOG_FILE

free -m |  tee -a $LOG_FILE

# CPU load 
echo "==== CPU load ===="| tee -a $LOG_FILE

uptime |  tee -a $LOG_FILE

# Warming if disk exceed 80%
echo "---- Disk Warning ----" | tee -a $LOG_FILE
df -h | awk 'NR>1 {print $5 " " $6}' | while read usage mount
do
	    percent=${usage%\%}
	        if [ "$percent" -gt 80 ]; then
			        echo "WARNING: Disk usage on $mount is $usage" | tee -a $LOG_FILE
				    fi
			    done

# Running Process
echo "---- Total Processes ----" | tee -a $LOG_FILE
ps aux | wc -l | tee -a $LOG_FILE

# 5 memory-consuming processes
echo "---- Top 5 Memory Processes ----" | tee -a $LOG_FILE
ps aux --sort=-%mem | head -n 6 | tee -a $LOG_FILE

echo "===== END OF REPORT =====" | tee -a $LOG_FILE


