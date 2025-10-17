#!/bin/bash

show_error() {
    echo "Error: $1"
    zenity --error --text "$1" &> /dev/null
}

# Load environment variables
source "$(dirname "$0")/.env"
if [[ -z $PATH_TO_PHOMEMO_TOOLS ]]; then
    show_error "Phomemo tools path is not set."
    exit 1
fi

# Check if phomemo-filter.py exists
if [[ -e "$PATH_TO_PHOMEMO_TOOLS/tools/phomemo-filter.py" ]]; then
    PHENOMENO_FILTER_PATH="$PATH_TO_PHOMEMO_TOOLS/tools/phomemo-filter.py"
else
    show_error "Phomemo tools not found at: $PATH_TO_PHOMEMO_TOOLS"
    exit 1
fi

[[ -z $1 ]] && echo "Usage: $0 [png_file_to_print]"
file=$1

rfcomm=$(rfcomm | awk '/tty-attached/ {gsub(":", "", $1); print $1}')
if [[ -z $rfcomm ]]; then
    show_error "Printer is not connected (in serial mode)"
else
    zenity --notification --window-icon=info --text "Printing in progress ..."
    "$PHENOMENO_FILTER_PATH" "$file" > /dev/$rfcomm
fi
