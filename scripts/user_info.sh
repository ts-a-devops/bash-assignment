#!/bin/bash
set -euo pipefail
read -p "Name: " name
read -p "Age: " age
read -p "Country: " country
if [[ ! "$age" =~ ^[0-9]+$ ]]; then echo "Age must be a number"; exit 1; fi
if [ "$age" -lt 18 ]; then cat="Minor"; elif [ "$age" -le 65 ]; then cat="Adult"; else cat="Senior"; fi
msg="Hello $name from $country. Category: $cat"
echo "$msg"
echo "$(date): $msg" >> logs/user_info.log
