#!/bin/bash

#This is where all logs will be stored
LOG_DIR="logs"

#Get current date and time (used to create unique log file)
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

#Full path to the log file
LOG_FILE="$LOG_DIR/system_report_$DATE.log"

#Make the logs folder if it doesn't already exist
mkdir -p "$LOG_DIR"

#Print title of report (tee shows it and saves it to file)
echo "==== SYSTEM CHECK REPORT ($DATE) ====" | tee -a "$LOG_FILE"

#DISK USAGE

#Print section title
echo -e "\n--- Disk Usage ---" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

#-----------
#DISK WARNING (>80%)
#-----------

USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

if [[ "$USAGE" -gt 0 ]]; then
	echo "WARNING: Disk usage is ${USAGE}%" | tee -a "$LOG_FILE"
fi

#MEMORY USAGE
echo -e "\n--- Memory Usage ---" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"

#CPU LOAD
echo -e "\n--- Memory Usage ---" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"

#TOTAL RUNNING PROCESSES
echo -e "\n--- Total Running Processes ---" | tee -a "$LOG_FILE"
echo "$(ps aux | wc -l)" | tee -a "$LOG_FILE"

#TOP 5 MEMORY-CONSUMING PROCESSES
echo -e "\n ---Top 5 Memory Consuming Processes" | tee -a "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"

echo -e "\n--- End of Report ---" | tee -a "$LOG_FILE"
