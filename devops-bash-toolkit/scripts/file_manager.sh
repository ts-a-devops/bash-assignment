#!/bin/bash


# Colors to identify errors and passes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'



#Display the guide for the user to know each action
show_help() {
    echo "Available commands:"
    echo "  create <file>     - Create a new file (won't overwrite existing)"
    echo "  delete <file>     - Delete a file (with confirmation)"
    echo "  list              - List all files in current directory"
    echo "  rename <old> <new>- Rename a file (won't overwrite existing)"
    echo "  help              - Show this help"
    echo "  quit              - Exit the script"
}

#Creat a fiel function
create_file() {
    if [[ -z "$1" ]]; then
        echo -e "${RED}Error: Please specify a filename${NC}"
        return 1
    fi
    
    if [[ -e "$1" ]]; then
        echo -e "${RED}Error: File '$1' already exists! Not overwriting.${NC}"
        return 1
    fi
    
    touch "$1" && echo -e "${GREEN}✓ Created: $1${NC}" || echo -e "${RED}Failed to create $1${NC}"
}

#delete a file function
delete_file() {
    if [[ -z "$1" ]]; then
        echo -e "${RED}Error: Please specify a filename${NC}"
        return 1
    fi
    
    if [[ ! -e "$1" ]]; then
        echo -e "${RED}Error: File '$1' does not exist${NC}"
        return 1
    fi
    
    read -p "Are you sure you want to delete '$1'? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm "$1" && echo -e "${GREEN}✓ Deleted: $1${NC}" || echo -e "${RED}Failed to delete $1${NC}"
    else
        echo "Operation cancelled"
    fi
}

#list function
list_files() {
    echo -e "${BLUE}Files in current directory:${NC}"
    echo "----------------------------------------"
    if [[ -n "$(ls -A)" ]]; then
        ls -lh | grep -v '^total' | awk '{print $9, "(" $5 ")"}'
    else
        echo "Directory is empty"
    fi
    echo "----------------------------------------"
    echo "Total: $(ls -1 | wc -l) items"
}

#rename function
rename_file() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo -e "${RED}Error: Please specify old and new filenames${NC}"
        echo "Usage: rename <old_name> <new_name>"
        return 1
    fi
    
    if [[ ! -e "$1" ]]; then
        echo -e "${RED}Error: File '$1' does not exist${NC}"
        return 1
    fi
    
    if [[ -e "$2" ]]; then
        echo -e "${RED}Error: '$2' already exists! Not overwriting.${NC}"
        return 1
    fi
    
    mv "$1" "$2" && echo -e "${GREEN}✓ Renamed: $1 → $2${NC}" || echo -e "${RED}Failed to rename${NC}"
}

#FIle Manager with contextual menu and help
echo "File Manager - Type 'help' for commands"
echo "Working directory: $(pwd)"
echo

while true; do
    echo -n "> "
    read cmd arg1 arg2
    
    case "$cmd" in
        create)   create_file "$arg1" ;;
        delete)   delete_file "$arg1" ;;
        list)     list_files ;;
        rename)   rename_file "$arg1" "$arg2" ;;
        help)     show_help ;;
        quit|exit) 
            echo "Goodbye!"
            exit 0 
            ;;
        "") 
            continue 
            ;;
        *)
            echo -e "${RED}Unknown command: $cmd${NC}"
            echo "Type 'help' for available commands"
            ;;
    esac
    echo
done

#FUnction to log all actions to file_manager.log
LOG_FILE="logs/file_manager.log"

# Helper function to log actions
log_action() {
    local status=$1
    local message=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - [$status] - $message" >> "$LOG_FILE"
}