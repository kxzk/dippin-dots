#!/usr/bin/env fish

# Check if GNU Parallel is installed
if not command -v parallel >/dev/null
    echo "GNU Parallel is not installed. Please install it to use this script."
    exit 1
end

# Function to process a single file
function process_file
    set file_path $argv[1]
    set line_count (wc -l < $file_path)
    echo "$line_count $file_path"
end

# Export the function so it's available to parallel
funcsave process_file >/dev/null 2>&1

echo -e "[lines]\t[file]"
echo -e "-----\t----"
find app/models -type f | parallel process_file | sort -rn | head -n 10 | while read -l count file
    echo -e "$count\t$file"
end

# Clean up the exported function
functions -e process_file
rm -rf /Users/kade.killary/.config/fish/functions/process_file.fish
