#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# ========== Paths ==================================================
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"
mkdir -p logs
LOG_FILE="logs/file_manager.log"

# ========== Help ==================================================
show_help() {
    sed -n '/^##HELP_START/,/^##HELP_END/p' "$0" \
        | grep -v '^##HELP' \
        | sed 's/^# \{0,1\}//'
}

make_help() {
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║           file_manager.sh  —  Help           ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
    show_help
}

##HELP_START
# DESCRIPTION
#   Manage files with a single unified command. Supports creating, deleting,
#   copying, moving, renaming, listing, viewing, searching, and backing up files.
#
# USAGE
#   ./file_manager.sh <action> <source> [dest/pattern]
#
# ACTIONS
#   create   <file>               Create a new empty file
#   delete   <file>               Delete a file
#   copy     <src>  <dest>        Copy src to dest (prompts if dest exists)
#   move     <src>  <dest>        Move src to dest (prompts if dest exists)
#   rename   <old>  <new>         Rename a file (dest must not already exist)
#   list     <dir>                List contents of a directory
#   view     <file>               Print file contents to stdout
#   edit     <file>               Open file in nano
#   search   <file> <pattern>     Search for a pattern inside a file (grep -n)
#   backup   <file>               Copy file to <file>.backup.<timestamp>
#
# EXAMPLES
#   ./file_manager.sh create  notes.txt
#   ./file_manager.sh delete  notes.txt
#   ./file_manager.sh copy    notes.txt  notes_copy.txt
#   ./file_manager.sh move    notes.txt  archive/notes.txt
#   ./file_manager.sh rename  old.txt    new.txt
#   ./file_manager.sh list    ./logs
#   ./file_manager.sh view    logs/file_manager.log
#   ./file_manager.sh search  logs/file_manager.log  "copy"
#   ./file_manager.sh backup  logs/file_manager.log
##HELP_END

[[ $# -eq 0 ]] && { make_help; exit 0; }
[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && { make_help; exit 0; }

ACTION="${1}"; SOURCE="${2:-}"; DEST="${3:-}"

# ========== Shared helpers ========================================
# IMPORTANT: all guards use || to chain the error so that a false
# condition never produces a bare exit 1 that errexit intercepts.
# Pattern: condition_that_means_bad || { error; exit 1; }
# This way errexit only fires on genuine unexpected failures.

require_source() {
    [[ -z "$SOURCE" ]]  && { echo -e "${RED}Error: Source required${NC}";        exit 1; }
    [[ ! -e "$SOURCE" ]] && { echo -e "${RED}Error: '$SOURCE' not found${NC}";   exit 1; }
    return 0
}

require_dest() {
    [[ -z "$DEST" ]] && { echo -e "${RED}Error: Destination required${NC}"; exit 1; }
    return 0
}

require_dir() {
    [[ ! -d "$SOURCE" ]] && { echo -e "${RED}Error: '$SOURCE' is not a directory${NC}"; exit 1; }
    return 0
}

# Safe existence check — avoids bare [[ -e ]] which exits 1 on false
# and triggers errexit. We use if/then instead.
file_exists() {
    if [[ -e "$1" ]]; then return 0; else return 1; fi
}

confirm_overwrite() {
    if file_exists "$DEST"; then
        echo -e "${YELLOW}Warning: '$DEST' already exists${NC}"
        read -r -p "Overwrite? (y/n): " -n 1; echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 0; fi
    fi
    return 0
}

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $ACTION | $SOURCE${DEST:+ -> $DEST}" >> "$LOG_FILE"
    echo -e "${GREEN}✓ Logged to $LOG_FILE${NC}"
}

# ========== Dispatch ==============================================
case "$ACTION" in
    create)
        [[ -z "$SOURCE" ]] && { echo -e "${RED}Error: Source required${NC}"; exit 1; }
        if file_exists "$SOURCE"; then
            echo -e "${RED}Error: '$SOURCE' already exists${NC}"; exit 1
        fi
        touch "$SOURCE"
        echo -e "${GREEN}✓ Created '$SOURCE'${NC}"
        ;;

    delete)
        require_source
        rm -f "$SOURCE"
        echo -e "${GREEN}✓ Deleted '$SOURCE'${NC}"
        ;;

    copy)
        require_source; require_dest
        confirm_overwrite
        cp "$SOURCE" "$DEST"
        echo -e "${GREEN}✓ Copied '$SOURCE' → '$DEST'${NC}"
        ;;

    move)
        require_source; require_dest
        confirm_overwrite
        mv "$SOURCE" "$DEST"
        echo -e "${GREEN}✓ Moved '$SOURCE' → '$DEST'${NC}"
        ;;

    rename)
        require_source; require_dest
        if file_exists "$DEST"; then
            echo -e "${RED}Error: '$DEST' already exists${NC}"; exit 1
        fi
        mv "$SOURCE" "$DEST"
        echo -e "${GREEN}✓ Renamed '$SOURCE' → '$DEST'${NC}"
        ;;

    list)
        [[ -z "$SOURCE" ]] && { echo -e "${RED}Error: Source required${NC}"; exit 1; }
        require_dir
        echo "Contents of '$SOURCE':"
        echo "---"
        ls -lah "$SOURCE"
        echo "---"
        ;;

    view)
        require_source
        echo "Contents of '$SOURCE':"
        echo "---"
        cat "$SOURCE"
        echo "---"
        ;;

    edit)
        require_source
        nano "$SOURCE"
        ;;

    search)
        require_source
        [[ -z "$DEST" ]] && { echo -e "${RED}Error: Search pattern required${NC}"; exit 1; }
        echo "Matches for '$DEST' in '$SOURCE':"
        echo "---"
        grep -n "$DEST" "$SOURCE" || echo "(no matches found)"
        echo "---"
        ;;

    backup)
        require_source
        local_dest="${SOURCE}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$SOURCE" "$local_dest"
        echo -e "${GREEN}✓ Backed up to '$local_dest'${NC}"
        DEST="$local_dest"
        ;;

    *)
        echo -e "${RED}Error: Unknown action '$ACTION'${NC}"
        exit 1
        ;;
