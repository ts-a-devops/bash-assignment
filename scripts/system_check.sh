#!/usr/bin/env bash

mkdir -p logs

echo "System Report - $(date)" > logs/system_report_$(date +%F).log

df -h >> logs/system_report_$(date +%F).log
free -m >> logs/system_report_$(date +%F).log
uptime >> logs/system_report_$(date +%F).log

ps aux --sort=-%mem | head -n 6 >> logs/system_report_$(date +%F).log

echo "Total processes: $(ps aux | wc -l)" >> logs/system_report_$(date +%F).log