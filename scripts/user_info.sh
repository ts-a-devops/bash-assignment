#!/bin/bash

LOG_FILE="logs/user_info.log"

# Ensure logs directory exists
mkdir -p logs

# Function to log messages
log_message() {
	    echo "$1" >> "$LOG_FILE"
    }

    # Prompt for Name
    read -p "Enter your name: " NAME
    if [[ -z "$NAME" ]]; then
	        echo "Name cannot be empty."
		    log_message "ERROR: Name was empty"
		        exit 1
    fi

    # Prompt for Age
    read -p "Enter your age: " AGE

    # Validate Age (must be numeric)
    if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
	        echo "Invalid age. Please enter a numeric value."
		    log_message "ERROR: Invalid age input ($AGE)"
		        exit 1
    fi

    # Prompt for Country
    read -p "Enter your country: " COUNTRY
    if [[ -z "$COUNTRY" ]]; then
	        echo "Country cannot be empty."
		    log_message "ERROR: Country was empty"
		        exit 1
    fi

    # Determine Age Category
    if (( AGE < 18 )); then
	        CATEGORY="Minor"
	elif (( AGE <= 65 )); then
		    CATEGORY="Adult"
	    else
		        CATEGORY="Senior"
    fi

    # Greeting Message
    MESSAGE="Hello $NAME from $COUNTRY! You are classified as an $CATEGORY."

    echo "$MESSAGE"

    # Save to log
    log_message "$(date '+%Y-%m-%d %H:%M:%S') - $MESSAGE"
