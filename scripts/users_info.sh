#!/bin/bash
# Prompt for info
read -p "Enter Name: " name
read -p "Enter Age: " age
read -p "Enter Country: " country

# Validate Age is numeric
if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number."
    exit 1
fi

# Determine category
if [ "$age" -lt 18 ]; then cat="Minor"; elif [ "$age" -le 65 ]; then cat="Adult"; else cat="Senior"; fi

# Output and Log
echo "Hello $name from $country. Category: $cat" | tee -a ../logs/user_info.log
