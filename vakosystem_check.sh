#!/bin/bash
 
mkdir -p logs
REPORTS="logs/mysystem_report_$(date +%F).log"
 
{
 
#Commands to check disk usage
echo "The following are the disk usage"
df -h
 
#Commands to memory usage
echo "The following are the memory usage"
free -m
 
#Commands to check Cpu load
echo "The following are the cpu load"
uptime
 
#Commands to check process count again
echo "The following are the list process"
ps -aux
 
#Commands to check process count again
echo "The following are the process verification count"
ps -aux | wc -l
 
#Commands to check top 5 processes running
echo "The following are the 5 processes"
ps -aux --sort=-%mem | head -6
 
#Commands to give warning when CPU exceeds 80%
df -h | grep "8[0-9]% | 9[0-9]% | 100%" && echo "Usage is over 80%"  
} | tee -a "$REPORTS"
