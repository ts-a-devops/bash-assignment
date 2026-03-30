#!/bin/bash 

LOG_FILE="..logs/user_info.log"

#Collect input
read -p "Enter your name:" name
read -p "Enter your age:" age
read -p "Enter your country:" country

#Check if any field is empty
if [[ -z "$name" || -z "$age"  || -z "$country" ]]; then
	echo "All fields are required." | tee -a "LOG_FILE"
	exit 1
fi

#Validate age (must be number)
if ! [[ "$age" =~ ^[0-9]+$ ]]; then 
	echo "Age must be a number." | tee -a "LOG_FILE"
	exit 1
fi

#Determine age category
if (( age < 18 )); then
	category="Minor"
elif (( age <= 65 )); then
	category="Adult"
else
	category="Senior"
fi

#Output message
message="Hello $name from $country. You are an $category."

#Save to log
echo "$message" | tee -a "LOG_FILE"

