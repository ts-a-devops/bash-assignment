 #!/bin/bash
 
 mkdir -p logs
 DATE=$(date +"%Y-%m-%d_%H-%M-%S")
 LOG_FILE="logs/system_report_${DATE}.log"


 
  { echo "========== SYSTEM CHECK REPORT =========="
   echo "Generated at: $(date)"
   echo


   echo "----- Disk Usage -----"
   df -h
   echo


   echo "----- Memory Usage -----"
   free -m
   echo


   echo "----- CPU Load -----"
   uptime
   echo


   echo "----- Disk Usage Warnings (>80%) -----"
   df -hp | awk 'nR>1 {gsub("%',"",$5); if ($5> 80) print
   "WARNING: " $6 " is at " $5 " % usage"}'
   echo

   echo "----- Total Running Processes -----"
   ps -e --no-headers | wc -l
   echo


   echo "----- Top 5 Memory-Consuming Processes -----"
   ps -eo pid,comm,%mem --sort=-%mem | head -n 6
   echo
   "===========================================" } | tee "$LOG_FILE"
