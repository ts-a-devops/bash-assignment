#!/bin/bash
set -euo pipefail
services=("nginx" "ssh" "docker")

for svc in "${services[@]}"; do
    if pgrep -x "$svc" > /dev/null; then
        echo "$svc: Running"
    else
        echo "$svc: Stopped. Attempting restart..."
        # sudo systemctl restart "$svc" # Simulated
        echo "$svc: Restarted (Simulated)"
    fi
done >> logs/monitor.log
