#!/bin/bash

# Temporary file to store the concatenated Python code
TEMP_FILE=$(mktemp)

# Find all .py files, excluding unwanted folders (e.g., __pycache__ and venv)
find . -type f -name "*.py" ! -path "*/__pycache__/*" ! -path "*/venv/*" | while read -r file; do
    echo "### File: $file ###" >> "$TEMP_FILE"
    
    # Add only the first 100 lines of each file (adjust as needed)
    head -n 100 "$file" >> "$TEMP_FILE"
    
    echo -e "\n" >> "$TEMP_FILE"
done

# Copy the concatenated content to the clipboard
if command -v xclip &> /dev/null; then
    cat "$TEMP_FILE" | xclip -selection clipboard
    echo "The content has been copied to the clipboard using xclip."
elif command -v pbcopy &> /dev/null; then
    cat "$TEMP_FILE" | pbcopy
    echo "The content has been copied to the clipboard using pbcopy."
else
    echo "Neither xclip nor pbcopy is installed. Please install one of them to copy to the clipboard."
fi

# Remove the temporary file
rm "$TEMP_FILE"
