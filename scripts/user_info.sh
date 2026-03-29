#!/bin/bash
#User prompts
read -p "Enter your name: " Name 
echo "Hello!,$Name"

read -p "How old are you?: " Age

 #Validating the age 
if [[ ! "$Age" =~ [0-9]+$ ]]; then
	echo "Error! Age must be a number"
else 
	echo "You are $Age years old"
fi

#Age category
if [[ "$Age" -lt 18 ]]; then
	echo "Minor"
elif [[ "$Age" -gt 18 ]]; then
	echo "Adult"
else [[ "$Age" -ge 65 ]] 
	echo "Senior"
fi

# User prompts for country
read -p "Where is your home country?:" Country
echo "You are from $Country"
