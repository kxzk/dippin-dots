#!/usr/bin/env fish

if not command -v zip >/dev/null
    echo "Error: zip is not installed. Please install it and try again."
    exit 1
end

# get the current directory name
set current_dir (basename (pwd))

# create a zip file with the name of the current directory
zip -r "$current_dir.zip" * -x ".*" "*/.*"

if test $status -eq 0
    echo "[success] zipped into $current_dir.zip"
else
    echo "[error] while zipping the files."
end
