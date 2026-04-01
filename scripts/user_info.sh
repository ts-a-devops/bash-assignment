#!/bin/bash

LOG_FILE="logs/user_info.log"
mkdir -p logs

# creating input functions
get_input() {
        prompt=$1
        var_name=$2
        while true
        do
           read -p "$prompt" input
           if [[ -n "$input" ]]; then
                eval "$var_name=\"$input\""
                break
           fi
           echo "Input cannot be empty. Please try again"
        done
}

get_input "Enter your name: " name
get_input "Enter your age: " age

# checking numeric for age
while ! [[ "$age" =~ ^[0-9]+$ ]]; do
        echo "Age must be a number."
        get_input "Enter your age: " age
done

get_input "Enter your country: " country
[[ $age -lt 18 ]] && cat="minor" || { [[ $age -lt 65 ]] && cat="Adult" || cat="Senior"; }

msg="Hello $name from $country! You are $age years old ($cat)"
echo "-------------------------------------------------"
echo "$msg"
echo "$(date '+%Y-%m-%d %H:%M:%S'): %msg" >> "$LOG_FILE"
echo "-------------------------------------------------"
