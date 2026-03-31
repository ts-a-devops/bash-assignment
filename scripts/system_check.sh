#!/bin/bash

# Display usage
echo "Disk Usage"
df -h

echo ""
echo ""

# Memory usage
echo "Memory Usage"
free -m

echo ""
echo ""

# CPU load
echo "CPU load"
uptime

echo ""
echo ""

# Manipulate disk usage output
# The 5th column & 2nd row contains the usage percentage
# Remove the last character
usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/.$//')

# If usage above 80 then display warning
# Send warning to log file
if [[ $usage -gt 80 ]]; then
   echo "Usage over 80%!" >> logs/system_report_march_29.log
fi

echo ""
echo ""


# Count number of running processes
total_proc=$(ps aux | wc -l)

echo "Total numbers of processes: $total_proc"

echo ""
echo ""

# Determine top 5 processes
echo "Your top 5 processes"
ps aux | awk '{print $1, $4, $11}' | sort -k2 -nr | head -n 5
