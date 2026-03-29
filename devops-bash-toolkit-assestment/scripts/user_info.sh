#!/bin/bash

#This script ask user for details, validates them, and prints a messaage

LOG_FILE="../logs/user_info.log"

echo "Enter your name:"
read name

echo "Enter your age:"
read age

echo "Enter your country:"
read country

#Validate inputs

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required."
        exit 1
        fi

        if ! [[ "$age" =~ ^[0-9]+$ ]]; then
            echo "Error: Age must be a number."
                exit 1
                fi

                # Determine age category
                if (( age < 18 )); then
                    category="Minor"
                    elif (( age <= 65 )); then
                        category="Adult"
                        else
                            category="Senior"
                            fi

                            # Output message
                            message="Hello $name from $country! You are an $category."

                            echo "$message"

                            # Save to log
                            echo "$(date): $message" >> "$LOG_FILE"

