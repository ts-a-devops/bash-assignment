#!/bin/bash
#Disk usage
echo "Disk usage:"
df -h
#Memory usage
echo "Memory Usage:"
free -m
#CPU load
echo "CPU load:"
uptime

#Warn if disk usage exceeds 80

read -p "Enter device disk usage: " diskusage

if [[ $diskusage -gt 80 ]]; then
	echo " Warning!!, Disk usage exceeds recommended value"
fi

#count total running processes
echo "The count of total running processes:"
ps aux| wc -l

