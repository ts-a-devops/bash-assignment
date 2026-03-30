#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log"

mkdir -p "$LOG_DIR"


#prompt user for name

read -p "What is your name: " name

#prompt user for age

read -p "Enter your age: " age


#prompt user for country
read -p "what is your country: " country

#validate age
if [ $age  -eq 26 ]
then
    echo "Hello, it is nice to meet you"
fi


# Age category
if (( $age < 18 )); then
    category="Minor"
elif (( $age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

#message ouput
message="Hello, $name! You are $age years old ($category) from $country."
echo "$message"
echo "$(date): $message" >> "$LOG_FILE"
