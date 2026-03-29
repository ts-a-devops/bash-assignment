#!/bin/bash

echo "Enter the your details"

echo "================================"
read -p "Enter your name:" Name
read -p "Enter your age:" Age
read -p "Enter your country:" Country

{
echo "============ Hello, this is $Name, Welcome to my space ==================="
echo "My name is $Name"
echo "I am $Age years old"
echo "I am from $Country"

echo "==============================="

echo "AGE VALIDATION"

if ! [[ $Age =~ ^[0-9]+$ ]]
then 
    echo "Invalid output"
fi
if [ $Age -lt  18 ]
then 
    echo "You are a minor"
elif [ $Age -ge 18 ] && [ $Age -le 65 ]
then 
   echo "Your are an Adult"
else 
     echo "Your are a senior"
fi
} >> logs/user_info.log   
