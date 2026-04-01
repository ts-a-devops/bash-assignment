#!/bin/bash

# =========================================================
# FILE MANAGER SCRIPT (Beginner Version)
# Supports: create, delete, list, rename
# Logs all actions to logs/file_manager.log
# =========================================================


# ---------------- SETUP LOG DIRECTORY ----------------

log_dir="logs"
log_file="${log_dir}/file_manager.log"

# Check if logs directory exists, create if not
if [[ ! -d "$log_dir" ]]; then
  mkdir -p "$log_dir"
fi


# ---------------- VALIDATION ----------------

if [[ $# -lt 1 ]]; then
  echo "Usage:"
  echo "  $0 create <file>"
  echo "  $0 delete <file>"
  echo "  $0 list"
  echo "  $0 rename <old_name> <new_name>"
  exit 1
fi


command=$1


# =========================================================
# CREATE FILE
# =========================================================

if [[ "$command" == "create" ]]; then

  file=$2

  if [[ -z "$file" ]]; then
    echo "Error: No file name provided."
    exit 1
  fi

  if [[ -e "$file" ]]; then
    echo "Error: File already exists."
    echo "$(date): CREATE FAILED - $file already exists" >> "$log_file"
    exit 1
  fi

  touch "$file"
  echo "File created: $file"
  echo "$(date): CREATED - $file" >> "$log_file"
fi


# =========================================================
# DELETE FILE
# =========================================================

if [[ "$command" == "delete" ]]; then

  file=$2

  if [[ -z "$file" ]]; then
    echo "Error: No file name provided."
    exit 1
  fi

  if [[ ! -e "$file" ]]; then
    echo "Error: File does not exist."
    echo "$(date): DELETE FAILED - $file not found" >> "$log_file"
    exit 1
  fi

  rm "$file"
  echo "File deleted: $file"
  echo "$(date): DELETED - $file" >> "$log_file"
fi


# =========================================================
# LIST FILES
# =========================================================

if [[ "$command" == "list" ]]; then

  echo "Files in current directory:"
  ls -l

  echo "$(date): LISTED files in $(pwd)" >> "$log_file"
fi


# =========================================================
# RENAME FILE
# =========================================================

if [[ "$command" == "rename" ]]; then

  old_name=$2
  new_name=$3

  if [[ -z "$old_name" || -z "$new_name" ]]; then
    echo "Error: Provide old and new file names."
    exit 1
  fi

  if [[ ! -e "$old_name" ]]; then
    echo "Error: Source file does not exist."
    echo "$(date): RENAME FAILED - $old_name not found" >> "$log_file"
    exit 1
  fi

  if [[ -e "$new_name" ]]; then
    echo "Error: Target file already exists."
    echo "$(date): RENAME FAILED - $new_name already exists" >> "$log_file"
    exit 1
  fi

  mv "$old_name" "$new_name"
  echo "Renamed $old_name → $new_name"
  echo "$(date): RENAMED - $old_name to $new_name" >> "$log_file"
fi
