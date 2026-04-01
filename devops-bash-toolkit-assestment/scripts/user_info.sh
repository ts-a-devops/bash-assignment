#!/bin/bash
set -euo pipefail
LOG_FILE="logs/user_info.log"

read -p "Enter Name: " name
read -p "Enter Age: " age
read -p "Enter Country: " country

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required." | tee -a "$LOG_FILE"
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number." | tee -a "$LOG_FILE"
    exit 1
fi

if [ "$age" -lt 18 ]; then cat="Minor"; elif [ "$age" -le 65 ]; then cat="Adult"; else cat="Senior"; fi

msg="Greeting $name from $country! Category: $cat"
echo "$msg" | tee -a "$LOG_FILE"
