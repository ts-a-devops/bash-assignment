#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="logs/file_manager.log"

action=${1:-}
filename=${2:-}
newname=${3:-}

case "$action" in
    create)
            if [[ -e "$filename" ]]; then
                        echo "File already exists!" | tee -a "$LOG_FILE"
                                    exit 1
                                            fi
                                                    touch "$filename"
                                                            echo "Created $filename" | tee -a "$LOG_FILE"
                                                                    ;;

                                                                        delete)
                                                                                if [[ ! -e "$filename" ]]; then
                                                                                            echo "File does not exist!" | tee -a "$LOG_FILE"
                                                                                                        exit 1
                                                                                                                fi
                                                                                                                        rm "$filename"
                                                                                                                                echo "Deleted $filename" | tee -a "$LOG_FILE"
                                                                                                                                        ;;

                                                                                                                                            list)
                                                                                                                                                    ls -lh | tee -a "$LOG_FILE"
                                                                                                                                                            ;;

                                                                                                                                                                rename)
                                                                                                                                                                        if [[ ! -e "$filename" ]]; then
                                                                                                                                                                                    echo "File not found!" | tee -a "$LOG_FILE"
                                                                                                                                                                                                exit 1
                                                                                                                                                                                                        fi
                                                                                                                                                                                                                if [[ -e "$newname" ]]; then
                                                                                                                                                                                                                            echo "Target name already exists!" | tee -a "$LOG_FILE"
                                                                                                                                                                                                                                        exit 1
                                                                                                                                                                                                                                                fi
                                                                                                                                                                                                                                                        mv "$filename" "$newname"
                                                                                                                                                                                                                                                                echo "Renamed $filename to $newname" | tee -a "$LOG_FILE"
                                                                                                                                                                                                                                                                        ;;

                                                                                                                                                                                                                                                                            *)
                                                                                                                                                                                                                                                                                    echo "Usage: $0 {create|delete|list|rename} filename [newname]"
                                                                                                                                                                                                                                                                                            ;;
                                                                                                                                                                                                                                                                                            esac
