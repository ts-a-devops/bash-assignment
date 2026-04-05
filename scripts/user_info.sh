#!/bin/bash

LOG_FOLDER="logs"
LOG_FILE="$LOG_FOLDER/user_info.log"

# ensure the log directory exist
cd ..
mkdir -p "$LOG_FOLDER"

read -p "Enter name: " name
read -p "Enter age: " age
read -p "Enter country: " country

echo "My name is $name and I am from $country." | tee -a "$LOG_FILE"

{
   if [[ $age -gt 0 ]]; then
      if [[ $age -lt 18 ]]; then
         echo "Age is $age. This is a minor."
      elif [[ $age -ge 18 && $age -le 65 ]]; then
         echo "Age is $age. This is an adult."
      else
         echo "Age is $age. This is a senior."
      fi
   else
      echo "Age not valid."
   fi
} | tee -a "$LOG_FILE"
