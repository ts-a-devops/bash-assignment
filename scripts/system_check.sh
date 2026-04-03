#!/usr/bin/env bash

sys_info() {
# Disk usage
echo -e "Disk Usage: "
df -h | awk 'NR > 1 && ($5 + 0) > 80 {print "Warning: " $1 " space exceeds 80%\n"}'
# Memory usage
echo -e "RAM memory usage: \n"
printf "%s\n\n" "$(free -m)"
# CPU load (uptime)
echo "System Uptime info:"; uptime

# Display top 5 memory-consuming processes
echo -e "\n\nTop 5 memory consuming processes are: "
ps aux | awk ' NR > 1 && $4 > 0.0 {print $4, $11} ' | sort -nr | head -5

# Count total running processes
echo -e "\nTotal running processes are: "; ps aux | awk ' {count++} END {print count}'

}
log_date=$(date "+%d-%m-%Y-%S")
[[ -d "logs" ]] && sys_info > logs/system_report_"($log_date)".log
[[ ! -d "logs" ]] && mkdir logs && sys_info > logs/system_report_"($log_date)".log
# # explain >&2
# how to output potential script errors into another file
# how to generate random ids for filename in bash script