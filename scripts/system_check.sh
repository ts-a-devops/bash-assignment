#!/bin/bash

#this script is used for checking system reports
# | tee -a represents >> vice versa
# | tee -a sends output to the screen and the file.log but >> doesn't


#generating time stamp

DATE=$(date +"%Y")
LOG_FILE="../logs/system_report_$DATE.log"

#starting system check
echo "=====     SYSTEM REPORT          ====" | tee -a "$LOG_FILE"
echo "        Generated on: $(date)      "             
echo "====================================" 


#for disk usage
echo "====      Disk Usage           ====" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"

#for Memory Usage
echo "====      Memory Usage          ===" | tee -a "$LOG_FILE"
free -m | tee -a "$LOG_FILE"
  

#for CPU Load
echo "====      CPU LOAD (uptime)    ====" | tee -a "$LOG_FILE"
uptime | tee -a "$LOG_FILE"   

#for disk Usage Warning (exceeding 80%)
#get disk usage percentage

echo "====       Disk Usage         ====" | tee -a "$LOG_FILE"

DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "⚠️  WARNING: disk usage is above 80%!" | tee -a "$LOG_FILE"
    echo "   Consider cleaning up space or expanding storage." 

elif [ "$DISK_USAGE" -ge 70 ]; then
    echo "⚠️  NOTICE: Disk usage is getting high (${DISK_USAGE}%)" 

else
    echo "disk usage is normal." | tee -a "$LOG_FILE"
fi

#for total Running Processes
#ps refers to process status
#a shows all users
#u refers to user oriented format
#x shows processes that don't have a controling terminal(background processes,daemons,etc)

TOTAL_PROCESSES=$(ps aux | wc -l)
echo "====      TOTAL RUNNING PROCESSES     ====" | tee -a "$LOG_FILE"
echo
echo "Total processes: $TOTAL_PROCESSES" | tee -a "$LOG_FILE"


#To display top 5 Memory-Consuming Processes

echo "==== TOP 5 MEMORY-CONSUMING PROCESSES ====" | tee -a "$LOG_FILE"

#echo "PID    %MEM   RSS(MB)   COMMAND"            | tee -a "$LOG_FILE"

# ps aux --sort="-%mem | head -n 6 | tail -n 5 | awk '{printf "%-6s %-5s %-8.1f  %s\n", $2 $4, $6/1024, substr($0, index($0,$11))}' " >> "$LOGFILE"

# the | awk '{printf "%-6s %-5s %-8.1f  %s\n", $2, $4, $6/1024, substr($0, index($0,$11))}'
#This is the most complex part. It formats the output nicely.Awk explanation:
#$2 → PID (2nd column)
#$4 → %MEM (4th column)
#$6 → RSS (memory in KB) → we divide by 1024 to convert to MB
#substr($0, index($0,$11)) → Takes the full command name (everything starting from the 11th column onward). 
#This is needed because command names can have spaces.
#printf formats it neatly:
# %-6s → PID left-aligned, 6 characters wide
# %-5s → %MEM left-aligned, 5 characters wide
# %-8.1f → RSS in MB, with 1 decimal place
# %s → The command name
 
# Better and cleaner way
ps aux --sort=-%mem | head -n 6 | tail -n 5 | awk '{
    pid= $2
    pmem= $4
    rss_mb= $6 / 1024
    # Get command: everything from 11th field onward
    cmd = ""
    for(i=11; i<=NF; i++) {
        cmd = cmd $i " "
    }
    printf "%-7s %-6s %8.1f   %s\n", pid, pmem, rss_mb, cmd
}'| tee -a "$LOG_FILE"



echo
#to print our script
echo "==================================================="
echo "              system check complete                " 
echo "===================================================" | tee -a $LOG_FILE 

echo "System check completed. Report saved to $LOG_FILE"





















