#!/bin/bash

# Define the source directory where the folders are located
source_directory="/workspaces/Lilia-Experimental/lilia/modularity"

# Define the patterns to match folders
sv_module_pattern="sv_module.lua"
cl_module_pattern="cl_module.lua"
sh_module_pattern="sh_module.lua"
sh_config_pattern="sh_config.lua"

# Define the replacement strings
sv_module_replacement="server.lua"
cl_module_replacement="client.lua"
sh_module_replacement="module.lua"
sh_config_replacement="config.lua"

# Use find to locate directories recursively
find "$source_directory" -type d -name "$sv_module_pattern" -print0 | while IFS= read -r -d '' directory; do
    # Generate the new name by replacing sv_module with server
    new_name="${directory//$sv_module_pattern/$sv_module_replacement}"

    # Rename the directory
    mv "$directory" "$new_name"

    echo "Renamed: $directory to $new_name"
done

# Use find to locate directories recursively
find "$source_directory" -type d -name "$cl_module_pattern" -print0 | while IFS= read -r -d '' directory; do
    # Generate the new name by replacing cl_module with client
    new_name="${directory//$cl_module_pattern/$cl_module_replacement}"

    # Rename the directory
