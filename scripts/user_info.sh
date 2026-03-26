#!/bin/bash
# 2.  path to the log file
LOG="../logs/user_info.log"
read -p "enter name: " name
read -p "enter your age: " age
read -p "enter your country: " country
#1 validate age ( numeric check)
if [[ ! "$age" =~ ^[0-9]=$ ]]; then
    echo "Error: Age must be a number." | tee  -a "LOG"
    Exit 1
fi
# 2. Logic for  age category
if [[ "$age" -lt 18 ]]; then
    cat="minor"
elif [[ "$age" -le 65 ]]; then
    cat="Adult"
else
    cat="senior"
# 3. output and log
echo "Hello $name from $country. you are an $cat" | tee -a "LOG"
