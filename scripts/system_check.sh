#!/bin/bash

# Display: Disk usage (df -h), Memory usage (free -m), CPU load (uptime)
# Warn if disk usage exceeds 80%
# Count total running processes
# Display top 5 memory-consuming processes


echo "==================================="
echo "Running Script"
echo "==================================="


# check and ccreate logs 
if [ -d "../logs" ]; then
        cd "../logs"
else
	mkdir -p "../logs"
fi
 

timestamp="$USER:$(date '+%Y-%m-%d %H:%M:%S')"
date="$(date '+%Y-%m-%d')"

echo -e "Logging $USER session at $date \n" >> ../logs/system_report_$date.log

# log the disk usage
echo -e "Disk usage: \n" >> ../logs/system_report_$date.log
df -h >> ../logs/system_report_$date.log

#log the memory
echo -e "Memory usage: \n" >> ../logs/system_report_$date.log
free -m >> ../logs/system_report_$date.log

# CPU load
usage="$(df -h | grep '/dev/sda' | awk '{print $5}' | tr -d '%')"
echo -e "CPU load: \n" >> ../logs/system_report_$date.log

if [[ $usage -gt 80 ]]; then
	echo -e "WARNING!!! \nDisk usage ($usage%) exceeds 80%. \nAttach additional storage." >> ../logs/system_report_$date.log
fi

# Total running Processes
echo -e "Total Running Processes: " >> ../logs/system_report_$date.log
ps aux | wc -l >> ../logs/system_report_$date.log

# Top 5 Memeory
echo -e "Top 5 memory-consuming processes: " >> ../logs/system_report_$date.log
ps aux --sort=-%mem | head -n 6  >> ../logs/system_report_$date.log


sleep 2

echo "==================================="
echo "Script completed successsfully"
echo "cat system_report_$date.log to view the result"
echo "go back to scripts/ to run the other script"
echo "Valar Mogulis"
echo "==================================="

