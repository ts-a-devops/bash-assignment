#!/bin/bash

USED=$(free -m | awk '/Mem:/ {print $3}') #to check and print the memory used
TOTAL=$(free -m | awk '/Mem:/ {print $2}') #to check and print the total memory
USEDD=$(df | awk '$NF=="/" {print $5}' | tr -d '%') #to check and print the used disk space removing the percentage
TOTALD=$(df -h | awk '$NF=="/" {print $2}') #to check and print the total disk space 
TOP5=$(ps aux --sort=-%mem | head -5 | awk '{print $1 $2 $3 $4 $11}')
CPU=$(uptime)

{
echo "Total used memory is $USED MB"
echo "Total memory is $TOTAL MB"
echo "Total used disk space is $USEDD%"
echo "Total disk is $TOTALD"
echo "Top 5 memory consuming processes:"
echo "$TOP5"
echo "$CPU"


if [ $USED -gt 85 ]
then
    echo "Warm: $USED exceeds 85"
fi

if [ $USED -gt 80 ]
then
    echo "Warn: $USEDD exceeds 80"
fi
} >> logs/system_report_$(date +%F).log
