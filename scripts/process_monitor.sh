#!/bin/bash

services=("nginx" "ssh" "docker")

for service in "${services[@]}"
do
    if pgrep "$service" > /dev/null
    then
        echo "$service is running"
    else
        echo "$service is NOT running"
        echo "Attempting restart..."
        sudo systemctl start "$service"
    fi
done
