#!/bin/bash

# Creating logs folder
mkdir -p logs

# Log File Path
LogFile="logs/user_info.log"

# Get and Validate User Input

while true; do
	read -p "Enter your name: " name 
	read -p "Enter your age: " age	
	read -p "Enter your country: " country


	if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
		echo "All fields are required. Please try again."
	else
		break
	fi
done

#Validate Age

while true; do
	if ! [[ "$age" =~ ^[0-9]+$ ]]; then
		read -p "Invalid age. Enter a number: " age
	else
		break
	fi
done

# Categorize Ages

if [ "$age" -lt 18 ]; then
	category="Minor"
elif [ "$age" -le 65 ]; then
	category="Adult"
else
	category="Senior"
fi

# Greeting Message
message="Hi $name from $country! You are $age years old so that makes you $category. Welcome!"

#Output
echo "$message" | tee -a "$LogFile"
