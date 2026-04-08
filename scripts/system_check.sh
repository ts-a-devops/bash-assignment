#!/bin/bash


##where the log files resides but first we need the date attached to it

CURRENT_DATE=$(date "+%Y-%m-%d_%H-%M-%S")

###Since we have the date now lets create a customised path


LOG_FILE="logs/system_report_$CURRENT_DATE.log"

#### Lets make the directory 

mkdir -p logs/

##### Display disk usage

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//') #df -h shows the disk usage NR==2 the second row and 5th argument = Usage . 's/%//' remove the percent
MEMORY_USAGE=$(free -m | awk 'NR==2 {printf "%sMB used of %sMB total", $3, $2}') #same thing here 
CPU_LOAD_TIME=$(uptime)
RUNNING_PROCESS=$(ps -A --no-headers | wc -l) #shows all running process , remove the headers and pipe it to count the items
CONSUMING_PROCESSES=$(ps -eo comm,%mem --sort=-%mem | sed 1d | head -n 5 | column -t) #show processes running for the name of app and memory, sort them according to memory and pipe it to top 5, arrage them vertically so it is easily read

# not really needed this was during my testing phase i wanted the ouput on the terminal 
echo " this is your disk usage table $DISK_USAGE"
echo "this is your memory usage $MEMORY_USAGE"
echo "this is your uptime $CPU_LOAD_TIME"
echo "this is amount of running process: $RUNNING_PROCESS"
echo "this is the top 5 consumeing memory: $CONSUMING_PROCESSES"

#lets cheeck the disk usage but we want to have a threshold a base line for comparison

THRESHOLD=80

if [[ "$DISK_USAGE" -ge $THRESHOLD ]]; then
    USAGE="CRITICAL"
    echo "WARNING: the disk usage is $USAGE"
elif [[ $DISK_USAGE -lt $THRESHOLD ]]; then
    USAGE="NON-CRITICAL"
    echo "the disk usage is $USAGE"
fi

### we need to put all this in the report somehow, sop lets get the output of the everything

OUTPUT="Report of your system is as follows:
Disk Usage: $DISK_USAGE% ($USAGE)
Memory Usage: $MEMORY_USAGE
CPU Load: $CPU_LOAD_TIME
Running Processes: $RUNNING_PROCESS
Top 5 Memory-Consuming Processes:
$CONSUMING_PROCESSES"

#echo the result on the terminal and append it to the log gile  part created in the begining 

echo "$OUTPUT" | tee -a "$LOG_FILE"