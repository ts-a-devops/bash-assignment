#!/bin/bash

#Check for disk usaage
echo "____DISK USAGE____"
df -h

#Give a warning if disk usage is above 80
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
if [[ $disk_usage -ge 80 ]]; then
    echo "DISK USAGE IS ABOVE 80%"
fi

#Check for memory usage
echo "____MEMORY USAGE____"
free -m

#Check CPU load
echo "____CPU LOAD____"
uptime

#Count total running processes
echo "____TOTAL NUMBER OF PROCESSES____"
ps aux --no-header | wc -l

#Display top 5 ruuning processes
echo "____TOP 5 MEMORY CONSUMING PROCESSES____"
ps aux --sort=-%mem | head -n 6

