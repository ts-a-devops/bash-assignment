#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/file_manager.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <command> [arguments]"
    echo "Commands: create <file>, delete <file>, list [dir], rename <old> <new>"
    exit 1
fi

action="$1"
shift

case "${action}" in
    create)
        if [[ $# -ne 1 ]]; then
            echo "Usage: $0 create <filename>"
            exit 1
        fi
        file="$1"
        if [[ -e "${file}" ]]; then
            log "ERROR: File already exists - ${file}"
            echo "Error: File '${file}' already exists. Not overwriting."
            exit 1
        fi
        touch "${file}"
        log "CREATE: ${file}"
        echo "File '${file}' created."
        ;;

    delete)
        if [[ $# -ne 1 ]]; then
            echo "Usage: $0 delete <filename>"
            exit 1
        fi
        file="$1"
        if [[ ! -e "${file}" ]]; then
            log "ERROR: File not found - ${file}"
            echo "Error: File '${file}' not found."
            exit 1
        fi
        rm -f "${file}"
        log "DELETE: ${file}"
        echo "File '${file}' deleted."
        ;;

    list)
        dir="${1:-.}"
        if [[ ! -d "${dir}" ]]; then
            log "ERROR: Directory not found - ${dir}"
            echo "Error: Directory '${dir}' not found."
            exit 1
        fi
        log "LIST: ${dir}"
        echo "Contents of ${dir}:"
        ls -la "${dir}"
        ;;

    rename)
        if [[ $# -ne 2 ]]; then
            echo "Usage: $0 rename <oldname> <newname>"
            exit 1
        fi
        old="$1"
        new="$2"
        if [[ ! -e "${old}" ]]; then
            log "ERROR: Source file not found - ${old}"
            echo "Error: '${old}' not found."
            exit 1
        fi
        if [[ -e "${new}" ]]; then
            log "ERROR: Target already exists - ${new}"
            echo "Error: '${new}' already exists."
            exit 1
        fi
        mv "${old}" "${new}"
        log "RENAME: ${old} -> ${new}"
        echo "Renamed '${old}' to '${new}'."
        ;;

    *)
        echo "Unknown command: ${action}"
        echo "Supported: create, delete, list, rename"
        exit 1
        ;;
esac
