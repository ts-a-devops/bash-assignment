#!/bin/bash

#Directory where logs are stored
Log_File="logs/system_report_$(date +%F_%H-%M-%S).log"

#Command to check disk usage
DISK_USAGE=$(df -h)

#Command to store output in the logs file
echo "Disk Usage: $DISK_USAGE" | tee -a  "$Log_File"
echo "" | tee -a "$Log_File"


#Command to check memory usage
MEMORY_USAGE=$(free -m)

#Command to store output of the memory usage in the logs file
echo "Memory Usage: $MEMORY_USAGE" | tee -a  "$Log_File"
echo "" | tee -a "$Log_File"


#Command to extract the memory usage percentage
USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
echo "" | tee -a "$Log_File"

#Command to store check whether memory usage is exceeding 80% and store it in the logs file
if [[ "$USAGE" -gt 80 ]]; then
    echo "Warning Disk Usage is exceeding ${USAGE}%" | tee -a  "$Log_File"
fi
echo "" | tee -a "$Log_File"


#Command to check total running processes
TOTAL_PROCESSES=$(ps -A --no-headers | wc -l)
echo "" | tee -a "$Log_File"


#Command to store the total number of running processes in the logs file
echo "Total running processes: $TOTAL_PROCESSES" | tee -a "$Log_File"
echo "" | tee -a "$Log_File"

#Command to check the top 5 memory processes
TOP_5_MEMORY_CONSUMING_PROCESSES=$(ps aux --sort=-%mem | head -n 6 | cut -c 1-120)

#Command to store the top 5 memory-consuming processes in the logs file
echo "Top 5 Memory-Consuming Processes: $TOP_5_MEMORY_CONSUMING_PROCESSES" | tee -a "$Log_File"

