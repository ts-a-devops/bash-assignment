#!/bin/bash
mkdir -p ./logs

echo "====== DISK USAGE ======"
df / -h


echo ""

echo "====== MEMORY USAGE ======"
free -m

echo ""

echo "====== CPU LOAD ======"
uptime

echo ""

usage="$(df / | tail -1 | awk '{print $5}' | sed 's/%//')"

threshold=80

if [[ "$usage" -gt "$threshold" ]] 
then
	echo "Warning!!! Disk usage exceeds 80%" | tee -a  ./logs/system_report_"$(date +%Y-%m-%d)".log
else
	echo "Disk usage is less than 80%" | tee  -a ./logs/system_report_"$(date +%Y-%m-%d)".log
fi

runpro="$(ps -e --no-headers | wc -l)"
echo "$runpro process(es) running"
echo ""
echo "=== TOP 5 MEMORY CONSUMING PROCESSES ==="
ps aux --sort=%mem | head -n 6

