#!/bin/bash
# User information requirement script
# prompt the user for name, age, and country.

# Save output to logs/user_info.log

while true; do
    echo "Hello, please enter your name, age, country:"
    read name age country

# Redirect stdout and stderr to user_info.log
exec > logs/user_info.log 2>&1

# Verify strings are not empty and age is numeric.
    if [[ -n "$name" ]] && [[ -n "$age" ]] && [[ -n "$country" ]] && [[ "$age" =~ ^[0-9]+$ ]]; then
	# Age is numeric. Continue with the script.
        if [[ "$age" -lt 18 ]]; then
	 # echo a greeting message to user.
            echo "Welcome, $name! You are $age years old--a minor, and from $country."
        elif [[ "$age" -ge 18 ]]; then
	    echo "Welcome, $name! You are $age years old--an adult, and from $country." 
        else
	    echo "Welcome, $name! You are over $age years old--a senior, and from $country."
	    break
        fi
        break
    else
        echo "Age must be a numeric value."
    fi
done