esac

log_action


# ========== Tests =================================================
#
# HOW THIS WORKS
# ──────────────────────────────────────────────────────────────────
# All test artefacts live under /tmp/fm_test/ so the working tree
# stays clean and tests are repeatable (setup step wipes and recreates it).
#
# Order matters:
#   setup → create → view → search → copy → rename → list → backup → delete → cleanup
#
# The overwrite prompt sends "n\n" via printf to decline — same
# heredoc pipe technique as user_info.sh.
#
# edit is intentionally skipped — nano requires an interactive TTY.
#
# search uses || true so that grep finding no matches doesn't fail
# the step — the script itself now prints "(no matches found)" safely.
#
##TEST_START
# rm -rf /tmp/fm_test && mkdir -p /tmp/fm_test
# bash ./scripts/file_manager.sh --help > /tmp/fm_test_help.out 2>&1
# grep -q "DESCRIPTION" /tmp/fm_test_help.out && echo "help output ok"
# bash ./scripts/file_manager.sh > /tmp/fm_test_noarg.out 2>&1
# grep -q "DESCRIPTION" /tmp/fm_test_noarg.out && echo "no arg shows help ok"
# bash ./scripts/file_manager.sh create /tmp/fm_test/hello.txt > /tmp/fm_test_create.out 2>&1
# grep -q "Created" /tmp/fm_test_create.out && echo "create action ok"
# test -f /tmp/fm_test/hello.txt && echo "create: file exists on disk ok"
# bash ./scripts/file_manager.sh create /tmp/fm_test/hello.txt > /tmp/fm_test_create_dup.out 2>&1; [[ $? -ne 0 ]] && echo "create: duplicate prevented ok" || echo "FAIL: should have exited non-zero"
# grep -q "already exists" /tmp/fm_test_create_dup.out && echo "create: duplicate error message ok"
# echo "hello world" > /tmp/fm_test/hello.txt
# bash ./scripts/file_manager.sh view /tmp/fm_test/hello.txt > /tmp/fm_test_view.out 2>&1
# grep -q "hello world" /tmp/fm_test_view.out && echo "view action ok"
# bash ./scripts/file_manager.sh search /tmp/fm_test/hello.txt "hello" > /tmp/fm_test_search.out 2>&1
# grep -q "hello" /tmp/fm_test_search.out && echo "search action ok"
# bash ./scripts/file_manager.sh search /tmp/fm_test/hello.txt > /tmp/fm_test_search_nopat.out 2>&1; [[ $? -ne 0 ]] && echo "search: missing pattern exit code ok" || echo "FAIL: should have exited non-zero"
# grep -q "Search pattern required" /tmp/fm_test_search_nopat.out && echo "search: missing pattern message ok"
# bash ./scripts/file_manager.sh copy /tmp/fm_test/hello.txt /tmp/fm_test/hello_copy.txt > /tmp/fm_test_copy.out 2>&1
# test -f /tmp/fm_test/hello_copy.txt && echo "copy action ok"
# printf "n\n" | bash ./scripts/file_manager.sh copy /tmp/fm_test/hello.txt /tmp/fm_test/hello_copy.txt > /tmp/fm_test_copy_overwrite.out 2>&1
# grep -q "already exists" /tmp/fm_test_copy_overwrite.out && echo "copy: overwrite prompt shown ok"
# bash ./scripts/file_manager.sh rename /tmp/fm_test/hello_copy.txt /tmp/fm_test/hello_renamed.txt > /tmp/fm_test_rename.out 2>&1
# test -f /tmp/fm_test/hello_renamed.txt && echo "rename action ok"
# test ! -f /tmp/fm_test/hello_copy.txt && echo "rename: original removed ok"
# bash ./scripts/file_manager.sh rename /tmp/fm_test/hello.txt /tmp/fm_test/hello_renamed.txt > /tmp/fm_test_rename_dup.out 2>&1; [[ $? -ne 0 ]] && echo "rename: overwrite prevented ok" || echo "FAIL: should have exited non-zero"
# bash ./scripts/file_manager.sh list /tmp/fm_test > /tmp/fm_test_list.out 2>&1
# grep -q "hello.txt" /tmp/fm_test_list.out && echo "list action ok"
# bash ./scripts/file_manager.sh list /tmp/fm_test/hello.txt > /tmp/fm_test_list_notdir.out 2>&1; [[ $? -ne 0 ]] && echo "list: non-dir exit code ok" || echo "FAIL: should have exited non-zero"
# grep -q "not a directory" /tmp/fm_test_list_notdir.out && echo "list: non-dir message ok"
# bash ./scripts/file_manager.sh backup /tmp/fm_test/hello.txt > /tmp/fm_test_backup.out 2>&1
# grep -q "Backed up" /tmp/fm_test_backup.out && echo "backup action ok"
# ls /tmp/fm_test/hello.txt.backup.* 1>/dev/null 2>&1 && echo "backup: file created ok"
# bash ./scripts/file_manager.sh move /tmp/fm_test/hello_renamed.txt /tmp/fm_test/hello_moved.txt > /tmp/fm_test_move.out 2>&1
# test -f /tmp/fm_test/hello_moved.txt && echo "move action ok"
# test ! -f /tmp/fm_test/hello_renamed.txt && echo "move: original removed ok"
# bash ./scripts/file_manager.sh delete /tmp/fm_test/hello.txt > /tmp/fm_test_delete.out 2>&1
# test ! -f /tmp/fm_test/hello.txt && echo "delete action ok"
# bash ./scripts/file_manager.sh delete /tmp/fm_test/nonexistent.txt > /tmp/fm_test_delete_missing.out 2>&1; [[ $? -ne 0 ]] && echo "delete: missing file exit code ok" || echo "FAIL: should have exited non-zero"
# bash ./scripts/file_manager.sh unknown_action /tmp/fm_test/hello.txt > /tmp/fm_test_badaction.out 2>&1; [[ $? -ne 0 ]] && echo "unknown action exit code ok" || echo "FAIL: should have exited non-zero"
# grep -q "Unknown action" /tmp/fm_test_badaction.out && echo "unknown action message ok"
# tail -20 logs/file_manager.log | grep -q "create" && echo "log has create entry ok"
# tail -20 logs/file_manager.log | grep -q "copy" && echo "log has copy entry ok"
# tail -20 logs/file_manager.log | grep -q "delete" && echo "log has delete entry ok"
# rm -rf /tmp/fm_test
##TEST_END