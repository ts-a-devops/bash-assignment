#!/bin/bash

 date=$(date +"%b_%Y")

#CREATE log file 
 LOG_FILE="/home/eniiyi/bash-assignment/scripts/logs/system_report_${date}.log"

 #output disk usage
 echo "=======Disk usage==========" | tee -a $LOG_FILE
 df -h | tee -a $LOG_FILE

 #output memory usage
 echo "=======Memory usage========" | tee -a $LOG_FILE
 free -m | tee -a $LOG_FILE

 #output system uptime
 echo "=======System uptime=======" | tee -a $LOG_FILE
 { uptime -p; echo "${date}"; } | tee -a $LOG_FILE


# Loop through each filesystem usage percent
df -h | awk 'NR>1 {print $1, $5}'| while read fs percent; do
    usage=${percent%\%}   # strip the % sign
    
    if [[ "$usage" -gt 80 ]]; then
        echo "WARNING: $fs is at ${percent} usage!" | tee -a "$LOG_FILE"
  	else exit 0 
    fi
done

#print and count active processes
echo "=======Total running processes========"
actproc=$(ps aux | wc -l)

echo "There are ${actproc} active processes" | tee -a "$LOG_FILE" 

#sort top 5 memory consuming processes
echo "====== top 5 mem consuming processes====="
ps aux --sort=-%mem | awk '{print $1, $4}' |head -n5 | tee -a "$LOG_FILE"
