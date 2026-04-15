#!/bin/bash

# Task 1: Collecting dats
read -p "Emter your full name" name
read -p "Enter your age" age 
read -p "Enter your country" coumtry

# Task 2: Validation and classification of age 
if [[ ! "$age" =~ [0-9]+$ ]]; then
	echo "Error: Age must be a number"
	exit 1
fi

if [[ "$age" -lt 18 ]]; then
	category="Minor"
elif [[ "$age" -le 65 ]]; then
	category="Adult"
else category="Senior"

fi

# Task 4: Output
echo "Hello $name from $country. you are classified as: $category."

# Task 5:
# save this to a log file automatically
echo "($date): $name ($category) from $country" >> logs/user_info.log"
