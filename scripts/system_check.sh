 #!/bin/bash

 LOG_DIR="../logs"
 mkdir -p "$LOG_DIR"

 DATE=$(date +"%Y-%m-%d_%H-%M-%S")
 LOG_FILE="$LOG_DIR/system_report_$DATE.log"

 echo "System Report - $DATE" | tee -a "$LOG_FILE"

 echo -e "\nDisk Usage:" | tee -a "$LOG_FILE"
 df -h | tee -a "$LOG_FILE"

 # Warning if disk > 80%
 df -h | awk 'NR>1 {print $5 " " $1}' | while read output;
 do
	usage=$(echo $output | awk '{print $1}' | sed 's/%//g')
	partition=$(echo $output | awk '{print $2'})
	if [ $usage -ge 80 ]; then
		echo "WARNING: $partition is ${usage}% full" | tee -a "$LOG_FILE"
	fi
 done

 echo -e "\nMemory Usage:" | tee -a "$LOG_FILE"
 free -m | tee -a "$LOG_FILE"

 echo -e "\nCPU Load:" | tee -a "$LOG_FILE"
 uptime | tee -a "$LOG_FILE"

 echo -e "\nTotal Processes:" tee -a "$LOG_FILE"
 ps aux | wc -l | tee -a "$LOG_FILE"

 echo -e "\nTop 5 Memory Consuming Processes:" | tee -a "$LOG_FILE"
 ps aux --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"


