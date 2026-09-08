#!/bin/bash

#Log file to store user_info logs
Log_File="logs/user_info.log"

#Prompt to read Name input
read -p "Enter your name: " NAME

#Checks if there is missing or invalid name
if [[ -z "$NAME" ]]; then
    echo "Name must be valid."
fi 

#Prompt to read Age input
read -p "Enter your Age: " AGE

#Validates if age is numeric
if [[ ! "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Age must be numeric"
fi

#Prompt to read Country input
read -p "Enter your Country: " COUNTRY 

#Validate user's input
if [[ -z "$COUNTRY" ]]; then
    echo "Country must be valid."
fi 

# Age Category

#Checks if user is less than 18
if [[ "$AGE" -lt 18 ]]; then
    Category="Minor"

#Checks if user is less than 65
elif [[ "$AGE" -le 65 ]]; then
      Category="Adult"

#Checks if user is greater than 65
else
    Category="Senior"
fi


echo "Hi my name is $NAME, i am from $COUNTRY and i am $AGE years old"
echo "Category: $Category"

#log_output
{
    echo "Date: $(date)"
    echo "Name: $NAME"
    echo "Age: $AGE"
    echo "Country: $COUNTRY"
    echo "Category: $Category"
} >> "$Log_File"
