#!/bin/bash

set -euo pipefail
mkdir -p logs

while true; do
	
	read -p "What is your name:" NAME
		

	if [[ -z "$NAME" ]]; then
		echo "Name cannot be empty, please enter your name"
	else
		break
	fi
done

#Validating that age is a whole number

while true; do

       	read -p "How old are you?: " AGE
  
   if [[ "$AGE" =~ ^[0-9]+$ ]]; then
      break

   else
      echo "Invalid input. Age must be a whole number please try again."
   fi

done  

#Assigning a category to the ages

if [ "$AGE" -lt 18 ]; then
    age_category="Minor"
elif [ "$AGE" -le 65 ]; then
    age_category="Adult"
else
    age_category="Senior"
fi

while true; do

	read -p "Whats your country of origin: " COUNTRY

	if [[ -z "$COUNTRY" ]]; then
		echo "Country cannot be empty!"
	else
		break
	fi
done

greeting="Hello $NAME, you are $AGE years old, you are from $COUNTRY and you are an $age_category."

echo "$(date '+%Y-%m-%d %H:%M:%S') - $greeting" >> logs/user_info.log

# Finnaly, we display greeting
echo "$greeting"

