#!/bin/bash


# Ask and validate for name and country
read -p "What is your name?: " name
read -p "What country are you from?: " country
if [[ -z "$name" || -z "$country" ]]; then
    echo "Name or country cannot be empty"
    exit 1
fi



#Ask and validate for age
read -p "What is your age?: " age
if [[ -z "$age" ]]; then
    echo "Age input cannot be empty"
elif [[ ! "$age" =~ ^[1-9][0-9]*$ ]] then
    echo "Invalid input. Ensure the number is a decimal and above 0."
fi



category=""
minor=17
adult=65

# Logic for categorizing age
if [[ "$age" -le "$minor" && "$age" -gt 0 ]]; then
    category="Minor"
elif [[ "$age" -gt "$minor" && "$age" -lt "$adult" ]]; then
    category="Adult"
elif [[ "$age" -ge "$adult" ]]; then
    category="Senior"
fi


greeting="Hello ${name}! You are ${age} years old from ${country}. You are categorized as a/an ${category}."

echo "$greeting"
echo "${greeting}" >> ../logs/user_info.log
