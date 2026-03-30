#!/bin/bash

process=$1
services=("nginx" "ssh" "docker")

cd logs/

if pgrep -x "$process" > /dev/null; then
    echo "$process is Running" >> process.log
else
    echo "$process is Stopped" >> process.log

    echo "Attempting restart ..." >> process.log

    echo "$process Restarted" >> process.log
fi