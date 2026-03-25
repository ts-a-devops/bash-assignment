#!/bin/bash

# Prompt the user for: Name, Age, Country
# Validate: Age must be numeric
# Output: A greeting message
# Age category: Minor (<18), Adult (18–65), Senior (65+)

echo "==================================="
echo "Running Script"
echo "==================================="


# check and ccreate logs 
if [ -d "../logs" ]; then
        cd "../logs"
else
	mkdir -p "../logs"
fi
 
timestamp="$USER:$(date '+%Y-%m-%d %H:%M:%S')"

# get the name 
echo "What is your name? "
read name

# get the age
echo "How old are you? "
read age

# get country
echo "What is your country? "
read country
 
# validate name
if [[ -z $name ]]; then
	echo "Name cannot be blank."
	read -p "Enter your name: " name
fi
 
# validate age
if [[ ! $age =~ ^[0-9]+$ ]]; then
        echo "Age should be a number."
	read -p "Enter your age: " age
fi
 
# classify age and give output
if [[ $age -lt 18 ]]; then
        echo -e "$timestamp Hello $name from $country, you are $age years old and a Minor. \nHave a lovely day." >> ../logs/user_info.log
elif [[ $age -gt 17 && $age -lt 65 ]]; then
        echo -e "$timestamp Hello $name from $country, you are $age years old and a Adult. \nHave a lovely day." >> ../logs/user_info.log
else
        echo -e "$timestamp Hello $name from $country, you are $age years old and a Senior. \nHave a lovely day." >> ../logs/user_info.log
fi
 
 
echo "==================================="
echo "Script completed successsfully"
echo "cat user_info.log to view the result"
echo "go back to scripts/ to run the other script"
echo "Valar Mogulis"
echo "==================================="

