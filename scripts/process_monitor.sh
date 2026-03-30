#!/usr/bin/env bash

mkdir -p logs

services=("nginx" "ssh" "docker")

for service in "${services[@]}"; do
if pgrep "$service" > /dev/null; then
echo "$service is running" | tee -a logs/process.log
else
echo "$service is stopped - restarting..." | tee -a logs/process.log
fi
done