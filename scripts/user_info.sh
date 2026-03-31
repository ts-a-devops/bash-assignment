#!/bin/bash

#Prompt user for a valid  name (must not be empty and must not contain digits)
name=""
while [[ -z $name || $name =~ [0-9] ]]
do
    read -p "Please enter your name: " name
    if [[ -z $name ]]; then
	echo "Name can't be empty, Input a valid name"
    elif [[ $name =~ [0-9] ]]; then
	  echo "Name can't contain  digits, input a valid name"
    fi
done

#Prompt user for age such that age must be numeric age (only digits)
age=""
until [[ $age =~ ^[0-9]+$ ]]
do
    read -p "Please enter only numeric age: " age
    if [[ ! $age =~ ^[0-9]+$ ]]; then
        echo "Age must be numeric!"
    fi
done

#Prompt user to enter country:
read -p "Enter your country: " country

#greeting message
echo "Hello $name! Its good to have you"

if [[ $age -lt 18 ]]; then
    echo "Your age category is: Minor"
elif [[ $age -ge 18 && $age -le 65 ]]; then
    echo "Your age category is: Adult"
else
  echo "Your age category is: Senior"
fi

echo "Your country is: $country "

#Confirmation for correct details and handling issues gracefully
while true
do
    read -p "Is this correct  y or n ?: " feedback
    if [[ $feedback == "y" ]]; then
	    break
    else
        echo "Enter details again"
	read -p "Please enter your name: " name
	read -p "Please enter numeric age: " age
	read -p "Enter your country of nationality: " country
	echo "Hello $name! Its good to have you"
        if [[ $age -lt 18 ]]; then
            echo "Your age category is: Minor"
        elif [[ $age -ge 18 && $age -le 65 ]]; then
             echo "Your age category is: Adult"
        else
             echo "Your age category is: Senior"
        fi
	echo "Your country is: $country "
    fi
done
echo "Thank you! Have a nice day $name!"

#save output to log/user_input.log
{ 
 echo "name is $name" 
 echo "age is $age"
 echo "country is $country" 
} >> ../logs/user_info.log



