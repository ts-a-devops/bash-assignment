#!/bin/bash

# Exit on error
set -e

# Log file
LOG_FILE="../logs/file_manager.log"

# Ensure logs directory exists
mkdir -p ../logs

# Validate command input
if [ $# -lt 1 ]; then
	    echo "Usage: $0 {create|delete|list|rename} [filename]"
	        exit 1
fi

command=$1
file1=$2
file2=$3

case "$command" in

	    create)
		            if [ -z "$file1" ]; then
				                echo "Error: Please provide a filename to create."
						            exit 1
							            fi

								            if [ -e "$file1" ]; then
										                echo "Error: File already exists."
												            echo "$(date) - CREATE FAILED: $file1 already exists" >> "$LOG_FILE"
													            else
															                touch "$file1"
																	            echo "File '$file1' created successfully."
																		                echo "$(date) - CREATED: $file1" >> "$LOG_FILE"
																				        fi
																					        ;;

																						    delete)
																							            if [ -z "$file1" ]; then
																									                echo "Error: Please provide a filename to delete."
																											            exit 1
																												            fi

																													            if [ ! -e "$file1" ]; then
																															                echo "Error: File does not exist."
																																	            echo "$(date) - DELETE FAILED: $file1 not found" >> "$LOG_FILE"
																																		            else
																																				                rm "$file1"
																																						            echo "File '$file1' deleted."
																																							                echo "$(date) - DELETED: $file1" >> "$LOG_FILE"
																																									        fi
																																										        ;;

																																											    list)
																																												            echo "Listing files in current directory:"
																																													            ls -lh
																																														            echo "$(date) - LISTED files" >> "$LOG_FILE"
																																															            ;;

																																																        rename)
																																																		        if [ -z "$file1" ] || [ -z "$file2" ]; then
																																																				            echo "Error: Provide source and target filenames."
																																																					                exit 1
																																																							        fi

																																																								        if [ ! -e "$file1" ]; then
																																																										            echo "Error: Source file does not exist."
																																																											                echo "$(date) - RENAME FAILED: $file1 not found" >> "$LOG_FILE"
																																																													        elif [ -e "$file2" ]; then
																																																															            echo "Error: Target file already exists."
																																																																                echo "$(date) - RENAME FAILED: $file2 already exists" >> "$LOG_FILE"
																																																																		        else
																																																																				            mv "$file1" "$file2"
																																																																					                echo "Renamed '$file1' to '$file2'."
																																																																							            echo "$(date) - RENAMED: $file1 to $file2" >> "$LOG_FILE"
																																																																								            fi
																																																																									            ;;

																																																																										        *)
																																																																												        echo "Invalid command. Use: create, delete, list, rename"
																																																																													        exit 1
																																																																														        ;;

																																																																														esac
