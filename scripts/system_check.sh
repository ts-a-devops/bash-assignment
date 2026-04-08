#!/bin/bash

 date=$(date +"%b_%Y")

#CREATE log dir
LOG_DIR="/home/eniiyi/bash-assignment/scripts/logs/system_log"
mkdir -p "$LOG_DIR"

logs="$LOG_DIR/system_report_${date}.log"

 #output disk usage
 echo "=======Disk usage==========" | tee -a "$logs"
 df -h | tee -a "$logs"

 #output memory usage
 echo "=======Memory usage========" | tee -a "$logs"
 free -m | tee -a "$logs"

 #output system uptime
 echo "=======System uptime=======" | tee -a "$logs"
 { uptime -p; echo "${date}"; } | tee -a "$logs"


# Loop through each filesystem usage percent
df -h | awk 'NR>1 {print $1, $5}'| while read fs percent; do
    usage=${percent%\%}   # strip the % sign
    
    if [[ "$usage" -gt 80 ]]; then
        echo "WARNING: $fs is at ${percent} usage!" | tee -a "$logs"
  	else exit 0 
    fi
done

#print and count active processes
echo "=======Total running processes========"
actproc=$(ps aux | wc -l)

echo "There are ${actproc} active processes" | tee -a "$logs" 

#sort top 5 memory consuming processes
echo "====== top 5 mem consuming process====="
ps aux --sort=-%mem | awk '{print $1, $4}' |head -n5 | tee -a "$logs"
