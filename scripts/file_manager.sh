#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_DIR="${PROJECT_ROOT}/logs"
LOG_FILE="${LOG_DIR}/file_manager.log"

mkdir -p "${LOG_DIR}"

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

log_message() {
  printf '[%s] %s\n' "$(timestamp)" "$1" >> "${LOG_FILE}"
}

usage() {
  cat <<'EOF'
Usage:
  ./file_manager.sh create <file>
  ./file_manager.sh delete <file>
  ./file_manager.sh list [directory]
  ./file_manager.sh rename <old_name> <new_name>
EOF
}

command_name="${1:-}"

case "${command_name}" in
  create)
    file_name="${2:-}"
    if [[ -z "${file_name}" ]]; then
      usage
      exit 1
    fi

    if [[ -e "${file_name}" ]]; then
      message="Create failed. '${file_name}' already exists."
      echo "${message}"
      log_message "${message}"
      exit 1
    fi

    touch "${file_name}"
    message="Created file '${file_name}'."
    echo "${message}"
    log_message "${message}"
    ;;
  delete)
    file_name="${2:-}"
    if [[ -z "${file_name}" ]]; then
      usage
      exit 1
    fi

    if [[ ! -e "${file_name}" ]]; then
      message="Delete failed. '${file_name}' does not exist."
      echo "${message}"
      log_message "${message}"
      exit 1
    fi

    rm -f "${file_name}"
    message="Deleted '${file_name}'."
    echo "${message}"
    log_message "${message}"
    ;;
  list)
    target_dir="${2:-.}"
    if [[ ! -d "${target_dir}" ]]; then
      message="List failed. '${target_dir}' is not a directory."
      echo "${message}"
      log_message "${message}"
      exit 1
    fi

    ls -la "${target_dir}"
    log_message "Listed contents of '${target_dir}'."
    ;;
  rename)
    old_name="${2:-}"
    new_name="${3:-}"
    if [[ -z "${old_name}" || -z "${new_name}" ]]; then
      usage
      exit 1
    fi

    if [[ ! -e "${old_name}" ]]; then
      message="Rename failed. '${old_name}' does not exist."
      echo "${message}"
      log_message "${message}"
      exit 1
    fi

    if [[ -e "${new_name}" ]]; then
      message="Rename failed. '${new_name}' already exists."
      echo "${message}"
      log_message "${message}"
      exit 1
    fi

    mv "${old_name}" "${new_name}"
    message="Renamed '${old_name}' to '${new_name}'."
    echo "${message}"
    log_message "${message}"
    ;;
  *)
    usage
    exit 1
    ;;
esac
