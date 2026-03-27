#!/bin/bash

#Input from user

ACTION=$1

TARGET=$2

NEW_NAME=$3

LOG_FILE="logs/myfile_manager.log"

mkdir -p logs

#Create Command

if [[ "$ACTION" == "create" ]]; then

   if [[ -e "$TARGET" ]]; then
       echo "Error: '$TARGET' already exists!" | tee -a "$LOG_FILE"
   else
       touch "$TARGET"
echo "[$(date)] SUCCESS: Created $TARGET" | tee -a "$LOG_FILE"

fi
fi

#Delete Command

if [[ "$ACTION" == "delete" ]]; then

   if [[ -f "$TARGET" ]]; then
       
	   rm "$TARGET"
       echo "[$(date)]'$TARGET' deleted!" | tee -a "$LOG_FILE"
   else
       
echo "$TARGET is not found" | tee -a "$LOG_FILE"

fi
fi

#List Command


