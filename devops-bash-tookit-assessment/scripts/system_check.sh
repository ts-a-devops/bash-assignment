#!bin/bash/

LOG_DIR="logs"
DATE=$(date + %F)
LOG_FILE="$LOG_DIR/system_report_$DATE.log

mkdir -p $LOG_DIR

echo "System Report - $(date)" > $LOG_FILE
echo "---------------------" >> $LOG_FILE

#Disk usage
echo "Disk Usage:" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

#Warning if disk > 80%
echo "Checking disk usage...">> $LOG_FILE
df -h | awk '$5 > 8 {print "Warning: High disk usage on" $1}' | tee -a $LOG_FILE
 
#Memory usage
echo -e "\nMemory Usage:" | tee -a $LOG_FILE
free -m | tee -a $LOG_FILE

#CPU load
echo -e "\nCPU Load:"| tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

#Process count
echo -e "\nTotal Processes:" |tee -a $LOG_FILE
ps aux | wc -l | tee -a $LOG_FILE

#Top 5 memory consuming processes
echo -e "\nTop 5 Memory Consuming Processess:" | tee -a $LOG_FILE
ps aux --sort=%mem | head -n 6 | tee -a $LOG_FILE

echo "Report saved to $LOG_FILE"



