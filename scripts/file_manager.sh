#!/bin/bash

LOG_FILE="logs/file_manager.log"

action=$1
file=$2
new_name=$3

echo "Action: $action" >> "$LOG_FILE"

case $action in
	    create)
		            if [[ -z "$file" ]]; then
				                echo "Error: No filename provided" | tee -a "$LOG_FILE"
						            exit 1
							            fi

								            if [[ -e "$file" ]]; then
										                echo "File already exists: $file" | tee -a "$LOG_FILE"
												        else
														            touch "$file"
															                echo "File created: $file" | tee -a "$LOG_FILE"
																	        fi
																		        ;;

																			    delete)
																				            if [[ -z "$file" ]]; then
																						                echo "Error: No filename provided" | tee -a "$LOG_FILE"
																								            exit 1
																									            fi

																										            if [[ -e "$file" ]]; then
																												                rm "$file"
																														            echo "File deleted: $file" | tee -a "$LOG_FILE"
																															            else
																																	                echo "File not found: $file" | tee -a "$LOG_FILE"
																																			        fi
																																				        ;;

																																					    list)
																																						            ls -l | tee -a "$LOG_FILE"
																																							            ;;

																																								        rename)
																																										        if [[ -z "$file" || -z "$new_name" ]]; then
																																												            echo "Error: Provide old and new filename" | tee -a "$LOG_FILE"
																																													                exit 1
																																															        fi

																																																        if [[ -e "$file" ]]; then
																																																		            mv "$file" "$new_name"
																																																			                echo "Renamed $file to $new_name" | tee -a "$LOG_FILE"
																																																					        else
																																																							            echo "File not found: $file" | tee -a "$LOG_FILE"
																																																								            fi
																																																									            ;;

																																																										        *)
																																																												        echo "Usage: $0 {create|delete|list|rename}" | tee -a "$LOG_FILE"
																																																													        ;;
																																																												esac
