#!/bin/bash

# Specify the folder where the files are located
folder_path="/workspaces/Lilia-Experimental/lilia/modularity"

# Perform the file renaming for the specific case
find "$folder_path" -type f -name "*sshared.lua*" -exec bash -c '
    for file; do
        new_name="${file//sshared.lua/server.lua}"
        if [ "$file" != "$new_name" ]; then
            mv "$file" "$new_name"
        fi
    done
' _ {} +
echo "File renaming completed for specific case."
