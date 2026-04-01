#!/bin/bash
action=$1
name=$2
case $action in
  create) touch "$name" && echo "Created $name" ;;
  delete) rm "$name" && echo "Deleted $name" ;;
  list) ls -l ;;
  *) echo "Usage: ./file_manager.sh {create|delete|list}" ;;
esac >> logs/file_manager.log
