#/bin/bash

{
# Display disk usage
echo "------------------------------------------------------------Disk Usage---------------------------------------------------------------"
df -h

# Display memory usage
echo "------------------------------------------------------------Memory Usage-------------------------------------------------------------"
free -m

# Display CPU load
echo "------------------------------------------------------------CPU load ----------------------------------------------------------------"
uptime

high_usage=$(df --output=pcent | tr -dc '0-9\n' | sort -n | tail -1)
total_running_processes=$(ps -e | wc -l)

#  Check if disk usage is greater than 80 percent
if [[ $high_usage -gt 80 ]]; then
	echo "WARNING: DISK USGE IS EXCEEDS 80%"
fi

echo ""
echo "There are a total of $total_running_processes running processes."
echo ""

echo "----------------------------------------------------------Top 5 Memory Consuming Processes--------------------------------------------"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -6

} | tee logs/system_report_$(date +%F).log

