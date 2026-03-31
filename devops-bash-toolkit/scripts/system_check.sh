#!/bin/bash
logfile="../logs/system_report_$(date +%F).log"

echo "System_check $(date)" > "$logfile"

df -h > "$logfile"
free -m > "$logfile"
uptime > "$logfile"

usage=$(df / | awk 'NR==2 {print $5}' | sed "s/%//" )

if [[ "$usage" -gt 80 ]]; then
    echo "Warning!!! Disk usage is more than 80%" > "$logfile"
fi
#Total Processes
echo "Total processes: $(ps aux |wc -l)" > "$logfile"
# Top 5 memory processes
echo "Top 5 memory processes:" >> "$logfile"
ps aux --sort=-%mem | head -n 6 >> "$logfile"





