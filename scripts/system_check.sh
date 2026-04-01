#!/usr/bin/bash

	#Creating a log file

mkdir -p logs
log_file="logs/system_report_$(date +%F_%H-%M-%S).log"

	#Display Output
{
echo
echo "----- DISK USAGE -----"
df -h

	#Warn if disk usage is above 80%
#--------------------------------------------------------------------------
while read -r percent mountpoint; do
    usage="${percent%\%}"

    if (( usage > 80 )); then
        echo "WARNING: $mountpoint is at ${usage}% disk usage."
     else
	echo "$mountpoint is okay at ${usage}%."
    fi
done < <(df -hP | awk 'NR>1 {print $5, $6}')
#--------------------------------------------------------------------------
	#Memory Usage
echo
echo "----- MEMORY USAGE -----"
free -m

	#CPU Load
echo
echo "----- CPU LOAD -----"
uptime

	#Total Running Processes
echo
echo "----- TOTAL RUNNING PROCESSES -----"
	process_count=$(ps -e --no-headers | wc -l)
echo "Total running processes: $process_count"

	#The top 5 memory consuming processes
echo
echo "----- TOP 5 MEMORY-CONSUMING PROCESSES -----"
ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6
} | tee -a "$log_file"
