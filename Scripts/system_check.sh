#!/bin/bash

df -h | head -4; echo; free -m; echo; uptime

disk=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
[ $disk -gt 80 ] && echo -e "\n⚠️  WARNING: Disk ${disk}% > 80%"